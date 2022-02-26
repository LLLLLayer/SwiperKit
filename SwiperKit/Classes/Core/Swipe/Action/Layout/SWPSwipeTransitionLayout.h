//
//  SWPSwipeTransitionLayout.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SWPActionsViewLayoutContext;
typedef NS_ENUM(NSInteger, SWPSwipeActionsOrientation);

@protocol SWPSwipeTransitionLayout <NSObject>

- (void)continerView:(UIView *)view didChangeVisibleWidthWithContext:(SWPActionsViewLayoutContext *)context;
- (void)layoutView:(UIView *)view atIndex:(NSInteger)index withContext:(SWPActionsViewLayoutContext *)context;
- (NSArray<NSNumber *> *)visibleWidthsForViewsWithContext:(SWPActionsViewLayoutContext *)context;

@end

@interface SWPActionsViewLayoutContext : NSObject

@property (nonatomic, assign) SWPSwipeActionsOrientation orientation;
@property (nonatomic, assign) NSInteger numberOfActions;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGFloat visibleWidth;
@property (nonatomic, assign) CGFloat minimumButtonWidth;

@end

@interface SWPBorderTransitionLayout : NSObject<SWPSwipeTransitionLayout>

@end

@interface SWPDragTransitionLayout : NSObject<SWPSwipeTransitionLayout>

@end

@interface SWPRevealTransitionLayout : SWPDragTransitionLayout

@end

NS_ASSUME_NONNULL_END
