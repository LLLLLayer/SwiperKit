//
//  SWPSwipeController.m
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/13.
//

#import "SWPSwipeable.h"
#import "SWPSwipeAction.h"
#import "SWPSwipeOptions.h"
#import "SWPSwipeController.h"
#import "SWPSwipeActionsView.h"

#import "UIScrollView+Swipe.h"
#import "UIPanGestureRecognizer+ElasticTranslation.h"

@interface SWPSwipeController () <SWPSwipeActionsViewDelegate>

/// 发生滑动的视图
@property (nonatomic,   weak) UIView<SWPSwipeable> *swipeable;
/// 操作视图的容器视图
@property (nonatomic,   weak) UIView *swipeActionsContainerView;

/// 滑动手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
/// 点击手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

/// 动画
@property (nonatomic, strong) UIViewPropertyAnimator *animator;
 
/// 滑动开始时，swipeActionsContainerView 的 center.x
@property (nonatomic, assign) CGFloat originalCenter;
/// 滑动比率
@property (nonatomic, assign) CGFloat scrollRatio;
/// 弹性滑动比率
@property (nonatomic, assign) CGFloat elasticScrollRatio;

@end

@implementation SWPSwipeController

/// 生成实例
/// @param swipeable 发生滑动的视图
/// @param actionsContainerView 操作视图的容器视图
- (instancetype)initWithSwipeable:(UIView<SWPSwipeable> *)swipeable
             actionsContainerView:(UIView *)actionsContainerView
{
    self = [super init];
    if (self) {
        self.swipeable = swipeable;
        self.swipeActionsContainerView = actionsContainerView;
        self.elasticScrollRatio = 0.4;
        [self.swipeable addGestureRecognizer:self.panGestureRecognizer];
        [self.swipeable addGestureRecognizer:self.tapGestureRecognizer];
    }
    return self;
}

- (void)traitCollectionDidChangeFrom:(UITraitCollection *)previousTraitCollection to:(UITraitCollection *)currentTraitCollection
{
    UIView<SWPSwipeable> *swipeable = self.swipeable;
    UIView *actionsContainerView = self.swipeActionsContainerView;
    if (!swipeable || !actionsContainerView) {
        return;
    }
    CGFloat targetOffset = [self __targetCenterWithActive:swipeable.swipeState != SWPSwipeStateCenter];
    actionsContainerView.center = CGPointMake(targetOffset, actionsContainerView.center.y);
    [swipeable.swipeActionsView updateVisibleWidth:fabs(CGRectGetMinX(actionsContainerView.frame))];
    [swipeable layoutIfNeeded];
}

#pragma mark - Action

