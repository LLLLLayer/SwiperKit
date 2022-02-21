//
//  SwipeActionButtonWrapperView.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 操作按钮的包装视图
@interface SWPSwipeActionButtonWrapperView : UIView

/// 提供给 button 的 frame
@property (nonatomic, assign) CGRect contentRect;

/// 操作按钮的包装视图背景
@property (nonatomic, strong) UIColor *actionBackgroundColor;

/// 构造操作按钮的包装视图
/// @param frame 操作按钮的包装视图 frame
/// @param action 操作
/// @param orientation 将显示的操作在哪一侧
/// @param contentWidth 按钮最小完整宽度
- (instancetype)initWithFrame:(CGRect)frame
                       action:(SWPSwipeAction *)action
                  orientation:(SWPSwipeActionsOrientation)orientation
                 contentWidth:(CGFloat)contentWidth;

@end

NS_ASSUME_NONNULL_END
