//
//  SWPSwipeCollectionViewCell.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/10.
//

#import <UIKit/UIKit.h>

@protocol SWPSwipeCollectionViewCellDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface SWPSwipeCollectionViewCell : UICollectionViewCell

/// 充当 `SwipeCollectionViewCell` 的委托的对象。
/// The object that acts as the delegate of the `SwipeCollectionViewCell`.
@property (nonatomic, weak) id<SWPSwipeCollectionViewCellDelegate> _Nullable swipeCollectionViewCelldelegate;

@end

NS_ASSUME_NONNULL_END
