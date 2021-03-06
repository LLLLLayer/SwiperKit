//
//  SWPSwipeTableViewCell.h
//  SwiperKit
//
//  Created by yangjie.layer on 2022/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SWPSwipeTableViewCellDelegate;

@class SWPSwipeController;

@interface SWPSwipeTableViewCell : UITableViewCell

/// 滑动控制器
@property (nonatomic, strong, readonly, nullable) SWPSwipeController *swipeController;

/// 充当 `SwipeCollectionViewCell` 的委托的对象
@property (nonatomic, weak) id<SWPSwipeTableViewCellDelegate> _Nullable swipeTableViewCelldelegate;

@end

NS_ASSUME_NONNULL_END
