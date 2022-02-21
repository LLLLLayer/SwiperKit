//
//  SWPSwipeOptions.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/13.
//

#import <UIKit/UIKit.h>
#import "SWPSwipeExpansionStyle.h"

NS_ASSUME_NONNULL_BEGIN

/// 描述过渡样式，指在滑动期间操作按钮如何展示的。
/// Describes the transition style. Transition is the style of how the action buttons are exposed during the swipe.
typedef NS_ENUM(NSInteger, SWPSwipeTransitionStyle) {
    
    /// 可见的操作区域是所有操作按钮的平分。
    /// The visible action area is equally divide between all action buttons.
    SWPSwipeTransitionStyleBorder = 0,
    
    /// 可见的操作区域是每个操作按钮被被拖动，所有操作按钮都固定到单元格右侧。
    /// The visible action area is dragged, pinned to the cell, with each action button fully sized as it is exposed.
    SWPSwipeTransitionStyleDrag = 1,
    
    /// 可见操作区域是固定在表格/集合视图的边缘、位于单元格后面的操作按钮。
    /// The visible action area sits behind the cell, pinned to the edge of the table/collection view, and is revealed as the cell is dragged aside.
    SWPSwipeTransitionStyleReveal = 2,
    
};

/// 描述将显示的操作按钮，在 Cell 的哪一侧。
/// Describes which side of the cell that the action buttons will be displayed.
typedef NS_ENUM(NSInteger, SWPSwipeActionsOrientation) {
    
    /// Cell 的左侧。
    /// The left side of the cell.
    SWPSwipeActionsOrientationLeft = -1,
    
    /// Cell 的右侧
    /// The right side of the cell.
    SWPSwipeActionsOrientationRight = 1,
    
};

/// 描述提供操作按钮图像和标题时使用的对齐方式。
/// Describes the alignment mode used when action button images and titles are provided.
typedef NS_ENUM(NSInteger, SWPSwipeVerticalAlignment) {
    /// 将检查所有按钮，并使用最高的图像和标题文本的第一个基线偏移量来创建对齐矩形。
    /// All actions will be inspected and the tallest image and first baseline offset of title text will be used to create the alignment rectangle.
    SWPSwipeVerticalAlignmentCenterFirstBaseline = 0,
    
    /// 按钮图像高度和完整标题高度用于创建对齐矩形。
    /// The action button image height and full title height are used to create the aligment rectange.
    SWPSwipeVerticalAlignmentCenter = 1,
};

/// `Swipe Options` 类为滑动 Cell 的转换行为和扩展行为提供选项配置。
/// The `SwipeOptions` class provides options for transistion and expansion behavior for swiped cell.
@interface SWPSwipeOptions : NSObject

/// 过渡样式，指在滑动期间操作按钮如何展示的。
/// The transition style. Transition is the style of how the action buttons are exposed during the swipe.
@property (nonatomic, assign) SWPSwipeTransitionStyle transitionStyle;

/// 扩展样式，当单元格滑过定义的阈值时的行为。
/// The expansion style. Expansion is the behavior when the cell is swiped past a defined threshold.
@property (nonatomic, strong) SWPSwipeExpansionStyle *expansionStyle;

// expansionDelegate

/// 按钮后面的背景颜色。
/// The background color behind the action buttons.
@property (nonatomic, strong) UIColor *backgroundColor;

/// 允许的最大按钮宽度。如果该值设置为 0，则不会发生自动换行，并且按钮将调整到适合整个标题/图像所需的大小。
/// The largest allowable button width. If the value is set to 0, then word wrapping will not occur and the buttons will grow as large as needed to fit the entire title/image.
@property (nonatomic, assign) CGFloat maximumButtonWidth;

/// 允许的最小按钮宽度。默认情况下会选择合适的大小。
/// The smallest allowable button width. By default, the system chooses an appropriate size.
@property (nonatomic, assign) CGFloat minimumButtonWidth;

/// 按钮图像和标题存在时使用的垂直对齐模式。
/// The vertical alignment mode used for when a button image and title are present.
@property (nonatomic, assign) SWPSwipeVerticalAlignment buttonVerticalAlignment;

/// 边框和按钮图像或标题之间的空间量，以磅为单位。
/// The amount of space, in points, between the border and the button image or title.
@property (nonatomic, assign) CGFloat buttonPadding;

/// 按钮图像和按钮标题之间的空间量，以磅为单位。
/// The amount of space, in points, between the button image and the button title.
@property (nonatomic, assign) CGFloat buttonSpacing;

@end

NS_ASSUME_NONNULL_END
