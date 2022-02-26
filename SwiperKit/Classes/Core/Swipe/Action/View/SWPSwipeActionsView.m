//
//  SWPSwipeActionsView.m
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/13.
//

#import "SwiperKit/SWPSwipeAction.h"
#import "SWPSwipeOptions.h"
#import "SWPSwipeActionButton.h"
#import "SWPSwipeActionsView.h"
#import "SWPSwipeTransitionLayout.h"
#import "SWPSwipeActionButtonWrapperView.h"
#import "SWPSwipeActionTransitioning.h"

@interface SWPSwipeActionsView ()

/// 滑动配置
@property (nonatomic, strong) SWPSwipeOptions *options;
/// 将显示的操作
@property (nonatomic,   copy) NSArray<SWPSwipeAction *> *actions;
/// 将显示的操作按钮在 Cell 的哪一侧
@property (nonatomic, assign) SWPSwipeActionsOrientation orientation;

/// 当前的操作按钮
@property (nonatomic, strong) NSArray<SWPSwipeActionButton *> *buttons;
/// 过度布局上下文
@property (nonatomic, strong) SWPActionsViewLayoutContext *layoutContext;
/// 过度布局工具
@property (nonatomic, strong) id<SWPSwipeTransitionLayout> transitionLayout;

/// 滑动视图的 Size
@property (nonatomic, assign) CGSize contentSize;
/// 当前可见宽度
@property (nonatomic, assign) CGFloat visibleWidth;
/// 按钮最小完整宽度
@property (nonatomic, assign) CGFloat minimumButtonWidth;

@end

@implementation SWPSwipeActionsView

/// 构造操作视图
/// @param options 滑动配置
/// @param actions 将显示的操作
/// @param orientation 将显示的操作在哪一侧
/// @param maxSize 操作视图的最大 Size
- (instancetype)initWithOptions:(SWPSwipeOptions *)options
                        actions:(NSArray<SWPSwipeAction *> *)actions
                    orientation:(SWPSwipeActionsOrientation)orientation
                        maxSize:(CGSize)maxSize;

{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.options = options;
        self.actions = actions;
        self.orientation = orientation;
        
        // Default UI
        self.clipsToBounds = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = self.options.backgroundColor;
        
        // Default TransitionLayout
        switch (options.transitionStyle) {
            case SWPSwipeTransitionStyleBorder:
                self.transitionLayout = [[SWPBorderTransitionLayout alloc] init];
                break;
            case SWPSwipeTransitionStyleDrag:
                self.transitionLayout = [[SWPDragTransitionLayout alloc] init];
                break;
            case SWPSwipeTransitionStyleReveal:
                self.transitionLayout = [[SWPRevealTransitionLayout alloc] init];
                break;
            default:
                NSAssert(NO, @"Illegal parameter: options.transitionStyle");
                break;
        }
        
        // Default LayoutContext
        self.layoutContext = [[SWPActionsViewLayoutContext alloc] init];
        self.layoutContext.numberOfActions = self.actions.count;
        self.layoutContext.orientation = self.orientation;
        
        // Button
        self.buttons = [self __addButtonsForActions:self.actions withMaximum:maxSize];
        
    }
    return self;
}

/// 布局子视图
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 更新子视图布局
    for (NSInteger index = 0; index < self.subviews.count; ++index) {
        [self.transitionLayout layoutView:self.subviews[index] atIndex:index withContext:self.layoutContext];
    }
}

#pragma mark - Public Methond

-(void)updateVisibleWidth:(CGFloat)visibleWidth
{
    self.visibleWidth = visibleWidth;
    
    NSArray<NSNumber *> *preLayoutVisibleWidths = [self.transitionLayout visibleWidthsForViewsWithContext:self.layoutContext];
    
    self.layoutContext = [[SWPActionsViewLayoutContext alloc] init];
    self.layoutContext.numberOfActions = self.actions.count;
    self.layoutContext.orientation = self.orientation;
    self.layoutContext.contentSize = self.contentSize;
    self.layoutContext.visibleWidth = self.visibleWidth;
    self.layoutContext.minimumButtonWidth = self.minimumButtonWidth;
    
    [self.transitionLayout continerView:self didChangeVisibleWidthWithContext:self.layoutContext];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self __notifyVisibleWidthChanged:preLayoutVisibleWidths
                            newWidths:[self.transitionLayout
                                       visibleWidthsForViewsWithContext:self.layoutContext]];
}

