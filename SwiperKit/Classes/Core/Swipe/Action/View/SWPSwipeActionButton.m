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

@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

@end

@implementation SWPSwipeActionButton

- (instancetype)initWithAction:(SWPSwipeAction *)action
{
    self = [super init];
    if (self) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        UIColor *highlightedTextColor = action.highlightedTextColor ?: self.tintColor;
        self.highlightedBackgroundColor = action.highlightedBackgroundColor ?: [[UIColor blackColor] colorWithAlphaComponent:0.1];
        
        [self.titleLabel setFont:action.font ?: [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        
        [self setTitle:action.title forState:UIControlStateNormal];
        [self setTitleColor:action.textColor forState:UIControlStateNormal];
        [self setTitleColor:highlightedTextColor forState:UIControlStateHighlighted];
        [self setImage:action.image forState:UIControlStateNormal];
        [self setImage:action.highlightedImage ?: action.image forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (self.shouldHighlight) {
        self.backgroundColor = highlighted ? self.highlightedBackgroundColor : [UIColor clearColor];
    }
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
