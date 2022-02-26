//
//  SWPSwipeTransitionLayout.m
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/19.
//

#import "SWPSwipeTransitionLayout.h"

@implementation SWPActionsViewLayoutContext

@end

@implementation SWPBorderTransitionLayout

- (void)continerView:(nonnull UIView *)view didChangeVisibleWidthWithContext:(nonnull SWPActionsViewLayoutContext *)context
{
}

- (void)layoutView:(nonnull UIView *)view atIndex:(NSInteger)index withContext:(nonnull SWPActionsViewLayoutContext *)context
{
    CGFloat diff = context.visibleWidth - context.contentSize.width;
    view.frame = CGRectMake((index * context.contentSize.width / (CGFloat)context.numberOfActions + diff) * context.orientation,
                            view.frame.origin.y, view.frame.size.width, view.frame.size.height);
}

- (nonnull NSArray<NSNumber *> *)visibleWidthsForViewsWithContext:(nonnull SWPActionsViewLayoutContext *)context
{
    CGFloat diff = context.visibleWidth - context.contentSize.width;
    CGFloat visiableWidth = context.contentSize.width / (CGFloat)context.numberOfActions + diff;
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:context.numberOfActions];
    for (int index = 0; index < context.numberOfActions; ++index) {
        [temp addObject:@(visiableWidth)];
    }
    return temp.copy;
}

@end

@implementation SWPDragTransitionLayout

- (void)continerView:(nonnull UIView *)view didChangeVisibleWidthWithContext:(nonnull SWPActionsViewLayoutContext *)context
{
    view.bounds = CGRectMake((context.contentSize.width - context.visibleWidth) * context.orientation, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.width);
}

- (void)layoutView:(nonnull UIView *)view atIndex:(NSInteger)index withContext:(nonnull SWPActionsViewLayoutContext *)context
{
    view.frame = CGRectMake((CGFloat)index * context.minimumButtonWidth * context.orientation,
                            view.frame.origin.y, view.frame.size.width, view.frame.size.height);
}

- (nonnull NSArray<NSNumber *> *)visibleWidthsForViewsWithContext:(nonnull SWPActionsViewLayoutContext *)context
{
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:context.numberOfActions];
    for (int index = 0; index < context.numberOfActions; ++index) {
        [temp addObject:@(fmax(0, fmin(context.minimumButtonWidth, context.visibleWidth - (CGFloat)index * context.minimumButtonWidth)))];
    }
    return temp.copy;
}

@end

@implementation SWPRevealTransitionLayout

- (void)continerView:(UIView *)view didChangeVisibleWidthWithContext:(SWPActionsViewLayoutContext *)context
{
    view.bounds = CGRectMake((context.minimumButtonWidth * (CGFloat)context.numberOfActions - context.visibleWidth) * context.orientation,
                             view.bounds.origin.y, view.bounds.size.width, view.bounds.size.width);
}


- (void)layoutView:(nonnull UIView *)view atIndex:(NSInteger)index withContext:(nonnull SWPActionsViewLayoutContext *)context
{
    return [super layoutView:view atIndex:index withContext:context];
}

- (nonnull NSArray<NSNumber *> *)visibleWidthsForViewsWithContext:(nonnull SWPActionsViewLayoutContext *)context
{
    return [super visibleWidthsForViewsWithContext:context];
}

@end
