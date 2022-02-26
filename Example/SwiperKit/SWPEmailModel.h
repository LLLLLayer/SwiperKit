//
//  SWPEmailModel.h
//  SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/9.
//  Copyright © 2022 LLLLLayer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWPEmailModel : NSObject

@property (nonatomic,   copy, readonly) NSString *title;
@property (nonatomic,   copy, readonly) NSString *subTitle;
@property (nonatomic,   copy, readonly) NSString *body;
@property (nonatomic, strong, readonly) NSDate *date;
@property (nonatomic, assign, readonly) BOOL read;

- (instancetype)initWithTitle:(NSString * _Nullable)title
                     subtitle:(NSString * _Nullable)subtitle
                         body:(NSString * _Nullable)body
                         date:(NSDate * _Nullable)date
                         read:(BOOL)read;

- (NSString *)formattorDate;
- (void)updateReadStatus;

@end

NS_ASSUME_NONNULL_END
