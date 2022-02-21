//
//  UIPanGestureRecognizer+ElasticTranslation.m
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/15.
//

#import "UIPanGestureRecognizer+ElasticTranslation.h"

@implementation UIPanGestureRecognizer (ElasticTranslation)

- (CGFloat)defaultElasticTranslationRatio
{
    return 0.2;
}

- (CGPoint)elasticTranslationInView:(UIView *)view withLimit:(CGSize)limit fromOriginalCenter:(CGPoint)center applyingRatio:(CGFloat)ratio
{
    CGPoint translation = [self translationInView:view];
    UIView *sourceView = self.view;
    if (!view) {
        return translation;
    }
    CGPoint updatedCenter = CGPointMake(center.x + translation.x, center.y + translation.y);
    CGSize distanceFromCenter = CGSizeMake(fabs(updatedCenter.x - CGRectGetMidX(sourceView.bounds)), fabs(updatedCenter.y - CGRectGetMidY(sourceView.bounds)));
    
    CGFloat inverseRatio = 1 - ratio;
    CGPoint scale = CGPointMake(updatedCenter.x < CGRectGetMidX(sourceView.bounds) ? -1 : 1, updatedCenter.y < CGRectGetMidY(sourceView.bounds) ? -1 : 1);
    
    CGFloat x = updatedCenter.x - (distanceFromCenter.width > limit.width ? inverseRatio * (distanceFromCenter.width - limit.width) * scale.x : 0);
    CGFloat y = updatedCenter.y - (distanceFromCenter.height > limit.height ? inverseRatio * (distanceFromCenter.height - limit.height) * scale.y : 0);

    return CGPointMake(x, y);
}

@end
