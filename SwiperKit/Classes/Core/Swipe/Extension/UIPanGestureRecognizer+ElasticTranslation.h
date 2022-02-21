//
//  UIPanGestureRecognizer+ElasticTranslation.h
//  Pods-SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIPanGestureRecognizer (ElasticTranslation)

- (CGFloat)defaultElasticTranslationRatio;

- (CGPoint)elasticTranslationInView:(UIView *)view withLimit:(CGSize)limit fromOriginalCenter:(CGPoint)center applyingRatio:(CGFloat)ratio;

@end

NS_ASSUME_NONNULL_END
