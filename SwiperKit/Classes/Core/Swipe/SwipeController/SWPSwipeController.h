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

/// 是否可以进行滑动操作
/// @param controller 滑动控制器
/// @param orientation 请求此信息的滑动方向
- (BOOL)swipeController:(SWPSwipeController *)controller canBeginEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation;

/// 滑动操作
/// @param controller 滑动控制器
/// @param orientation 请求此信息的滑动方向
- (NSArray<SWPSwipeAction *> *)swipeController:(SWPSwipeController *)controller editActionsForSwipeableForForOrientation:(SWPSwipeActionsOrientation)orientation;

/// 滑动配置
/// @param controller 滑动控制器
/// @param orientation 请求此信息的滑动方向
- (SWPSwipeOptions *)swipeController:(SWPSwipeController *)controller editActionsOptionsForSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation;

/// 即将滑动回调
/// @param controller 滑动控制器
/// @param orientation 请求此信息的滑动方向
- (void)swipeController:(SWPSwipeController *)controller willBeginEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation;

/// 滑动结束回调
/// @param controller 滑动控制器
/// @param orientation 请求此信息的滑动方向
- (void)swipeController:(SWPSwipeController *)controller didEndEditingSwipeableForOrientation:(SWPSwipeActionsOrientation)orientation;

/// 删除回调
/// @param controller 滑动控制器
/// @param indexPath 被删除的位置
- (void)swipeController:(SWPSwipeController *)controller didDeleteSwipeableAtIndexPath:(NSIndexPath *)indexPath;

@end

/// 滑动控制器
@interface SWPSwipeController : NSObject <UIGestureRecognizerDelegate>

/// 滑动控制器代理
@property (nonatomic,   weak, nullable) id<SWPSwipeControllerDelegate> delegate;

/// 滑动手势
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

- (void)traitCollectionDidChangeFrom:(UITraitCollection *)previousTraitCollection to:(UITraitCollection *)currentTraitCollection;

@end

NS_ASSUME_NONNULL_END
