//
//  SWPSwipeActionsView.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SWPSwipeActionsOrientation);

@class SWPSwipeAction;
@class SWPSwipeOptions;
@class SWPSwipeActionsView;

/// 操作视图代理协议
@protocol SWPSwipeActionsViewDelegate <NSObject>

/// 操作按钮被点击
/// @param swipeActionsView 操作视图
/// @param action 被点击的操作
- (void)swipeActionsView:(SWPSwipeActionsView *)swipeActionsView
         didSelectAction:(SWPSwipeAction *)action;

@end

/// 操作视图
@interface SWPSwipeActionsView : UIView

/// 代理
@property (nonatomic,   weak) id<SWPSwipeActionsViewDelegate> _Nullable delegate;

/// 将显示的操作按钮在 Cell 的哪一侧
@property (nonatomic, assign, readonly) SWPSwipeActionsOrientation orientation;

/// 操作视图优选宽度
@property (nonatomic, assign, readonly) CGFloat preferredWidth;

/// Layer TODO:
@property (nonatomic, assign, readonly) BOOL expanded;

/// 构造操作视图
/// @param options 滑动配置
/// @param actions 将显示的操作
/// @param orientation 将显示的操作在哪一侧
/// @param maxSize 操作视图的最大 Size
- (instancetype)initWithOptions:(SWPSwipeOptions *)options
                        actions:(NSArray<SWPSwipeAction *> *)actions
                    orientation:(SWPSwipeActionsOrientation)orientation
                        maxSize:(CGSize)maxSize;

/// 更新当前可见宽度
/// @param visibleWidth 更新当前可见宽度
-(void)updateVisibleWidth:(CGFloat)visibleWidth;

@end

NS_ASSUME_NONNULL_END
