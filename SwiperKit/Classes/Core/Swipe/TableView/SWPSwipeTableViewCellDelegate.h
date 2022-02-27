//
//  SWPSwipeTableViewCellDelegate.h
//  SwiperKit
//
//  Created by yangjie.layer on 2022/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SWPSwipeActionsOrientation);

@class SWPSwipeAction;
@class SWPSwipeOptions;

@protocol SWPSwipeTableViewCellDelegate <NSObject>

@required

/// 请求代理获取在指定行中滑动显示的操作。
/// Asks the delegate for the actions to display in response to a swipe in the specified item。
/// @param tableView 拥有请求此信息的项目的表格视图对象（The tableview view object which owns the item requesting this information.）
/// @param indexPath 项目的索引路径。（The index path of the item.）
/// @param orientation 请求此信息的滑动方向。（The side of the item requesting this information.）
- (NSArray<SWPSwipeAction *> *)tableView:(UITableView *)tableView editActionsForItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

@optional

/// 请求代理获取在呈现操作时要使用的显示配置。
/// Asks the delegate for the display options to be used while presenting the action buttons.
/// @param tableView 拥有请求此信息的项目的表格视图对象（The tableview view object which owns the item requesting this information.）
/// @param indexPath 项目的索引路径。（The index path of the item.）
/// @param orientation 请求此信息的滑动方向。（The side of the item requesting this information.）
- (SWPSwipeOptions *)tableView:(UITableView *)tableView editActionsOptionsForItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

/// 告诉代理表格视图将进入滑动操作模式。
/// Tells the delegate that the table view is about to go into editing mode.
/// @param tableView 拥有请求此信息的项目的表格视图对象（The tableview view object which owns the item requesting this information.）
/// @param indexPath 项目的索引路径。（The index path of the item.）
/// @param orientation 请求此信息的滑动方向。（The side of the item requesting this information.）
- (void)tableView:(UITableView *)tableView willBeginEditingItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

/// 告诉代理表格视图已离开滑动操作模式。
/// Tells the delegate that the table view has left editing mode.
/// @param tableView 拥有请求此信息的项目的表格视图对象（The tableview view object which owns the item requesting this information.）
/// @param indexPath 项目的索引路径。（The index path of the item.）
/// @param orientation 请求此信息的滑动方向。（The side of the item requesting this information.）
- (void)tableView:(UITableView *)tableView didEndEditingItemAtAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

/**
 
 正在开发中，接下来的某个版本会支持。
 Under development, will be supported in one of the next versions。
 
 /// 向代理询问表格视图的可见矩形，用于确保滑动操作在项目的可见部分内垂直居中。
 /// Asks the delegate for visibile rectangle of the table view, which is used to ensure swipe actions are vertically centered within the visible portion of the item.
 /// @param tableView 拥有请求此信息的项目的表格视图对象（The tableview view object which owns the item requesting this information.）
 - (CGRect)visibleRectForTableView:(UITableView *)tableView;
 
 */

@end

NS_ASSUME_NONNULL_END
