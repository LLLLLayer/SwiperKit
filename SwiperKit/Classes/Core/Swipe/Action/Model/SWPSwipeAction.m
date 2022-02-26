//
//  SWPSwipeAction.m
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/13.
//

#import "SWPSwipeAction.h"
#import "SWPSwipeActionTransitioning.h"

@implementation SWPSwipeAction

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesWhenSelected = YES;
    }
    return self;
}

@end
