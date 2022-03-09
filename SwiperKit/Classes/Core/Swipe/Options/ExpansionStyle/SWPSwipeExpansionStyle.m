//
//  SWPSwipeExpansionStyle.m
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/17.
//

#import "SWPSwipeExpansionStyle.h"
#import "SWPSwipeActionsView.h"
#import "SWPSwipeOptions.h"
#import "SWPSwipeAction.h"
#import "SWPSwipeable.h"

@implementation SWPFillOptions

+ (SWPFillOptions *)automaticWithStyle:(SWPExpansionFulfillmentStyle)autoFulFillmentStyle timing:(SWPHandlerInvocationTiming)timing
{
    SWPFillOptions *options = [[SWPFillOptions alloc] init];
    options.autoFulFillmentStyle = autoFulFillmentStyle;
    options.timing = timing;
    return options;
}

+ (SWPFillOptions *)manualWithTiming:(SWPHandlerInvocationTiming)timing;
{
    SWPFillOptions *options = [[SWPFillOptions alloc] init];
    options.timing = timing;
    return options;
}

@end

@implementation SWPCompletionAnimation
@end

@implementation SWPTrigger

- (BOOL)isTriggeredWithView:(id<SWPSwipeable>)view
                    gesture:(UIPanGestureRecognizer *)gesture
                inSuperview:(UIView *)superview
             referenceFrame:(CGRect)referenceFrame
{
    SWPSwipeActionsView *actionsView = view.swipeActionsView;
    if (!actionsView) {
        return  NO;
    }
    switch (self.triggerType) {
        case SWPTriggerTypeTouchThreshold:
        {
            CGFloat location = [gesture locationInView:superview].x - referenceFrame.origin.x;
            CGFloat locationRatio = (actionsView.orientation == SWPSwipeActionsOrientationLeft ? location : referenceFrame.size.width - location) / referenceFrame.size.width;
            return locationRatio > self.value;
        }
        case SWPTriggerTypeOverscroll:
            return fabs(CGRectGetMinX(view.frame)) > actionsView.preferredWidth + self.value;
    }
}

@end

@implementation SWPTarget

- (CGFloat)offsetForView:(id<SWPSwipeable>)view minimumOverscroll:(CGFloat)minimumOverscroll
{
    SWPSwipeActionsView *actionsView = view.swipeActionsView;
    if (!actionsView) {
        return MAXFLOAT;
    }
    
    CGFloat offset;
    switch (self.targetType) {
        case SWPTargetTypePercentage:
            offset = view.frame.size.width * self.value;
            break;
        case SWPTargetTypeEdgeInset:
            offset = view.frame.size.width - self.value;
            break;
    }
    
    return fmax(actionsView.preferredWidth + minimumOverscroll, offset);
}

@end


@implementation SWPSwipeExpansionStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minimumTargetOverscroll = 20;
        self.targetOverscrollElasticity = 0.2;
        self.minimumExpansionTranslation = 8.0;
    }
    return self;
}

+ (SWPSwipeExpansionStyle *)selection
{
    SWPSwipeExpansionStyle *style = [[SWPSwipeExpansionStyle alloc] init];
    style.type = SWPSwipeExpansionStyleTypeselection;
    style.target = [[SWPTarget alloc] init];
    style.target.targetType = SWPTargetTypePercentage;
    style.target.value = 0.5;
    style.elasticOverscroll = YES;
    style.completionAnimation = [[SWPCompletionAnimation alloc] init];
    style.completionAnimation.completionAnimationType = SWPCompletionAnimationTypeBounce;
    return style;
}

+ (SWPSwipeExpansionStyle *)destructive
{
    
    SWPSwipeExpansionStyle *style = [self destructiveWithAutomaticallyDelete:YES timing:SWPHandlerInvocationTimingWith];
    style.type = SWPSwipeExpansionStyleTypedestructive;
    return style;
}

+ (SWPSwipeExpansionStyle *)destructiveAfterFill
{
    SWPSwipeExpansionStyle *style =  [self destructiveWithAutomaticallyDelete:YES timing:SWPHandlerInvocationTimingWithAfter];
    style.type = SWPSwipeExpansionStyleTypedestructiveAfterFill;
    return style;
}

