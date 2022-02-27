//
//  UITableView+Swipe.m
//  SwiperKit
//
//  Created by yangjie.layer on 2022/2/26.
//

#import "UITableView+Swipe.h"
#import "SWPSwipeTableViewCell.h"
#import "SWPSwipeTableViewCell+Display.h"

@implementation UITableView (Swipe)

- (NSArray<id<SWPSwipeable>> * _Nullable)swipeCells
{
    NSArray *visibleCells = self.visibleCells;
    NSMutableArray *tempswipeCells = [[NSMutableArray alloc] initWithCapacity:visibleCells.count];
    for (UITableViewCell *cell in self.visibleCells) {
        if ([cell isKindOfClass:[SWPSwipeTableViewCell class]]) {
            [tempswipeCells addObject:cell];
        }
    }
    return [tempswipeCells copy];
}

- (void)hideSwipeCell
{
    for (SWPSwipeTableViewCell *cell in [self swipeCells]) {
        [cell hideSwipeWithAnimated:YES complation:nil];
    }
}

@end