/// 滑动手势处理
/// @param gesture 滑动手势
- (void)__handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    UIView *target = self.swipeActionsContainerView;
    UIView<SWPSwipeable> *swipeable = self.swipeable;
    if (!target || !swipeable) {
        return;
    }
    
    // 位移速度
    CGPoint velocity = [gesture velocityInView:target];
    
    // 是否允许滑动
    if (![self.delegate respondsToSelector:@selector(swipeController:canBeginEditingSwipeableForOrientation:)] ||
        ![self.delegate swipeController:self canBeginEditingSwipeableForOrientation:
          velocity.x > 0 ? SWPSwipeActionsOrientationLeft : SWPSwipeActionsOrientationRight]) {
        return;
    }
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            // 若已经存在拖动的 Cell，则阻断此次拖动
            for (id<SWPSwipeable> swipeable in self.swipeable.scrollView.swipeables) {
                if (swipeable.swipeState == SWPSwipeStateDragging) {
                    return;
                }
            }
            
            // 打断可能正在进行的动画
            [self __stopAnimatorIfNeeded];
            
            // 保存当前操作视图的容器视图 center.x
            self.originalCenter = target.center.x;
            
            // 如果当前处于中心或以动画形式到中心，则可以添加操作视图
            if (self.swipeable.swipeState == SWPSwipeStateCenter || self.swipeable.swipeState == SWPSwipeStateAnimatingToCenter) {
                SWPSwipeActionsOrientation targetOrientation = velocity.x > 0 ? SWPSwipeActionsOrientationLeft : SWPSwipeActionsOrientationRight;
                [self __showActionsViewForOrientation:targetOrientation];
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            SWPSwipeActionsView *actionsView = swipeable.swipeActionsView;
            if (!actionsView) {
                return;
            }
            
            // 此时逻辑上 swipeState 已经在手势开始时进行了更新，若未处理完手势开始逻辑，则进行阻断
            if (swipeable.swipeState == SWPSwipeStateCenter) {
                return;
            }
            
            // 阻断出现多个滑动视图
            if (swipeable.swipeState == SWPSwipeStateAnimatingToCenter) {
                for (id<SWPSwipeable> swipedCell in swipeable.scrollView.swipeables) {
                    if (swipedCell.swipeState == SWPSwipeStateLeft ||
                        swipedCell.swipeState == SWPSwipeStateRight ||
                        swipedCell.swipeState == SWPSwipeStateDragging) {
                        if (swipedCell != swipeable) {
                            return;
                        }
                    }
                }
            }
            
            // 位移
            CGFloat translation = [gesture translationInView:target].x;
            
            // 滑动比率 1.0，动画跟手
            self.scrollRatio = 1.0;
            
            // 如果用户在滑出一侧的操作视图后，直接进行反方向的滑动，则不展示另一侧的操作视图，同时修改滑动阻尼
            if ((translation + self.originalCenter - CGRectGetMidX(self.swipeable.bounds)) * actionsView.orientation > 0) {
                target.center = CGPointMake([gesture elasticTranslationInView:self.swipeActionsContainerView
                                                                    withLimit:CGSizeZero
                                                           fromOriginalCenter:CGPointMake(self.originalCenter, 0)
                                                                applyingRatio:gesture.defaultElasticTranslationRatio].x, target.center.y);
                self.scrollRatio = self.elasticScrollRatio;
                return;
            }
            
            // 需要做扩展
            SWPSwipeExpansionStyle *expansionStyle = swipeable.swipeActionsView.options.expansionStyle;
            if (expansionStyle && expansionStyle.type != SWPSwipeExpansionStyleTypedestructiveSecondConfirmation) {
                // 如果是 CollectionView 的话，referenceFrame 就是 ContentView 的 Frame
                CGRect referenceFrame = target != swipeable ? target.frame : CGRectNull;
                BOOL expanded = [expansionStyle shouldExpandWithSwipeable:swipeable gesture:gesture inSuperview:swipeable.scrollView withinFrame:referenceFrame];
                CGFloat targetOffset = [expansionStyle targetOffsetForView:swipeable];
                CGFloat currentOffset = fabs(translation + self.originalCenter - CGRectGetMidX(swipeable.bounds));
                
                // 扩展触发
                if (expanded && !actionsView.expanded && targetOffset > currentOffset) {
                    CGFloat centerForTranslationToEdge = CGRectGetMidX(self.swipeable.bounds) - targetOffset * self.swipeable.swipeActionsView.orientation;
                    CGFloat delta = centerForTranslationToEdge - self.originalCenter;
                    [self __animateToOffset:centerForTranslationToEdge withInitialVelocity:0 completion:nil];
                    [gesture setTranslation:CGPointMake(delta, 0) inView:self.swipeable.superview];
                } else {
                    target.center = CGPointMake([gesture elasticTranslationInView:target
                                                                        withLimit:CGSizeMake(targetOffset, 0.0)
                                                               fromOriginalCenter:CGPointMake(self.originalCenter, 0.0)
                                                                    applyingRatio:expansionStyle.targetOverscrollElasticity].x, target.center.y);
                    [actionsView updateVisibleWidth:fabs(CGRectGetMinX(target.frame))];
                }
                
                [actionsView updateExpanded:expanded];
            } else {
                target.center = CGPointMake([gesture elasticTranslationInView:target
                                                                    withLimit:CGSizeMake(actionsView.preferredWidth, 0.0)
                                                           fromOriginalCenter:CGPointMake(self.originalCenter, 0.0)
                                                                applyingRatio:gesture.defaultElasticTranslationRatio].x, target.center.y);
                [actionsView updateVisibleWidth:fabs(CGRectGetMinX(self.swipeActionsContainerView.frame))];
                if ((target.center.x - self.originalCenter) / translation != 1.0) {
                    self.scrollRatio = self.elasticScrollRatio;
                }
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            SWPSwipeActionsView *actionsView = swipeable.swipeActionsView;
            if (!actionsView) {
                return;
            }
            
            // 已经在中心了
            if (swipeable.swipeState == SWPSwipeStateCenter &&
                CGRectGetMidX(swipeable.bounds) == target.center.x)  {
                return;
            }
            
            // 更新 swipeState
            swipeable.swipeState = [self __targetStateForVelocity:velocity];
            
            // 达到滑动目标
            if (actionsView.expanded && [actionsView expandableAction]) {
                [self performWithAction:[actionsView expandableAction]];
            } else {
                CGFloat targetOffset = [self __targetCenterWithActive:swipeable.swipeState != SWPSwipeStateCenter];
                CGFloat distance = targetOffset - self.swipeActionsContainerView.center.x;
                CGFloat normalizedVelocity = velocity.x * self.scrollRatio / distance;
                [self  __animateToOffset:targetOffset withInitialVelocity:normalizedVelocity completion:^(BOOL complete) {
                    if (swipeable.swipeState == SWPSwipeStateCenter) {
                        [self reset];
                    }
                }];
                
                /// 操作视图消失回调
                if (swipeable.swipeState == SWPSwipeStateCenter) {
                    if ([self.delegate respondsToSelector:@selector(swipeController:didEndEditingSwipeableForOrientation:)]) {
                        [self.delegate swipeController:self didEndEditingSwipeableForOrientation:actionsView.orientation];
                    }
                }
            }
            break;
        }
        default:
            break;
    }
}

