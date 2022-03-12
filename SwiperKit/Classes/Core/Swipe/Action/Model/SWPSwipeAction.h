//
//  SWPSwipeAction.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SWPSwipeActionTransitioning;

/// 有助于定义操作按钮外观的常量
typedef NS_ENUM(NSInteger, SWPSwipeActionStyle) {
    
    /// 应用反映标准非破坏性动作的样式
    SWPSwipeActionStyleDefault,
    
    /// 应用反映破坏性动作的样式
    SWPSwipeActionStyleDestructive,
    
};

/// 描述一旦操作完成后应该如何解决扩展。
typedef NS_ENUM(NSInteger, SWPExpansionFulfillmentStyle) {
    
    SWPExpansionFulfillmentStyleNone,
    
    /// 表示该项目将在操作完成后被删除。
    SWPExpansionFulfillmentStyleDelete,
    
    /// 表示该项目将被重置，并且在操作完成后隐藏操作视图
    SWPExpansionFulfillmentStyleResete,
    
};

/**
 `SwipeAction` 对象定义了当用户在表格/集合项中水平滑动时要呈现的单个操作。
 此类允许您为表/集合中的给定项目定义一个或多个自定义操作。
 此类的每个实例都表示要执行的单个操作，并包括相应按钮的文本、格式信息和行为。
 */
@interface SWPSwipeAction : NSObject

/// 可选的唯一操作标识符
@property (nonatomic, strong, nullable) NSString *identifier;

/// 应用于操作按钮的样式
@property (nonatomic, assign) SWPSwipeActionStyle style;

/// 发生转换时通知的对象
@property (nonatomic, strong, nullable) id<SWPSwipeActionTransitioning> transitionDelegate;

/// 操作按钮的标题
///
/// @note: 必须指定标题或图像
@property (nonatomic, strong, nullable) NSString *title;

/// 操作按钮标题的字体
///
/// @note：如果不指定字体，则使用 15pt 系统字体
@property (nonatomic, strong, nullable) UIFont *font;

/// 操作按钮标题的颜色
///
/// @note: 如果不指定颜色，则使用白色
@property (nonatomic, strong, nullable) UIColor *textColor;

/// 操作按钮的标题高亮颜色
///
/// @note: 如果您不指定颜色，则使用 `textColor`
@property (nonatomic, strong, nullable) UIColor *highlightedTextColor;

/// 操作按钮的图像
///
/// @note: 必须指定标题或图像
@property (nonatomic, strong, nullable) UIImage *image;

/// 操作按钮的高亮图像
///
/// @note: 如果你没有指定高亮图像，默认的 `image` 用于高亮状态
@property (nonatomic, strong, nullable) UIImage *highlightedImage;

/// 操作按钮的背景颜色
///
/// @note：使用此属性来指定按钮的背景颜色。 如果没有为此属性指定值，则框架会根据样式属性中的值分配默认颜色
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

/// 操作按钮的高亮背景颜色
///
/// @note: 使用此属性为的按钮指定突出显示的背景颜色
@property (nonatomic, strong, nullable) UIColor *highlightedBackgroundColor;

/// 一个布尔值，用于确定操作视图是否在选择时自动隐藏
///
/// @note: 设置为“YES`”时，选择操作时会自动隐藏操作菜单。 默认值为“YES”
@property (nonatomic, assign) BOOL hidesWhenSelected;

/// 当用户点击与此操作关联的按钮时要执行的闭包
@property (nonatomic, strong, nullable) void (^handler)(SWPSwipeAction *ation, NSIndexPath *indexPath);

// MARK: - Internal
@property (nonatomic, strong, nullable) void (^completionHandler)(SWPExpansionFulfillmentStyle style);

@end

NS_ASSUME_NONNULL_END
