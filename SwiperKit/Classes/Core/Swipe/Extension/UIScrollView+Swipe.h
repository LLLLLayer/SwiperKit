//
//  UIScrollView+Swipe.h
//  SwiperKit
//
//  Created by yangjie.layer on 2022/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SWPSwipeable;

@interface UIScrollView (Swipe)

- (NSArray<id<SWPSwipeable>> * _Nullable)swipeables;

- (void)hideSwipeables;

@end

NS_ASSUME_NONNULL_END
