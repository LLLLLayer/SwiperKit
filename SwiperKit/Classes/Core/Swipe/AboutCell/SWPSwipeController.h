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
@protocol SWPSwipeable;

@protocol SWPSwipeControllerDelegate <NSObject>

- (BOOL)swipeController:(SWPSwipeController *)controller canBeginEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation;
- (NSArray<SWPSwipeAction *> *)swipeController:(SWPSwipeController *)controller editActionsForSwipeableForForOrientation:(SWPSwipeActionsOrientation)orientation;
- (SWPSwipeOptions *)swipeController:(SWPSwipeController *)controller editActionsOptionsForSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation;
- (void)swipeController:(SWPSwipeController *)controller willBeginEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation;
- (void)swipeController:(SWPSwipeController *)controller didEndEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation;
- (void)swipeController:(SWPSwipeController *)controller didDeleteSwipeableAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)swipeController:(SWPSwipeController *)controller visibleRectForScrollView:(UIScrollView *)scrollView;

@end

/// 滑动控制器
@interface SWPSwipeController : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic,   weak, nullable) id<SWPSwipeControllerDelegate> delegate;
@property (nonatomic,   weak, nullable) UIScrollView *scrollerView;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;

/// 生成实例
/// @param swipeable 发生滑动的视图
/// @param actionsContainerView 操作视图的容器视图
- (instancetype)initWithSwipeable:(UIView<SWPSwipeable> *)swipeable actionsContainerView:(UIView *)actionsContainerView;

/// 隐藏操作视图
/// @param animated 动画
/// @param complation 完成回调
- (void)hideSwipeWithAnimated:(BOOL)animated complation:(void(^ _Nullable)(BOOL complete))complation;

/// 展示操作视图
/// @param orientation 展示哪方的操作视图
/// @param animated 动画
/// @param complation 完成回调
- (void)showSwipeWithOrientation:(SWPSwipeActionsOrientation)orientation animated:(BOOL)animated complation:(void(^ _Nullable)(BOOL complete))complation;

/// 设置操作视图偏移
/// @param offset 偏移量
/// @param animated 动画
/// @param completion 完成回调
- (void)setOffset:(CGFloat)offset animated:(BOOL)animated completion:(void(^ _Nullable)(BOOL completed))completion;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
