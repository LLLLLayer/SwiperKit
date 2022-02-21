//
//  SWPSwipeActionView.m
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/13.
//

#import "SWPSwipeOptions.h"
#import "SWPSwipeActionButton.h"

#import <SwiperKit/SWPSwipeAction.h>

@interface SWPSwipeActionButton ()

@end

@implementation SWPSwipeActionButton

- (instancetype)initWithAction:(SWPSwipeAction *)action
{
    self = [super init];
    if (self) {
        self.spacing = 8.0;
        [self setTitle:action.title forState:UIControlStateNormal];
        [self.titleLabel setFont:action.font ?: [UIFont systemFontOfSize:15.0]];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}

- (UIEdgeInsets)buttonEdgeInsetsFromOptions:(SWPSwipeOptions *)options
{
    CGFloat padding = options.buttonPadding != 0 ?: 8.0;
    return UIEdgeInsetsMake(padding, padding, padding, padding);
}

- (CGFloat)preferredWidthMaximum:(CGFloat)maximum
{
    CGFloat width = maximum > 0 ? maximum : MAXFLOAT;
    CGFloat textWidth = [self titleBoundingRectWithSize:CGSizeMake(width, MAXFLOAT)].size.width;
    CGFloat imageWidth = self.currentImage.size.width;
    return fmin(width, fmax(textWidth, imageWidth) + self.contentEdgeInsets.left + self.contentEdgeInsets.right);
}

-(CGRect)titleBoundingRectWithSize:(CGSize)size
{
    NSString *title = self.currentTitle;
    UIFont *font = self.titleLabel.font;
    if (!title || !font) {
        return CGRectZero;
    }
    return CGRectIntegral([title boundingRectWithSize:size
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{ NSFontAttributeName : font }
                                              context:nil]);
}

@end
