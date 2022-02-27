//
//  UIScrollView+Swipe.m
//  SwiperKit
//
//  Created by yangjie.layer on 2022/2/26.
//

#import "UIScrollView+Swipe.h"
#import "UITableView+Swipe.h"
#import "UICollectionView+Swipe.h"

@implementation UIScrollView (Swipe)

- (NSArray<id<SWPSwipeable>> * _Nullable)swipeables
{
    if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        return [collectionView swipeCells];
    }
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        return [tableView swipeCells];
    }
    return nil;
}

- (void)hideSwipeables
{
    if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        [collectionView hideSwipeCell];
    }
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        [tableView hideSwipeCell];
    }
}

@end
