//
//  SWPSwipeCollectionViewCell.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/10.
//

#import <UIKit/UIKit.h>

@protocol SWPSwipeCollectionViewCellDelegate;

@class SWPSwipeController;

NS_ASSUME_NONNULL_BEGIN

@interface SWPSwipeCollectionViewCell : UICollectionViewCell

/// 滑动控制器
@property (nonatomic, strong, readonly, nullable) SWPSwipeController *swipeController;

/// 充当 `SwipeCollectionViewCell` 的委托的对象
@property (nonatomic, weak) id<SWPSwipeCollectionViewCellDelegate> _Nullable swipeCollectionViewCelldelegate;

@end

NS_ASSUME_NONNULL_END