#pragma mark - Private Methond

/// 添加操作按钮
/// @param actions 按钮
/// @param size 按钮的最大 Size
- (NSArray<SWPSwipeActionButton *> *)__addButtonsForActions:(NSArray<SWPSwipeAction *> *)actions
                                                withMaximum:(CGSize)size
{
    // 构造操作按钮
    NSMutableArray<SWPSwipeActionButton *> *swipeActionButtons = [[NSMutableArray alloc] initWithCapacity:actions.count];
    for (SWPSwipeAction *action in actions) {
        SWPSwipeActionButton *button = [[SWPSwipeActionButton alloc] initWithAction:action];
        [button addTarget:self action:@selector(__actionTappedWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setAutoresizingMask:self.orientation == SWPSwipeActionsOrientationLeft ? \
                                    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin : \
                                    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
        button.spacing = self.options.buttonSpacing != 0 ?: 8.0;
        button.contentEdgeInsets = [button buttonEdgeInsetsFromOptions:self.options];
        [swipeActionButtons addObject:button];
    }
    
    // 计算按钮最小完整宽度
    CGFloat maximum = self.options.maximumButtonWidth != 0 ?: (size.width - 30.0) / (CGFloat)actions.count;
    CGFloat minimum = self.options.minimumButtonWidth != 0 ?: fmin(maximum, 74.0);
    self.minimumButtonWidth = minimum;
    for (SWPSwipeActionButton *buton in swipeActionButtons) {
        self.minimumButtonWidth = fmax(self.minimumButtonWidth, [buton preferredWidthMaximum:maximum]);
    }
    
    // 操作按钮包装视图
    for (NSInteger index = 0; index < swipeActionButtons.count; ++index) {
        SWPSwipeAction *action = actions[index];
        SWPSwipeActionButton *button = swipeActionButtons[index];
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        SWPSwipeActionButtonWrapperView *wrapperView = [[SWPSwipeActionButtonWrapperView alloc] initWithFrame:frame
                                                                                                       action:action
                                                                                                  orientation:self.orientation
                                                                                                 contentWidth:self.minimumButtonWidth];
        wrapperView.translatesAutoresizingMaskIntoConstraints = NO;
        [wrapperView addSubview:button];
        if (action.backgroundEffect) {
            // Layer TODO: backgroundEffect
        } else {
            [self addSubview:wrapperView];
        }
        
        button.frame = wrapperView.contentRect;
        [[wrapperView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
        [[wrapperView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
        [[wrapperView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[wrapperView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    }
    
    return swipeActionButtons.copy;
}

- (void)__notifyVisibleWidthChanged:(NSArray<NSNumber *> *)oldWidths newWidths:(NSArray<NSNumber *> *)newWidths
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSInteger index = 0; index < oldWidths.count; ++index) {
            CGFloat oldWidth = oldWidths[index].floatValue;
            CGFloat newWidth = newWidths[index].floatValue;
            if (oldWidth != newWidth) {
                SWPSwipeActionTransitioningContext *context = [[SWPSwipeActionTransitioningContext alloc] init];
                context.actionIdentifier = self.actions[index].identifier;
                context.button = self.buttons[index];
                context.wrapperView = self.subviews[index];
                context.oldPercentVisible = oldWidth / self.minimumButtonWidth;
                context.newPercentVisible = newWidth / self.minimumButtonWidth;
                [self.actions[index].transitionDelegate didTransitionWithContext:context];
            }
        }
            
    });
}

#pragma mark - Setter/Getter

- (CGFloat)preferredWidth
{
    return self.minimumButtonWidth * self.actions.count;
}

- (CGSize)contentSize
{
    return CGSizeMake(self.visibleWidth, self.bounds.size.height);
//    CGFloat scrollRatio = fmax(0, self.visibleWidth - self.preferredWidth);
//    return CGSizeMake(self.preferredWidth + (scrollRatio * 0.25), self.bounds.size.height);
}

#pragma mark - Action

- (void)__actionTappedWithButton:(SWPSwipeActionButton *)button
{
    NSInteger index = [self.buttons indexOfObject:button];
    if (index >= 0 && index < self.actions.count &&
        [self.delegate respondsToSelector:@selector(swipeActionsView:didSelectAction:)]) {
        [self.delegate swipeActionsView:self didSelectAction:self.actions[index]];
    }
}

@end
