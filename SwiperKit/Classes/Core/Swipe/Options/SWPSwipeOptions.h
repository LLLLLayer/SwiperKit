//
//  SWPSwipeOptions.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/13.
//

#import <UIKit/UIKit.h>
#import "SWPSwipeExpansionStyle.h"

NS_ASSUME_NONNULL_BEGIN

/// 描述过渡样式，指在滑动期间操作按钮如何展示的
typedef NS_ENUM(NSInteger, SWPSwipeTransitionStyle) {
    
    /// 可见的操作区域是所有操作按钮的平分
    SWPSwipeTransitionStyleBorder = 0,
    
    /// 可见的操作区域是每个操作按钮被被拖动，所有操作按钮都固定到单元格右侧
    SWPSwipeTransitionStyleDrag = 1,
    
    /// 可见操作区域是固定在表格/集合视图的边缘、位于单元格后面的操作按钮
    SWPSwipeTransitionStyleReveal = 2,
    
};

/// 描述将显示的操作按钮，在 Cell 的哪一侧
typedef NS_ENUM(NSInteger, SWPSwipeActionsOrientation) {
    
    /// Cell 的左侧
    SWPSwipeActionsOrientationLeft = -1,
    
    /// Cell 的右侧
    SWPSwipeActionsOrientationRight = 1,
    
};

/// `Swipe Options` 类为滑动 Cell 的转换行为和扩展行为提供选项配置
@interface SWPSwipeOptions : NSObject

/// 过渡样式，指在滑动期间操作按钮如何展示的
@property (nonatomic, assign) SWPSwipeTransitionStyle transitionStyle;

/// 滑动视图后面的背景颜色
@property (nonatomic, strong) UIColor *backgroundColor;

/// 允许的最大按钮宽度。如果该值设置为 0，则不会发生自动换行，并且按钮将调整到适合整个标题/图像所需的大小
@property (nonatomic, assign) CGFloat maximumButtonWidth;

/// 允许的最小按钮宽度。默认情况下会选择合适的大小
@property (nonatomic, assign) CGFloat minimumButtonWidth;

/// 边框和按钮图像或标题之间的空间量，以磅为单位
@property (nonatomic, assign) CGFloat buttonPadding;

/// 按钮图像和按钮标题之间的空间量，以磅为单位
@property (nonatomic, assign) CGFloat buttonSpacing;
 
/// 扩展样式，当单元格滑过定义的阈值时的行为
@property (nonatomic, strong) SWPSwipeExpansionStyle *expansionStyle;
 
@end

NS_ASSUME_NONNULL_END
