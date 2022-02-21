//
//  SWPSwipeActionTransitioning.m
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/19.
//

#import "SWPSwipeActionTransitioning.h"

@implementation SWPSwipeActionTransitioningContext

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.wrapperView.backgroundColor = backgroundColor;
}

@end

@implementation SWPScaleTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.duration = 0.15;
        self.initialScale = 0.8;
        self.threshold = 0.5;
    }
    return self;
}

- (void)didTransitionWithContext:(SWPSwipeActionTransitioningContext *)context
{
    if (context.oldPercentVisible == 0) {
        context.button.transform = CGAffineTransformMakeScale(self.initialScale, self.initialScale);
    }
    
    if (context.oldPercentVisible < self.threshold && context.newPercentVisible >= self.threshold) {
        [UIView animateWithDuration:self.duration animations:^{
            context.button.transform = CGAffineTransformIdentity;
        }];
    } else if (context.oldPercentVisible >= self.threshold && context.newPercentVisible < self.threshold) {
        [UIView animateWithDuration:self.duration animations:^{
            context.button.transform = CGAffineTransformMakeScale(self.initialScale, self.initialScale);
        }];
    }
}

@end
