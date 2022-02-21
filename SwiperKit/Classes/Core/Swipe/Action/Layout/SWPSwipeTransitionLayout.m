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
    for (int i = 0; i < context.numberOfActions; i++) { [temp addObject:@(visiableWidth)]; }
    return temp.copy;
}

@end
