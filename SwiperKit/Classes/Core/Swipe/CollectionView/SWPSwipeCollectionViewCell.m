//
//  SWPSwipeCollectionViewCell.m
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/10.
//

#import "SWPSwipeable.h"
#import "SWPSwipeOptions.h"
#import "SWPSwipeController.h"
#import "SWPSwipeCollectionViewCell.h"
#import "SWPSwipeCollectionViewCell+Display.h"
#import "SWPSwipeCollectionViewCellDelegate.h"

@interface SWPSwipeCollectionViewCell () <SWPSwipeable, SWPSwipeControllerDelegate>

@property (nonatomic, strong, nullable) SWPSwipeController *swipeController;

@property (nonatomic,   weak, nullable) UICollectionView *collectionView;

@end

@implementation SWPSwipeCollectionViewCell

@synthesize swipeState;
@synthesize swipeActionsView;
@synthesize scrollView;
@synthesize indexPath;
@synthesize panGestureRecognizer;
@synthesize frame = _frame;
@synthesize highlighted = _highlighted;

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
        }
    }
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

#pragma mark - Reset

- (void)__reset
{
    self.contentView.clipsToBounds = NO;
    [self.swipeController reset];
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
    return options ?: [[SWPSwipeOptions alloc] init];
}

- (void)swipeController:(SWPSwipeController *)controller willBeginEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation
{
    NSIndexPath *indexPath = self.indexPath;
    [super setHighlighted:NO];
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
}

- (void)swipeController:(SWPSwipeController *)controller didDeleteSwipeableAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

@end

