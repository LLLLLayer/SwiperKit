//
//  SWPSwipeTableViewCell+Display.m
//  SwiperKit
//
//  Created by yangjie.layer on 2022/2/26.
//

#import "SWPSwipeController.h"
#import "SWPSwipeTableViewCell+Display.h"

@implementation SWPSwipeTableViewCell (Display)

- (void)hideSwipeWithAnimated:(BOOL)animated complation:(void(^ _Nullable)(BOOL complete))complation
{
    [self.swipeController hideSwipeWithAnimated:animated complation:complation];
}

- (void)showSwipeWithOrientation:(SWPSwipeActionsOrientation)orientation animated:(BOOL)animated complation:(void(^ _Nullable)(BOOL complete))complation;
{
    [self.swipeController showSwipeWithOrientation:orientation animated:animated complation:complation];
}

- (void)setOffset:(CGFloat)offset animated:(BOOL)animated completion:(void(^ _Nullable)(BOOL completed))completion
{
    [self.swipeController setOffset:offset animated:animated completion:completion];
}

@end
