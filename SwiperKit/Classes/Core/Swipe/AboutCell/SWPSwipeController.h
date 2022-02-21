//
//  SWPSwipeController.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SWPSwipeActionsOrientation);

@class SWPSwipeAction;
@class SWPSwipeOptions;
@class SWPSwipeController;

@protocol SWPSwipeControllerDelegate <NSObject>

- (BOOL)swipeController:(SWPSwipeController *)controller canBeginEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation;
- (NSArray<SWPSwipeAction *> *)swipeController:(SWPSwipeController *)controller editActionsForSwipeableForForOrientation:(SWPSwipeActionsOrientation)orientation;
- (SWPSwipeOptions *)swipeController:(SWPSwipeController *)controller editActionsOptionsForSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation;
- (void)swipeController:(SWPSwipeController *)controller willBeginEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation;
- (void)swipeController:(SWPSwipeController *)controller didEndEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation;
- (void)swipeController:(SWPSwipeController *)controller didDeleteSwipeableAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)swipeController:(SWPSwipeController *)controller visibleRectForScrollView:(UIScrollView *)scrollView;

@end

@interface SWPSwipeController : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic,   weak, nullable) id<SWPSwipeControllerDelegate> delegate;
@property (nonatomic,   weak, nullable) UIScrollView *scrollerView;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;

/// 生成实例
/// @param swipeable 发生滑动的视图
/// @param actionsContainerView 操作视图的容器视图
- (instancetype)initWithSwipeable:(UIView<SWPSwipeable> *)swipeable actionsContainerView:(UIView *)actionsContainerView;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
