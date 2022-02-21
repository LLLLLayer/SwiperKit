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

- (id<SWPSwipeActionTransitioning>)transitionDelegate
{
    if (!_transitionDelegate) {
        _transitionDelegate = [[SWPScaleTransition alloc] init];
    }
    return _transitionDelegate;
}

- (UIFont *)font
{
    if (!_font) {
        _font = [UIFont systemFontOfSize:15.0];
    }
    return _font;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor whiteColor];
    }
    return _textColor;
}

- (UIColor *)highlightedTextColor
{
    if (!_highlightedTextColor) {
        _highlightedTextColor = self.textColor;
    }
    return _highlightedTextColor;
}

- (UIColor *)highlightedImage
{
    if (!_highlightedImage) {
        _highlightedImage = self.image;
    }
    return _highlightedImage;
}

- (UIColor *)backgroundColor
{
    if (!_backgroundColor) {
        _backgroundColor = self.style == SWPSwipeActionStyleDefault ? [UIColor orangeColor] : [UIColor redColor];
    }
    return _backgroundColor;
}

- (UIColor *)highlightedBackgroundColor
{
    if (!_highlightedBackgroundColor) {
        _highlightedBackgroundColor = self.backgroundColor;
    }
    return _highlightedBackgroundColor;
}

@end
