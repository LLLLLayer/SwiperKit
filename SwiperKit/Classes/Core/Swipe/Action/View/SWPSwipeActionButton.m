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
@property (nonatomic, strong) UIFont *titleLabelFont;

@end

@implementation SWPSwipeActionButton

- (instancetype)initWithAction:(SWPSwipeAction *)action
{
    self = [super init];
    if (self) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        UIColor *highlightedTextColor = action.highlightedTextColor ?: self.tintColor;
        self.highlightedBackgroundColor = action.highlightedBackgroundColor ?: [[UIColor blackColor] colorWithAlphaComponent:0.1];
        
        self.titleLabelFont = action.font ?: [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        [self.titleLabel setFont:self.titleLabelFont];
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
    UIFont *font = self.titleLabelFont;
    if (!title || !font) {
        return CGRectZero;
    }
    return CGRectIntegral([title boundingRectWithSize:size
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{ NSFontAttributeName : font }
                                              context:nil]);
}

- (CGFloat)imageHeight
{
    return self.currentImage ? self.maximumImageHeight : 0;
}

- (CGFloat)currentSpacing
{
    return (self.currentTitle.length && self.imageHeight) ? self.spacing : 0;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [self.class centerRect:contentRect size:[self titleBoundingRectWithSize:contentRect.size].size];
    rect.origin.y = CGRectGetMinY([self alignmentRect]) + self.imageHeight + self.currentSpacing;
    return rect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [self.class centerRect:contentRect size:self.currentImage ? self.currentImage.size : CGSizeZero];
    rect.origin.y = CGRectGetMinY([self alignmentRect]) + (self.imageHeight - rect.size.height) * 0.5;
    return rect;
}

- (CGRect)alignmentRect
{
    CGRect contentRect = [self contentRectForBounds:self.bounds];
    CGFloat titleHeight = [self titleBoundingRectWithSize:contentRect.size].size.height;
    CGFloat totalHeight = self.imageHeight + titleHeight + self.currentSpacing;
    return [self.class centerRect:contentRect size:CGSizeMake(contentRect.size.width, totalHeight)];
}

+ (CGRect)centerRect:(CGRect)rect size:(CGSize)size
{
    return CGRectMake(rect.origin.x + (rect.size.width - size.width) * 0.5,
                      rect.origin.y + (rect.size.height - size.height) * 0.5,
                      size.width,
                      size.height);
}

@end
