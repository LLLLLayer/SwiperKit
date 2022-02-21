//
//  SWPSwipeActionView.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SWPSwipeOptions;
@class SWPSwipeAction;

@interface SWPSwipeActionButton : UIButton

@property (nonatomic, assign) CGFloat spacing;

- (instancetype)initWithAction:(SWPSwipeAction *)action;
- (UIEdgeInsets)buttonEdgeInsetsFromOptions:(SWPSwipeOptions *)options;
- (CGFloat)preferredWidthMaximum:(CGFloat)maximum;

@end

NS_ASSUME_NONNULL_END
