//
//  SWPSwipeActionTransitioning.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SWPSwipeActionTransitioningContext;

// 采用“SwipeActionTransitioning”协议，实现在过渡期间实现自定义动作外观的对象
@protocol SWPSwipeActionTransitioning <NSObject>

- (void)didTransitionWithContext:(SWPSwipeActionTransitioningContext *)context;

@end

@interface SWPSwipeActionTransitioningContext : NSObject

@property (nonatomic,   copy, nullable) NSString *actionIdentifier;
@property (nonatomic, assign) CGFloat oldPercentVisible;
@property (nonatomic, assign) CGFloat newPercentVisible;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *wrapperView;

- (void)setBackgroundColor:(UIColor *)backgroundColor;

@end

@interface SWPScaleTransition : NSObject<SWPSwipeActionTransitioning>

@property (nonatomic, assign) double duration;
@property (nonatomic, assign) CGFloat initialScale;
@property (nonatomic, assign) CGFloat threshold;

@end

NS_ASSUME_NONNULL_END
