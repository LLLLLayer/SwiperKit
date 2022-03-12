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

/// 请求代理获取在指定行中滑动显示的操作
/// @param tableView 拥有请求此信息的项目的表格视图对象
/// @param indexPath 项目的索引路径。
/// @param orientation 请求此信息的滑动方向
- (NSArray<SWPSwipeAction *> *)tableView:(UITableView *)tableView editActionsForItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

@optional

/// 请求代理获取在呈现操作时要使用的显示配置
/// @param tableView 拥有请求此信息的项目的表格视图对象
/// @param indexPath 项目的索引路径。
/// @param orientation 请求此信息的滑动方向
- (SWPSwipeOptions *)tableView:(UITableView *)tableView editActionsOptionsForItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

/// 告诉代理表格视图将进入滑动操作模式
/// @param tableView 拥有请求此信息的项目的表格视图对象
/// @param indexPath 项目的索引路径。
/// @param orientation 请求此信息的滑动方向
- (void)tableView:(UITableView *)tableView willBeginEditingItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

/// 告诉代理表格视图已离开滑动操作模式。
/// @param tableView 拥有请求此信息的项目的表格视图对象
/// @param indexPath 项目的索引路径。
/// @param orientation 请求此信息的滑动方向
- (void)tableView:(UITableView *)tableView didEndEditingItemAtAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation;

/**
 
 正在开发中，接下来的某个版本会支持。
 
 /// 向代理询问表格视图的可见矩形，用于确保滑动操作在项目的可见部分内垂直居中
 - (CGRect)visibleRectForTableView:(UITableView *)tableView;
 
 */

@end

NS_ASSUME_NONNULL_END