/// 点击手势处理
/// @param gesture 点击手势
- (void)__handleTapGesture:(UITapGestureRecognizer *)gesture
{
    [self hideSwipeWithAnimated:YES complation:nil];
}

#pragma mark - Private Methond

/// 滑动手势开始，展示操作视图
/// @param orientation  将显示操作视图在单元格的哪一侧
- (BOOL)__showActionsViewForOrientation:(SWPSwipeActionsOrientation)orientation
{
    // 代理未提供操作
    if (![self.delegate respondsToSelector:@selector(swipeController:editActionsForSwipeableForForOrientation:)]) {
        return NO;
    }
    NSArray *actions = [self.delegate swipeController:self editActionsForSwipeableForForOrientation:orientation];
    if (!actions || actions.count == 0) {
        return NO;
    }
    
    // 添加操作视图
    [self __configureActionsViewWithActions:actions forOrientation:orientation];
    
    // 操作视图展示回调
    if ([self.delegate respondsToSelector:@selector(swipeController:willBeginEditingSwipeableForOrientation:)]) {
        [self.delegate swipeController:self willBeginEditingSwipeableForOrientation:orientation];
    }
    
    return YES;
}

/// 滑动手势开始，展示操作视图
/// @param actions 代理提供的需要展示的操作
/// @param orientation 将显示操作视图在单元格的哪一侧
- (void)__configureActionsViewWithActions:(NSArray<SWPSwipeAction *> *)actions
                           forOrientation:(SWPSwipeActionsOrientation)orientation
{
    UIView<SWPSwipeable> *swipeable = self.swipeable;
    UIView *actionsContainerView = self.swipeActionsContainerView;
    if (!swipeable || !actionsContainerView) {
        return;
    }
    
    // 滑动时配置
    SWPSwipeOptions *options;
    if ([self.delegate respondsToSelector:@selector(swipeController:editActionsOptionsForSwipeableForOrientation:)]) {
        options = [self.delegate swipeController:self editActionsOptionsForSwipeableForOrientation:orientation];
    }
    
    // 使用默认配置
    if (!options) {
        options = [[SWPSwipeOptions alloc] init];
    }
    
    // 移除可能存在的操作视图
     [swipeable.swipeActionsView removeFromSuperview];
    swipeable.swipeActionsView = nil;
    
    // 新操作视图
    SWPSwipeActionsView *actionsView = [[SWPSwipeActionsView alloc] initWithOptions:options
                                                                            actions:actions
                                                                        orientation:orientation
                                                                            maxSize:swipeable.bounds.size];
    actionsView.delegate = self;
    
    // 操作视图布局
    [actionsContainerView addSubview:actionsView];
    [NSLayoutConstraint activateConstraints:@[
        [actionsView.heightAnchor constraintEqualToAnchor:swipeable.heightAnchor],
        [actionsView.widthAnchor constraintEqualToAnchor:swipeable.widthAnchor multiplier:2.0],
        [actionsView.topAnchor constraintEqualToAnchor:swipeable.topAnchor]
    ]];
    if (orientation == SWPSwipeActionsOrientationLeft) {
        [[actionsView.rightAnchor constraintEqualToAnchor:actionsContainerView.leftAnchor] setActive:YES];
    } else {
        [[actionsView.leftAnchor constraintEqualToAnchor:actionsContainerView.rightAnchor] setActive:YES];
    }
    [actionsView setNeedsUpdateConstraints];
    
    // 更新状态
    swipeable.swipeActionsView = actionsView;
    swipeable.swipeState = SWPSwipeStateDragging;
}

