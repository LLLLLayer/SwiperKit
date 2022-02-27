//
//  UITableView+Swipe.h
//  SwiperKit
//
//  Created by yangjie.layer on 2022/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SWPSwipeable;

@interface UITableView (Swipe)

- (NSArray<id<SWPSwipeable>> * _Nullable)swipeCells;

- (void)hideSwipeCell;

@end

NS_ASSUME_NONNULL_END
