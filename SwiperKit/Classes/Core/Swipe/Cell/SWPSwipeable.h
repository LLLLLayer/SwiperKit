//
//  SWPSwipeable.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SWPSwipeAction;
@class SWPSwipeActionsView;

/// 当前发生滑动的视图状态
typedef NS_ENUM(NSInteger, SWPSwipeState) {
    // 中心
    SWPSwipeStateCenter = 0,
    
    // 左侧操作视图露出
    SWPSwipeStateLeft = 1,
    
    // 右侧操作视图露出
    SWPSwipeStateRight = 2,
    
    // 视图被拖拽中
    SWPSwipeStateDragging = 3,
    
    // 以动画形式到中心
    SWPSwipeStateAnimatingToCenter = 4,
};

/// 发生滑动的视图需要遵守的协议
@protocol SWPSwipeable <NSObject>

/// 当前发生滑动的视图状态
@property (nonatomic, assign) SWPSwipeState swipeState;

/// 操作视图
@property (nonatomic, strong, nullable) SWPSwipeActionsView *swipeActionsView;

/// Frame
@property (nonatomic, assign) CGRect frame;

/// 当前 Cell 的 indexPath
@property (nonatomic, assign, nullable) NSIndexPath *indexPath;

/// 所属的 TableView/CollectionView
@property (nonatomic, strong, nullable) UIScrollView *scrollView;

/// 拖动手势
@property (nonatomic, strong) UIGestureRecognizer *panGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