/// 发生滑动的视图的目标状态
/// @param velocity 滑动速度
- (SWPSwipeState)__targetStateForVelocity:(CGPoint)velocity
{
    if (!self.swipeable.swipeActionsView) {
        return SWPSwipeStateCenter;
    }
    switch (self.swipeable.swipeActionsView.orientation) {
        case SWPSwipeActionsOrientationLeft:
            // 左侧操作露出，在非展开状态，左滑则目标状态为中心，否则为左侧操作露出
            return (velocity.x < 0 && !self.swipeable.swipeActionsView.expanded) ? SWPSwipeStateCenter : SWPSwipeStateLeft;
        case SWPSwipeActionsOrientationRight:
            // 右侧操作露出，在非展开状态，右滑则目标状态为中心，否则为右侧操作露出
            return (velocity.x > 0 && !self.swipeable.swipeActionsView.expanded) ? SWPSwipeStateCenter : SWPSwipeStateRight;
        default:
            return SWPSwipeStateCenter;
    }
}

/// 操作视图的容器视图的目标 center x
/// @param active 当前发生滑动的视图是否非中心状态
- (CGFloat)__targetCenterWithActive:(BOOL)active
{
    if (!self.swipeable) {
        return 0.0;
    }
    if (!self.swipeable.swipeActionsView || !active) {
        return CGRectGetMidX(self.swipeable.bounds);
    }
    // 右侧操作视图漏出则操作视图的容器视图中心左移，左侧操作视图漏出则操作视图的容器视图中心右移
    return CGRectGetMidX(self.swipeable.bounds) - self.swipeable.swipeActionsView.preferredWidth * self.swipeable.swipeActionsView.orientation;
}

/// 动画
/// @param offset 操作视图的容器视图目标 center x
/// @param velocity 在 x 方向的移动速度
/// @param completion 动画完成回调
- (void)__animateToOffset:(CGFloat)offset
      withInitialVelocity:(CGFloat)velocity
               completion:(void(^)(BOOL complete))completion
{
    [self __animateWithDuration:0.7 toOffset:offset withInitialVelocity:velocity completion:completion];
}

/// 动画
/// @param duration 动画期望的持续时间
/// @param offset 操作视图的容器视图目标 center x
/// @param velocity 在 x 方向的移动速度
/// @param completion 动画完成回调
- (void)__animateWithDuration:(CGFloat)duration
                     toOffset:(CGFloat)offset
          withInitialVelocity:(CGFloat)velocity
                   completion:(void(^)(BOOL complation))completion
{
    // 打断进行中的动画
    [self __stopAnimatorIfNeeded];
    [self.swipeable layoutIfNeeded];
    
    // 动画
    UIViewPropertyAnimator *animator = ({
        UIViewPropertyAnimator *animator;
        if (velocity != 0) { // 有速度
            CGVector vector = CGVectorMake(velocity, velocity);
            // 刚度、质量、阻尼系数和初始速度
            // https://developer.apple.com/documentation/uikit/uispringtimingparameters
            UISpringTimingParameters *parameters = [[UISpringTimingParameters alloc] initWithMass:1 stiffness:100 damping:18.0 initialVelocity:vector];
            animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 timingParameters:parameters];
        } else { // 无速度
            animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration dampingRatio:1.0 animations:nil];
        }
        animator;
    });
    
    // 动画内容
    SWPSwipeController * __weak weakSelf = self;
    [animator addAnimations:^{
        SWPSwipeController *strongSelf = weakSelf; if (!strongSelf) { return; }
        strongSelf.swipeActionsContainerView.center = CGPointMake(offset, self.swipeActionsContainerView.center.y);
        [strongSelf.swipeable.swipeActionsView updateVisibleWidth:fabs(CGRectGetMinX(self.swipeActionsContainerView.frame))];
        [strongSelf.swipeable layoutIfNeeded];
    }];
    
    // 完成回调
    if (completion) {
        [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition == UIViewAnimatingPositionEnd);
        }];
    }
    
    self.animator = animator;
    [self.animator startAnimation];
}

- (void)__stopAnimatorIfNeeded
{
    if (self.animator.isRunning) {
        [self.animator stopAnimation:YES];
    }
}

#pragma mark - Getter

/// 滑动手势
- (UIPanGestureRecognizer *)panGestureRecognizer
{
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(__handlePanGesture:)];
        _panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}

