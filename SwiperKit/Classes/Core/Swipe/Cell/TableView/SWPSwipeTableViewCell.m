//
//  SWPSwipeTableViewCell.m
//  SwiperKit
//
//  Created by yangjie.layer on 2022/2/26.
//

#import "SWPSwipeable.h"
#import "SWPSwipeOptions.h"
#import "SWPSwipeController.h"
#import "UITableView+Swipe.h"
#import "SWPSwipeTableViewCell.h"
#import "SWPSwipeTableViewCellDelegate.h"
#import "SWPSwipeTableViewCell+Display.h"

@interface SWPSwipeTableViewCell () <SWPSwipeable, SWPSwipeControllerDelegate>

@property (nonatomic, strong, nullable) SWPSwipeController *swipeController;

@property (nonatomic,   weak, nullable) UITableView *tableView;

@property (nonatomic, assign) BOOL isPreviouslySelected;

@end

@implementation SWPSwipeTableViewCell

@synthesize swipeState;
@synthesize swipeActionsView;
@synthesize scrollView;
@synthesize indexPath;
@synthesize panGestureRecognizer;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)dealloc
{
    // 移除作为 tableView 滑动手势的响应者
    [self.tableView.panGestureRecognizer removeTarget:self action:nil];
}

- (void)configure
{
    // 设置 contentView 必要布局
    self.clipsToBounds = NO;
    
    // 滑动控制器初始化
    self.swipeController = [[SWPSwipeController alloc] initWithSwipeable:self actionsContainerView:self];
    self.swipeController.delegate = self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    UIView *view = self;
    while (view.superview) {
        view = view.superview;
        if ([view isKindOfClass:[UITableView class]]) {
            // 找到自己所属的 tableView，并添加作为 tableView 滑动手势的响应者
            self.tableView = (UITableView *)view;
            [self.tableView.panGestureRecognizer removeTarget:self action:nil];
            [self.tableView.panGestureRecognizer addTarget:self action:@selector(__handleTableViewPanGesture:)];
            return;
        }
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
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - Touch

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.superview) {
        return NO;
    }
    CGPoint poi = [self convertPoint:point toView:self.superview];
    for (SWPSwipeTableViewCell *cell in [self.tableView swipeCells]) {
        if ((cell.swipeState == SWPSwipeStateLeft || cell.swipeState == SWPSwipeStateRight) && ![cell __containsPoint:poi]) {
            [self.tableView hideSwipeCell];
            return NO;
        }
    }
    return [self __containsPoint:poi];
}

- (BOOL)__containsPoint:(CGPoint)point
{
    return point.y > CGRectGetMinY(self.frame) && point.y < CGRectGetMaxY(self.frame);
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
    return self.tableView;
}

- (NSIndexPath *)indexPath
{
    return [self.tableView indexPathForCell:self];
}

- (UIGestureRecognizer *)panGestureRecognizer
{
    return self.swipeController.panGestureRecognizer;
}

#pragma mark - Action

- (void)__handleTableViewPanGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self hideSwipeWithAnimated:YES complation:nil];
    }
}

#pragma mark - SWPSwipeControllerDelegate

- (BOOL)swipeController:(SWPSwipeController *)controller canBeginEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation
{
    return !self.isEditing;
}

- (NSArray<SWPSwipeAction *> *)swipeController:(SWPSwipeController *)controller editActionsForSwipeableForForOrientation:(SWPSwipeActionsOrientation)orientation
{
    NSIndexPath *indexPath = self.indexPath;
    if (indexPath && [self.swipeTableViewCelldelegate respondsToSelector:@selector(tableView:editActionsForItemAtIndexPath:forOrientation:)]) {
        return [self.swipeTableViewCelldelegate tableView:self.tableView editActionsForItemAtIndexPath:self.indexPath forOrientation:orientation];
    }
    return nil;
}

- (SWPSwipeOptions *)swipeController:(SWPSwipeController *)controller editActionsOptionsForSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation
{
    NSIndexPath *indexPath = self.indexPath;
    SWPSwipeOptions *options;
    if (indexPath && [self.swipeTableViewCelldelegate respondsToSelector:@selector(tableView:editActionsOptionsForItemAtIndexPath:forOrientation:)]) {
        options = [self.swipeTableViewCelldelegate tableView:self.tableView editActionsOptionsForItemAtIndexPath:indexPath forOrientation:orientation];
    }
    return options;
}

- (void)swipeController:(SWPSwipeController *)controller willBeginEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation
{
    NSIndexPath *indexPath = self.indexPath;
    [super setHighlighted:NO];
    self.isPreviouslySelected = self.isSelected;
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath && [self.swipeTableViewCelldelegate respondsToSelector:@selector(tableView:willBeginEditingItemAtIndexPath:forOrientation:)]) {
        [self.swipeTableViewCelldelegate tableView:self.tableView willBeginEditingItemAtIndexPath:indexPath forOrientation:orientation];
    }
}

- (void)swipeController:(SWPSwipeController *)controller didEndEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation
{
    NSIndexPath *indexPath = self.indexPath;
    if (indexPath && [self.swipeTableViewCelldelegate respondsToSelector:@selector(tableView:didEndEditingItemAtAtIndexPath:forOrientation:)]) {
        [self.swipeTableViewCelldelegate tableView:self.tableView didEndEditingItemAtAtIndexPath:indexPath forOrientation:orientation];
    }
    [self __resetSelectedState];
}

- (void)swipeController:(SWPSwipeController *)controller didDeleteSwipeableAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
