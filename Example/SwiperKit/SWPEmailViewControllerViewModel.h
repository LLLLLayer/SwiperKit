//
//  SWPEmailViewControllerViewModel.h
//  SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/9.
//  Copyright © 2022 LLLLLayer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWPEmailModel;

NS_ASSUME_NONNULL_BEGIN

@interface SWPEmailViewControllerViewModel : NSObject

@property (nonatomic,   copy, readonly) NSArray<NSArray<SWPEmailModel *> *> *sections;

@end

NS_ASSUME_NONNULL_END
