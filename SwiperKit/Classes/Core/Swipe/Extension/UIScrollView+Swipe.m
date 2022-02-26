//
//  UIScrollView+Swipe.m
//  SwiperKit
//
//  Created by yangjie.layer on 2022/2/26.
//

#import "UIScrollView+Swipe.h"
#import "UICollectionView+Swipe.h"

@implementation UIScrollView (Swipe)

- (NSArray<id<SWPSwipeable>> * _Nullable)swipeables
{
    if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        return [collectionView swipeCells];
    }
    return nil;
}

- (void)hideSwipeables
{
    if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        [collectionView hideSwipeCell];
    }
}

@end
