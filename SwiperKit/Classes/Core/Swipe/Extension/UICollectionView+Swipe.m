//
//  UICollectionView+Swipe.m
//  SwiperKit
//
//  Created by yangjie.layer on 2022/2/26.
//

#import "UICollectionView+Swipe.h"
#import "SWPSwipeCollectionViewCell.h"
#import "SWPSwipeCollectionViewCell+Display.h"


@implementation UICollectionView (Swipe)

- (NSArray<id<SWPSwipeable>> * _Nullable)swipeCells
{
    NSArray *visibleCells = self.visibleCells;
    NSMutableArray *tempswipeCells = [[NSMutableArray alloc] initWithCapacity:visibleCells.count];
    for (UICollectionViewCell *cell in self.visibleCells) {
        if ([cell isKindOfClass:[SWPSwipeCollectionViewCell class]]) {
            [tempswipeCells addObject:cell];
        }
    }
    return [tempswipeCells copy];
}

- (void)hideSwipeCell
{
    for (SWPSwipeCollectionViewCell *cell in [self swipeCells]) {
        [cell hideSwipeWithAnimated:YES complation:nil];
    }
}

@end
