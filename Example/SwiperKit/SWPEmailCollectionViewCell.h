//
//  SWPEmailCollectionViewCell.h
//  SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/9.
//  Copyright © 2022 LLLLLayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SwiperKit/SWPSwipeCollectionViewCell.h>

@class SWPEmailModel;

NS_ASSUME_NONNULL_BEGIN

@interface SWPEmailCollectionViewCell : SWPSwipeCollectionViewCell

+ (NSString *)identifier;

- (void)configWithEmailModel:(SWPEmailModel *)model;

@end

NS_ASSUME_NONNULL_END
