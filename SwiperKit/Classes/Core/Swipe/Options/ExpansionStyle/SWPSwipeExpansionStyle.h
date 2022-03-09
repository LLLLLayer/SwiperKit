//
//  SWPSwipeExpansionStyle.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/17.
//

#import <UIKit/UIKit.h>
#import "SWPSwipeable.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - SWPFillOptions

typedef NS_ENUM(NSInteger, SWPExpansionFulfillmentStyle);

/// 描述何时将针对填充动画调用动作处理
typedef NS_ENUM(NSInteger, SWPHandlerInvocationTiming) {
    
    /// 填充动画播放时调用动作处理
    SWPHandlerInvocationTimingWith,
    
    /// 填充动画完成后调用动作处理
    SWPHandlerInvocationTimingWithAfter,
    
};

/// 指定填充完成动画的选项
@interface SWPFillOptions : NSObject

/// 操作完成后应该如何解决扩展的实现样式。
@property (nonatomic, assign) SWPExpansionFulfillmentStyle autoFulFillmentStyle;

/// 针对填充动画调用动作处理程序的时间
@property (nonatomic, assign) SWPHandlerInvocationTiming timing;

/// 返回具有自动执行功能的“SWPFillOptions”实例。
/// @param autoFulFillmentStyle 描述一旦行动完成后应该如何解决扩展的完成风格
/// @param timing 指定何时针对填充动画调用动作处理程序的时间
+ (SWPFillOptions *)automaticWithStyle:(SWPExpansionFulfillmentStyle)autoFulFillmentStyle timing:(SWPHandlerInvocationTiming)timing;

/// 返回手动执行的“SWPFillOptions”实例。
/// @param timing 指定何时针对填充动画调用动作处理程序的时间
+ (SWPFillOptions *)manualWithTiming:(SWPHandlerInvocationTiming)timing;

@end

#pragma mark - SWPCompletionAnimation

/// 描述展开动画完成样式
typedef NS_ENUM(NSInteger, SWPCompletionAnimationType) {
    /// 扩展将完全填充项目。
    SWPCompletionAnimationTypeFill,
    
    /// 扩展将从触发点反弹并隐藏动作视图，重置项目
    SWPCompletionAnimationTypeBounce,
};

@interface SWPCompletionAnimation : NSObject
@property (nonatomic, assign) SWPCompletionAnimationType completionAnimationType;
@property (nonatomic, strong) SWPFillOptions *fillOptions;
@end

#pragma mark - SWPTrigger

/// 描述用于确定是否应该发生扩展的附加触发器
typedef NS_ENUM(NSInteger, SWPTriggerType) {
    
    /// 触发器由在父视图中超过提供的百分比发生的触摸指定
    SWPTriggerTypeTouchThreshold,
    
    /// 触发器由经过完全暴露的动作视图的距离（以点为单位）指定
    SWPTriggerTypeOverscroll,
    
};

@interface SWPTrigger : NSObject
@property (nonatomic, assign) SWPTriggerType triggerType;
@property (nonatomic, assign) CGFloat value;
- (BOOL)isTriggeredWithView:(id<SWPSwipeable>)view
                    gesture:(UIPanGestureRecognizer *)gesture
                inSuperview:(UIView *)superview
             referenceFrame:(CGRect)referenceFrame;
@end

#pragma mark - SWPTarget

/// 描述相对目标扩展阈值。 将在指定值处发生扩展
typedef NS_ENUM(NSInteger, SWPTargetType) {
    
    /// 触发器由在父视图中超过提供的百分比发生的触摸指定
    SWPTargetTypePercentage,
    
    /// 目标由边缘插入指定
    SWPTargetTypeEdgeInset,
    
};

@interface SWPTarget : NSObject
@property (nonatomic, assign) SWPTargetType targetType;
@property (nonatomic, assign) CGFloat value;
- (CGFloat)offsetForView:(id<SWPSwipeable>)view minimumOverscroll:(CGFloat)minimumOverscroll;
@end

#pragma mark - SWPSwipeExpansionStyle

typedef NS_ENUM(NSInteger, SWPSwipeExpansionStyleType) {
    SWPSwipeExpansionStyleNone,
    SWPSwipeExpansionStyleTypeselection,
    SWPSwipeExpansionStyleTypedestructive,
    SWPSwipeExpansionStyleTypedestructiveAfterFill,
    SWPSwipeExpansionStyleTypedestructiveSecondConfirmation,
    SWPSwipeExpansionStyleTypefill,
};

/// 描述扩展样式：扩展是当单元格滑过定义的阈值时的行为
@interface SWPSwipeExpansionStyle : NSObject

@property (nonatomic, assign) SWPSwipeExpansionStyleType type;

/// 相对目标扩展阈值。 将在指定值处发生扩展
@property (nonatomic, strong) SWPTarget *target;

/// 用于确定是否应该发生扩展的附加触发器
@property (nonatomic,   copy) NSArray<SWPTrigger *> *additionalTriggers;

/// 指定按钮是否应该展开以完全填充过度滚动，或者以相对于过度滚动的百分比展开
@property (nonatomic, assign) BOOL elasticOverscroll;

/// 指定展开动画完成样式
@property (nonatomic, strong) SWPCompletionAnimation *completionAnimation;

/// 如果配置的目标小于完全暴露的动作视图，则指定所需的最小过度滚动量
@property (nonatomic, assign) CGFloat minimumTargetOverscroll;

/// 拖过扩展目标时应用的弹性量
@property (nonatomic, assign) CGFloat targetOverscrollElasticity;

@property (nonatomic, assign) CGFloat minimumExpansionTranslation;

/// 默认操作执行选择类型的行为： 单元格在选择时反弹回其未打开状态，并且该行保留在表格/集合视图中
+ (SWPSwipeExpansionStyle *)selection;

/// 默认操作执行破坏性行为：单元格以动画方式从表格/集合视图中删除
+ (SWPSwipeExpansionStyle *)destructive;

/// 默认动作在填充动画完成后执行破坏性行为： 单元格以动画方式从表格/集合视图中删除
+ (SWPSwipeExpansionStyle *)destructiveAfterFill;

/// 默认操作执行填充行为
+ (SWPSwipeExpansionStyle *)fill;

/// 二次确认
+ (SWPSwipeExpansionStyle *)destructiveSecondConfirmation;

/// 返回默认操作的“SwipeExpansionStyle”实例，该操作使用指定的选项执行破坏性行为。
+ (SWPSwipeExpansionStyle *)destructiveWithAutomaticallyDelete:(BOOL)automaticallyDelete timing:(SWPHandlerInvocationTiming)timing;

- (BOOL)shouldExpandWithSwipeable:(id<SWPSwipeable>)swipeable gesture:(UIPanGestureRecognizer *)gesture inSuperview:(UIView *)superview withinFrame:(CGRect)frame;

- (CGFloat)targetOffsetForView:(id<SWPSwipeable>)view;

@end

NS_ASSUME_NONNULL_END
