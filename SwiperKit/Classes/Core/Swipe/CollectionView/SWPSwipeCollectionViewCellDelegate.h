//
//  SWPSwipeCollectionViewCellDelegate.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SWPSwipeActionsOrientation);

@class SWPSwipeAction;
@class SWPSwipeOptions;

@protocol SWPSwipeCollectionViewCellDelegate <NSObject>

@required

/// 请求代理获取在指定行中滑动显示的操作。
/// Asks the delegate for the actions to display in response to a swipe in the specified item。
/// @param collectionView 拥有请求此信息的项目的集合视图对象（The collection view object which owns the item requesting this information.）
/// @param indexPath 项目的索引路径。（The index path of the item.）
/// @param orientation 请求此信息的滑动方向。（The side of the item requesting this information.）
- (NSArray<SWPSwipeAction *> *)collectionView:(UICollectionView *)collectionView editActionsForItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

@optional

/// 请求代理获取在呈现操作时要使用的显示配置。
/// Asks the delegate for the display options to be used while presenting the action buttons.
/// @param collectionView 拥有请求此信息的项目的集合视图对象（The collection view object which owns the item requesting this information.）
/// @param indexPath 项目的索引路径。（The index path of the item.）
/// @param orientation 请求此信息的滑动方向。（The side of the item requesting this information.）
- (SWPSwipeOptions *)collectionView:(UICollectionView *)collectionView editActionsOptionsForItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

/// 告诉代理集合视图将进入滑动操作模式。
/// Tells the delegate that the collection view is about to go into editing mode.
/// @param collectionView 拥有请求此信息的项目的集合视图对象（The collection view object which owns the item requesting this information.）
/// @param indexPath 项目的索引路径。（The index path of the item.）
/// @param orientation 请求此信息的滑动方向。（The side of the item requesting this information.）
- (void)collectionView:(UICollectionView *)collectionView willBeginEditingItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

/// 告诉代理集合视图已离开滑动操作模式。
/// Tells the delegate that the collection view has left editing mode.
/// @param collectionView 拥有请求此信息的项目的集合视图对象（The collection view object which owns the item requesting this information.）
/// @param indexPath 项目的索引路径。（The index path of the item.）
/// @param orientation 请求此信息的滑动方向。（The side of the item requesting this information.）
- (void)collectionView:(UICollectionView *)collectionView didEndEditingItemAtAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

/**
 
 正在开发中，接下来的某个版本会支持。
 Under development, will be supported in one of the next versions。
 
 /// 向代理询问集合视图的可见矩形，用于确保滑动操作在项目的可见部分内垂直居中。
 /// Asks the delegate for visibile rectangle of the collection view, which is used to ensure swipe actions are vertically centered within the visible portion of the item.
 /// @param collectionView 拥有请求此信息的项目的集合视图对象（The collection view object which owns the item requesting this information.）
 - (CGRect)visibleRectForCollectionView:(UICollectionView *)collectionView;
 
 */

@end

NS_ASSUME_NONNULL_END
