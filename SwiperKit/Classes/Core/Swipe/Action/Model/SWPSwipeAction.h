//
//  SWPSwipeAction.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SWPSwipeActionTransitioning;

/// 有助于定义操作按钮外观的常量。
/// Constants that help define the appearance of action buttons.
typedef NS_ENUM(NSInteger, SWPSwipeActionStyle) {
    
    /// 应用反映标准非破坏性动作的样式。
    /// Apply a style that reflects standard non-destructive actions.
    SWPSwipeActionStyleDefault,
    
    /// 应用反映破坏性动作的样式。
    /// Apply a style that reflects destructive actions.
    SWPSwipeActionStyleDestructive,
    
};

/// 描述一旦操作完成后应该如何解决扩展。
/// Constants that help define the appearance of action buttons.
typedef NS_ENUM(NSInteger, SWPExpansionFulfillmentStyle) {
    
    /// 表示该项目将在操作完成后被删除。
    /// Implies the item will be deleted upon action fulfillment.
    SWPExpansionFulfillmentStyleDelete,
    
    /// 表示该项目将被重置，并且在操作完成后隐藏操作视图。
    /// Implies the item will be reset and the actions view hidden upon action fulfillment.
    SWPExpansionFulfillmentStyleResete,
    
};

/**
 `SwipeAction` 对象定义了当用户在表格/集合项中水平滑动时要呈现的单个操作。
 此类允许您为表/集合中的给定项目定义一个或多个自定义操作。
 此类的每个实例都表示要执行的单个操作，并包括相应按钮的文本、格式信息和行为。
 The `SwipeAction` object defines a single action to present when the user swipes horizontally in a table/collection item.
 This class lets you define one or more custom actions to display for a given item in your table/collection.
 Each instance of this class represents a single action to perform and includes the text, formatting information, and behavior for the corresponding button.
 */
@interface SWPSwipeAction : NSObject

/// 可选的唯一操作标识符。
/// An optional unique action identifier.
@property (nonatomic, strong, nullable) NSString *identifier;

/// 应用于操作按钮的样式。
/// The style applied to the action button.
@property (nonatomic, assign) SWPSwipeActionStyle style;

/// 发生转换时通知的对象。
/// The object that is notified as transitioning occurs.
@property (nonatomic, strong, nullable) id<SWPSwipeActionTransitioning> transitionDelegate;

/// 操作按钮的标题。
/// The title of the action button.
///
/// @note: 必须指定标题或图像。
/// @note: You must specify a title or an image.
@property (nonatomic, strong, nullable) NSString *title;

/// 操作按钮标题的字体。
/// The font to use for the title of the action button.
///
/// @note：如果不指定字体，则使用 15pt 系统字体。
/// @note: If you do not specify a font, a 15pt system font is used.
@property (nonatomic, strong, nullable) UIFont *font;

/// 操作按钮标题的颜色。
/// The title color of the action button.
///
/// @note: 如果不指定颜色，则使用白色。
/// @note: If you do not specify a color, white is used.
@property (nonatomic, strong, nullable) UIColor *textColor;

/// 操作按钮的标题高亮颜色。
/// The highlighted title color of the action button.
///
/// @note: 如果您不指定颜色，则使用 `textColor`。
/// @note: If you do not specify a color, `textColor` is used.
@property (nonatomic, strong, nullable) UIColor *highlightedTextColor;

/// 操作按钮的图像。
/// The image used for the action button.
///
/// @note: 必须指定标题或图像。
/// @note: You must specify a title or an image.
@property (nonatomic, strong, nullable) UIColor *image;

/// 操作按钮的高亮图像。
/// The highlighted image used for the action button.
///
/// @note: @note：如果你没有指定高亮图像，默认的 `image` 用于高亮状态。
/// @note: If you do not specify a highlight image, the default `image` is used for the highlighted state.
@property (nonatomic, strong, nullable) UIColor *highlightedImage;

/// 操作按钮的背景颜色。
/// The background color of the action button.
///
/// @note：使用此属性来指定按钮的背景颜色。 如果没有为此属性指定值，则框架会根据样式属性中的值分配默认颜色。
/// @note: Use this property to specify the background color for your button. If you do not specify a value for this property, the framework assigns a default color based on the value in the style property.
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

/// 操作按钮的高亮背景颜色。
/// The highlighted background color of the action button.
///
/// @note: 使用此属性为的按钮指定突出显示的背景颜色。
/// @note: Use this property to specify the highlighted background color for your button.
@property (nonatomic, strong, nullable) UIColor *highlightedBackgroundColor;

/// 操作按钮的视觉效果。
/// The visual effect to apply to the action button.
///
/// @note: 为该属性分配一个视觉效果对象会将该效果添加到操作按钮的背景中。
/// @note: Assigning a visual effect object to this property adds that effect to the background of the action button.
@property (nonatomic, strong, nullable) UIColor *backgroundEffect;

/// 一个布尔值，用于确定操作视图是否在选择时自动隐藏。
/// A Boolean value that determines whether the actions menu is automatically hidden upon selection.
///
/// @note: 设置为“YES`”时，选择操作时会自动隐藏操作菜单。 默认值为“YES”。
/// @note:  When set to `true`, the actions menu is automatically hidden when the action is selected. The default value is `true`.
@property (nonatomic, assign) BOOL hidesWhenSelected;

/// 当用户点击与此操作关联的按钮时要执行的闭包。
/// The closure to execute when the user taps the button associated with this action.
@property (nonatomic, strong, nullable) void (^handler)(SWPSwipeAction *ation, NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
