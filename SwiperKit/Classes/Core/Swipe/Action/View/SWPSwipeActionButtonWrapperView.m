//
//  SwipeActionButtonWrapperView.m
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/20.
//

#import <SwiperKit/SWPSwipeAction.h>
#import "SWPSwipeOptions.h"
#import "SWPSwipeActionButtonWrapperView.h"

@interface SWPSwipeActionButtonWrapperView ()

@end

@implementation SWPSwipeActionButtonWrapperView

- (instancetype)initWithFrame:(CGRect)frame
                       action:(SWPSwipeAction *)action
                  orientation:(SWPSwipeActionsOrientation)orientation
                 contentWidth:(CGFloat)contentWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        switch (orientation) {
            case SWPSwipeActionsOrientationLeft:
                self.contentRect = CGRectMake(frame.size.width - contentWidth, 0, contentWidth, frame.size.height);
                break;
            case SWPSwipeActionsOrientationRight:
                self.contentRect = CGRectMake(0, 0, contentWidth, frame.size.height);
                break;
            default:
                break;
        }
        [self __configureBackgroundColorWithAction:action];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.actionBackgroundColor && context) {
        [self.actionBackgroundColor setFill];
        CGContextFillRect(context, rect);
    }
}

- (void)__configureBackgroundColorWithAction:(SWPSwipeAction *)action
{
    if (action.backgroundColor == [UIColor clearColor] && !action.backgroundEffect) {
        [self setOpaque:YES];
        return;
    }
    self.actionBackgroundColor = action.backgroundColor;
}

@end