/// 点击手势
- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleTapGesture:)];
        _tapGestureRecognizer.delegate = self;
    }
    return _tapGestureRecognizer;
}

#pragma mark - UIGestureRecognizerDelegate

/// 是否处理手势
/// @param gestureRecognizer 需要判断的手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        for (id<SWPSwipeable> swipeable in self.swipeable.scrollView.swipeables) {
            if (swipeable.swipeState != SWPSwipeStateCenter ||
                swipeable.panGestureRecognizer.state == UIGestureRecognizerStateBegan ||
                swipeable.panGestureRecognizer.state == UIGestureRecognizerStateCancelled ||
                swipeable.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
                return YES;
            }
        }
        return NO;
    }
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:panGesture.view];
        return fabs(translation.y) <= fabs(translation.x);
    }
    return YES;
}

#pragma mark - SWPSwipeActionsViewDelegate & Perform

/// 操作视图被点击
/// @param swipeActionsView 操作视图
/// @param action 操作
- (void)swipeActionsView:(SWPSwipeActionsView *)swipeActionsView
         didSelectAction:(SWPSwipeAction *)action
{
    if (self.swipeable.swipeActionsView.options.expansionStyle.type == SWPSwipeExpansionStyleTypedestructiveSecondConfirmation) {
        if (!self.swipeable.swipeActionsView.expanded) {
            [self.swipeable.swipeActionsView updateExpanded:!self.swipeable.swipeActionsView.expanded];
            return;
        }
    }
    [self performWithAction:action];
}

- (void)performWithAction:(SWPSwipeAction *)action
{
    SWPSwipeActionsView *actionsView = self.swipeable.swipeActionsView;
    if (!actionsView) {
        return;
    }
    if (action == actionsView.expandableAction && actionsView.options.expansionStyle) {
        [actionsView updateExpanded:YES];
        switch (actionsView.options.expansionStyle.completionAnimation.completionAnimationType) {
            case SWPCompletionAnimationTypeBounce:
                [self __performWithAction:action hide:YES];
                break;
            case SWPCompletionAnimationTypeFill:
                [self __performFillActionWithAction:action fillOption:actionsView.options.expansionStyle.completionAnimation.fillOptions];
                break;
        }
    } else {
        [self __performWithAction:action hide:action.hidesWhenSelected];
    }
}

- (void)__performWithAction:(SWPSwipeAction *)action hide:(BOOL)hide
{
    NSIndexPath *indexPath = self.swipeable.indexPath;
    if (!indexPath) {
        return;
    }
    if (hide) {
        [self hideSwipeWithAnimated:YES complation:nil];
    }
    if (action.handler) {
        action.handler(action, indexPath);
    }
}

- (void)__performFillActionWithAction:(SWPSwipeAction *)action fillOption:(SWPFillOptions *)filloption
{
    SWPSwipeActionsView *swipeActionsView = self.swipeable.swipeActionsView;
    UIView *swipeActionsContainerView = self.swipeActionsContainerView;
    NSIndexPath *indexPath = self.swipeable.indexPath;
    
    CGFloat newCenter = CGRectGetMidX(self.swipeable.bounds) - (self.swipeable.bounds.size.width + swipeActionsView.minimumButtonWidth) * swipeActionsView.orientation;
    
    SWPSwipeController __weak *weakSelf = self;
    action.completionHandler = ^(SWPExpansionFulfillmentStyle style) {
        SWPSwipeController *strongSelf = weakSelf;
        
        [strongSelf.delegate swipeController:strongSelf didEndEditingSwipeableForOrientation:swipeActionsView.orientation];
        
        switch (style) {
            case SWPExpansionFulfillmentStyleDelete:
            {
                swipeActionsContainerView.maskView = [swipeActionsView createDeletionMask];
                
                CGPoint center = swipeActionsContainerView.center;
                [strongSelf.delegate swipeController:strongSelf didDeleteSwipeableAtIndexPath:indexPath];
                swipeActionsContainerView.center = center;
                [UIView animateWithDuration:0.3 animations:^{
                    swipeActionsContainerView.maskView.frame = CGRectMake(swipeActionsContainerView.maskView.frame.origin.x,
                                                                          swipeActionsContainerView.maskView.frame.origin.y,
                                                                          swipeActionsContainerView.maskView.frame.size.width,
                                                                          0);
                    [swipeActionsView updateVisibleWidth:fabs(CGRectGetMinX(swipeActionsContainerView.frame))];
                    if (filloption.timing == SWPHandlerInvocationTimingWithAfter) {
                        swipeActionsView.alpha = 0;
                    }
                } completion:^(BOOL finished) {
                    swipeActionsContainerView.maskView = nil;
                    [strongSelf reset];
                    [strongSelf resetSwipe];
                }];
                break;
            }
            case SWPExpansionFulfillmentStyleResete:
            {
                [strongSelf hideSwipeWithAnimated:YES complation:nil];
                break;
            }
            default:
                break;
        }
    };
    
    
    dispatch_block_t invokeAction = ^ {
        if (action.handler) {
            action.handler(action, indexPath);
        }
        if (filloption.autoFulFillmentStyle) {
            action.completionHandler(filloption.autoFulFillmentStyle);
        }
    };
    
    [self __animateWithDuration:0.3 toOffset:newCenter withInitialVelocity:0 completion:^(BOOL complation) {
        if (filloption.timing == SWPHandlerInvocationTimingWithAfter) {
            invokeAction();
        }
    }];
    if (filloption.timing == SWPHandlerInvocationTimingWith) {
        invokeAction();
    }
}