+ (SWPSwipeExpansionStyle *)fill
{
    SWPSwipeExpansionStyle *style = [[SWPSwipeExpansionStyle alloc] init];
    style.type = SWPSwipeExpansionStyleTypefill;
    style.target = [[SWPTarget alloc] init];
    style.target.targetType = SWPTargetTypeEdgeInset;
    style.target.value = 30;
    SWPTrigger *trigger = [[SWPTrigger alloc] init];
    trigger.triggerType = SWPTriggerTypeOverscroll;
    trigger.value = 30;
    style.additionalTriggers = @[trigger];
    style.completionAnimation = [[SWPCompletionAnimation alloc] init];
    style.completionAnimation.completionAnimationType = SWPCompletionAnimationTypeFill;
    style.completionAnimation.fillOptions = [SWPFillOptions manualWithTiming:SWPHandlerInvocationTimingWithAfter];
    return style;
}

+ (SWPSwipeExpansionStyle *)destructiveWithAutomaticallyDelete:(BOOL)automaticallyDelete timing:(SWPHandlerInvocationTiming)timing
{
    SWPSwipeExpansionStyle *style = [[SWPSwipeExpansionStyle alloc] init];
    style.target = [[SWPTarget alloc] init];
    style.target.targetType = SWPTargetTypeEdgeInset;
    style.target.value = 30;
    SWPTrigger *trigger = [[SWPTrigger alloc] init];
    trigger.triggerType = SWPTriggerTypeTouchThreshold;
    trigger.value = 0.8;
    style.additionalTriggers = @[trigger];
    style.completionAnimation = [[SWPCompletionAnimation alloc] init];
    style.completionAnimation.completionAnimationType = SWPCompletionAnimationTypeFill;
    if (automaticallyDelete) {
        style.completionAnimation.fillOptions = [SWPFillOptions automaticWithStyle:SWPExpansionFulfillmentStyleDelete timing:timing];
    } else {
        style.completionAnimation.fillOptions = [SWPFillOptions manualWithTiming:timing];
    }
    return style;
}

+ (SWPSwipeExpansionStyle *)destructiveSecondConfirmation
{
    SWPSwipeExpansionStyle *style = [SWPSwipeExpansionStyle destructiveAfterFill];
    style.type = SWPSwipeExpansionStyleTypedestructiveSecondConfirmation;
    return style;
}


- (BOOL)shouldExpandWithSwipeable:(id<SWPSwipeable>)swipeable gesture:(UIPanGestureRecognizer *)gesture inSuperview:(UIView *)superview withinFrame:(CGRect)frame
{
    SWPSwipeActionsView *actionsView = swipeable.swipeActionsView;
    UIView *gestureView = gesture.view;
    if (!actionsView || !gestureView) {
        return NO;
    }
    if (fabs([gesture translationInView:gestureView].x) <= self.minimumExpansionTranslation) {
        return NO;
    }
    CGFloat xDelta;
    if (!CGRectEqualToRect(frame, CGRectNull)) {
        xDelta = fabs(CGRectGetMinX(frame));
    } else {
        xDelta = fabs(CGRectGetMinX(swipeable.frame));
    }
    if (xDelta < actionsView.preferredWidth) {
        return NO;
    } else if (xDelta > [self targetOffsetForView:swipeable]) {
        return YES;
    }
    
    CGRect referenceFrame = CGRectEqualToRect(frame, CGRectNull) ? superview.bounds : swipeable.frame;
    for (SWPTrigger *trigger in self.additionalTriggers) {
        if ([trigger isTriggeredWithView:swipeable gesture:gesture inSuperview:superview referenceFrame:referenceFrame]) {
            return YES;
        }
    }
    return NO;
}

- (CGFloat)targetOffsetForView:(id<SWPSwipeable>)view
{
    return [self.target offsetForView:view minimumOverscroll:self.minimumTargetOverscroll];
}

@end
