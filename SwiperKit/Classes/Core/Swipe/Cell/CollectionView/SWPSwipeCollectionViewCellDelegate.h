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

/// 请求代理获取在指定行中滑动显示的操作
/// @param collectionView 拥有请求此信息的项目的集合视图对象
/// @param indexPath 项目的索引路径
/// @param orientation 请求此信息的滑动方向
- (NSArray<SWPSwipeAction *> *)collectionView:(UICollectionView *)collectionView editActionsForItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

@optional

/// 请求代理获取在呈现操作时要使用的显示配置
/// @param collectionView 拥有请求此信息的项目的集合视图对象
/// @param indexPath 项目的索引路径
/// @param orientation 请求此信息的滑动方向
- (SWPSwipeOptions *)collectionView:(UICollectionView *)collectionView editActionsOptionsForItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

/// 告诉代理集合视图将进入滑动操作模式
/// @param collectionView 拥有请求此信息的项目的集合视图对象
/// @param indexPath 项目的索引路径
/// @param orientation 请求此信息的滑动方向
- (void)collectionView:(UICollectionView *)collectionView willBeginEditingItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

/// 告诉代理集合视图已离开滑动操作模式
/// @param collectionView 拥有请求此信息的项目的集合视图对象
/// @param indexPath 项目的索引路径
/// @param orientation 请求此信息的滑动方向
- (void)collectionView:(UICollectionView *)collectionView didEndEditingItemAtAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

/**
 
 正在开发中，接下来的某个版本会支持。
 
 /// 向代理询问集合视图的可见矩形，用于确保滑动操作在项目的可见部分内垂直居中。
 /// @param collectionView 拥有请求此信息的项目的集合视图对象
 - (CGRect)visibleRectForCollectionView:(UICollectionView *)collectionView;
 
 */

@end

NS_ASSUME_NONNULL_END
