//
//  SWPEmailModel.m
//  SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/9.
//  Copyright © 2022 LLLLLayer. All rights reserved.
//

#import "SWPEmailModel.h"

@interface SWPEmailModel ()

@property (nonatomic,   copy) NSString *title;
@property (nonatomic,   copy) NSString *subTitle;
@property (nonatomic,   copy) NSString *body;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL read;

@end

@implementation SWPEmailModel

- (instancetype)initWithTitle:(NSString * _Nullable)title
                     subtitle:(NSString * _Nullable)subtitle
                         body:(NSString * _Nullable)body
                         date:(NSDate * _Nullable)date
                         read:(BOOL)read;
{
    self = [super init];
    if (self) {
        self.title = title;
        self.subTitle = subtitle;
        self.body = body;
        self.date = date;
        self.read = read;
    }
    return self;
}

- (NSString *)formattorDate
{
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    formattor.dateStyle = NSDateFormatterShortStyle;
    formattor.timeStyle = NSDateFormatterNoStyle;
    return [formattor stringFromDate:self.date];
}

- (void)updateReadStatus
{
    self.read = !self.read;
}

@end
