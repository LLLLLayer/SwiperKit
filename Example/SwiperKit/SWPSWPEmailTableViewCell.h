//
//  SWPSWPEmailTableViewCell.h
//  SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/26.
//  Copyright © 2022 LLLLLayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SwiperKit/SWPSwipeTableViewCell.h>

NS_ASSUME_NONNULL_BEGIN

@class SWPEmailModel;

@interface SWPSWPEmailTableViewCell : SWPSwipeTableViewCell

+ (NSString *)identifier;

- (void)configWithEmailModel:(SWPEmailModel *)model;

@end

NS_ASSUME_NONNULL_END
