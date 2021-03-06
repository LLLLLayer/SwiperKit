//
//  SWPSwipeCollectionViewCell.m
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/10.
//

#import "SWPSwipeable.h"
#import "SWPSwipeOptions.h"
#import "SWPSwipeController.h"
#import "SWPSwipeActionsView.h"
#import "UICollectionView+Swipe.h"
#import "SWPSwipeCollectionViewCell.h"
#import "SWPSwipeCollectionViewCell+Display.h"
#import "SWPSwipeCollectionViewCellDelegate.h"

@interface SWPSwipeCollectionViewCell () <SWPSwipeable, SWPSwipeControllerDelegate>

@property (nonatomic, strong, nullable) SWPSwipeController *swipeController;

@property (nonatomic,   weak, nullable) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isPreviouslySelected;

@end

@implementation SWPSwipeCollectionViewCell

@synthesize swipeState;
@synthesize swipeActionsView;
@synthesize scrollView;
@synthesize indexPath;
@synthesize panGestureRecognizer;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)dealloc
{
    // 移除作为 collectionView 滑动手势的响应者
    [self.collectionView.panGestureRecognizer removeTarget:self action:nil];
}

- (void)configure
{
    // 设置 contentView 必要布局
    self.contentView.clipsToBounds = NO;
    if (self.contentView.translatesAutoresizingMaskIntoConstraints) {
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [self.contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
            [self.contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
        ]];
    }
    
    // 滑动控制器初始化
    self.swipeController = [[SWPSwipeController alloc] initWithSwipeable:self actionsContainerView:self.contentView];
    self.swipeController.delegate = self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    UIView *view = self;
    while (view.superview) {
        view = view.superview;
        if ([view isKindOfClass:[UICollectionView class]]) {
            // 找到自己所属的 collectionView，并添加作为 collectionView 滑动手势的响应者
            self.collectionView = (UICollectionView *)view;
            [self.collectionView.panGestureRecognizer removeTarget:self action:nil];
            [self.collectionView.panGestureRecognizer addTarget:self action:@selector(__handleCollectionPanGesture:)];
            return;
        }
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    if (newWindow) {
        [self __reset];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    [self.swipeController traitCollectionDidChangeFrom:previousTraitCollection to:self.traitCollection];
}

#pragma mark - Reset

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self __reset];
    [self __resetSelectedState];
}

- (void)__reset
{
    [self.swipeController reset];
    self.clipsToBounds = NO;
}

- (void)__resetSelectedState
{
    if (self.isPreviouslySelected) {
        if (!self.scrollView || !self.indexPath) {
            return;
        }
        [self.collectionView selectItemAtIndexPath:self.indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark - Touch

/// 在这里覆盖 hitTest(_:with:) 以便 `actionsView` 获得触摸事件,否则， `contentView` 将吞下它并将其传递给 collection
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.swipeActionsView || self.isHidden) {
        return [super hitTest:point withEvent:event];
    }
    CGPoint modifiedPoint = [self.swipeActionsView convertPoint:point fromView:self];
    return [self.swipeActionsView hitTest:modifiedPoint withEvent:event] ?: [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.superview) {
        return NO;
    }
    CGPoint poi = [self convertPoint:point toView:self.superview];
    for (SWPSwipeCollectionViewCell *cell in [self.collectionView swipeCells]) {
        if ((cell.swipeState == SWPSwipeStateLeft || cell.swipeState == SWPSwipeStateRight) && ![cell __containsPoint:poi]) {
            [self.collectionView hideSwipeCell];
            return NO;
        }
    }
    return [self __containsPoint:poi];
}

- (BOOL)__containsPoint:(CGPoint)point
{
    return CGRectContainsPoint(self.frame, point);
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return [self.swipeController gestureRecognizerShouldBegin:gestureRecognizer];
}

#pragma mark - Setter/Getter

- (BOOL)isHighlighted
{
    return [super isHighlighted];
}

- (void)setHighlighted:(BOOL)highlighted
{
    // 非中心不处理 highlighted
    if (self.swipeState != SWPSwipeStateCenter) {
        return;
    }
    [super setHighlighted:highlighted];
}

- (UIScrollView *)scrollView
{
    return self.collectionView;
}

- (NSIndexPath *)indexPath
{
    return [self.collectionView indexPathForCell:self];
}

- (UIGestureRecognizer *)panGestureRecognizer
{
    return self.swipeController.panGestureRecognizer;
}

#pragma mark - Action

- (void)__handleCollectionPanGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self hideSwipeWithAnimated:YES complation:nil];
    }
}

#pragma mark - SWPSwipeControllerDelegate

- (BOOL)swipeController:(SWPSwipeController *)controller canBeginEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation
{
    return YES;
}

- (NSArray<SWPSwipeAction *> *)swipeController:(SWPSwipeController *)controller editActionsForSwipeableForForOrientation:(SWPSwipeActionsOrientation)orientation
{
    NSIndexPath *indexPath = self.indexPath;
    if (indexPath && [self.swipeCollectionViewCelldelegate respondsToSelector:@selector(collectionView:editActionsForItemAtIndexPath:forOrientation:)]) {
        return [self.swipeCollectionViewCelldelegate collectionView:self.collectionView editActionsForItemAtIndexPath:self.indexPath forOrientation:orientation];
    }
    return nil;
}

- (SWPSwipeOptions *)swipeController:(SWPSwipeController *)controller editActionsOptionsForSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation
{
    NSIndexPath *indexPath = self.indexPath;
    SWPSwipeOptions *options;
    if (indexPath && [self.swipeCollectionViewCelldelegate respondsToSelector:@selector(collectionView:editActionsOptionsForItemAtIndexPath:forOrientation:)]) {
        options = [self.swipeCollectionViewCelldelegate collectionView:self.collectionView editActionsOptionsForItemAtIndexPath:indexPath forOrientation:orientation];
    }
    return options;
}

- (void)swipeController:(SWPSwipeController *)controller willBeginEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation
{
    NSIndexPath *indexPath = self.indexPath;
    
    [super setHighlighted:NO];
    self.isPreviouslySelected = self.isSelected;
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if (indexPath && [self.swipeCollectionViewCelldelegate respondsToSelector:@selector(collectionView:willBeginEditingItemAtIndexPath:forOrientation:)]) {
        [self.swipeCollectionViewCelldelegate collectionView:self.collectionView willBeginEditingItemAtIndexPath:indexPath forOrientation:orientation];
    }
}

- (void)swipeController:(SWPSwipeController *)controller didEndEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation
{
    NSIndexPath *indexPath = self.indexPath;
    if (indexPath && [self.swipeCollectionViewCelldelegate respondsToSelector:@selector(collectionView:didEndEditingItemAtAtIndexPath:forOrientation:)]) {
        [self.swipeCollectionViewCelldelegate collectionView:self.collectionView didEndEditingItemAtAtIndexPath:indexPath forOrientation:orientation];
    }
    [self __resetSelectedState];
}

- (void)swipeController:(SWPSwipeController *)controller didDeleteSwipeableAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

@end