#pragma mark - Public Methond

- (void)hideSwipeWithAnimated:(BOOL)animated complation:(void(^ _Nullable)(BOOL complete))complation
{
    self.swipeable.swipeState = SWPSwipeStateAnimatingToCenter;
    CGFloat targetCenter = [self __targetCenterWithActive:NO];
    if (animated) {
        [self __animateToOffset:targetCenter withInitialVelocity:0 completion:^(BOOL complete) {
            [self reset];
            if (complation) {
                complation(complete);
            }
        }];
    } else {
        self.swipeActionsContainerView.center = CGPointMake(targetCenter, self.swipeActionsContainerView.center.y);
        [self.swipeable.swipeActionsView updateVisibleWidth:fabs(CGRectGetMinX(self.swipeActionsContainerView.frame))];
        [self reset];
    }
    if ([self.delegate respondsToSelector:@selector(swipeController:didEndEditingSwipeableForOrientation:)]) {
        [self.delegate swipeController:self didEndEditingSwipeableForOrientation:self.swipeable.swipeActionsView.orientation];
    }
}

- (void)showSwipeWithOrientation:(SWPSwipeActionsOrientation)orientation animated:(BOOL)animated complation:(void(^ _Nullable)(BOOL complete))complation
{
    [self setOffset:-0.19990811 * orientation animated:YES completion:complation];
}

- (void)setOffset:(CGFloat)offset animated:(BOOL)animated completion:(void(^ _Nullable)(BOOL completed))completion
{
    if (offset == 0) {
        [self hideSwipeWithAnimated:animated complation:completion];
        return;
    }
    SWPSwipeActionsOrientation orientation = offset > 0 ? SWPSwipeActionsOrientationLeft : SWPSwipeActionsOrientationRight;
    SWPSwipeState targetState = offset > 0 ? SWPSwipeStateLeft : SWPSwipeStateRight;
    
    if (self.swipeable.swipeState != targetState) {
        if (![self __showActionsViewForOrientation:orientation]) {
            return;
        }
        [self.swipeable.scrollView hideSwipeables];
        self.swipeable.swipeState = targetState;
    }
    CGFloat maxOffset = fmin(self.swipeable.bounds.size.width, fabs(offset)) * orientation * -1;
    CGFloat targetCenter = CGRectGetMidX(self.swipeable.bounds) + maxOffset;
    
    if (fabs(offset) == 0.19990811) {
        targetCenter = [self __targetCenterWithActive:YES];
    }
    
    if (animated) {
        [self __animateToOffset:targetCenter withInitialVelocity:0 completion:^(BOOL complete) {
            if (completion) {
                completion(complete);
            }
        }];
    } else {
        self.swipeActionsContainerView.center = CGPointMake(targetCenter, self.swipeActionsContainerView.center.y);
        [self.swipeable.swipeActionsView updateVisibleWidth:fabs(CGRectGetMinX(self.swipeActionsContainerView.frame))];
    }
}

- (void)reset
{
    self.swipeable.swipeState = SWPSwipeStateCenter;
    [self.swipeable.swipeActionsView removeFromSuperview];
    self.swipeable.swipeActionsView = nil;
}

- (void)resetSwipe
{
    CGFloat targetPoint = [self __targetCenterWithActive:NO];
    self.swipeActionsContainerView.center = CGPointMake(targetPoint, self.swipeActionsContainerView.center.y);
    [self.swipeable.swipeActionsView updateVisibleWidth:self.swipeActionsContainerView.frame.origin.x];
}

@end


