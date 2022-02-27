//
//  SWPSWPEmailTableViewCell.m
//  SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/26.
//  Copyright © 2022 LLLLLayer. All rights reserved.
//

#import "SWPEmailModel.h"
#import "SWPSWPEmailTableViewCell.h"

@interface SWPSWPEmailTableViewCell ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;
@property (nonatomic, strong) UILabel *body;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation SWPSWPEmailTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass(SWPSWPEmailTableViewCell.class);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self __setupUI];
    }
    return self;
}

- (void)__setupUI
{
    self.contentView.backgroundColor = UIColor.secondarySystemBackgroundColor;
    
    [self.contentView addSubview:self.title];
    self.title.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.title.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16.0],
        [self.title.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16.0]
    ]];

    [self.contentView addSubview:self.subtitle];
    self.subtitle.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.subtitle.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16.0],
        [self.subtitle.topAnchor constraintEqualToAnchor:self.title.bottomAnchor constant:8.0],
        [self.subtitle.widthAnchor constraintEqualToConstant:UIScreen.mainScreen.bounds.size.width - 32.0],
    ]];

    [self.contentView addSubview:self.body];
    self.body.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.body.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16.0],
        [self.body.topAnchor constraintEqualToAnchor:self.subtitle.bottomAnchor constant:8.0],
        [self.body.widthAnchor constraintEqualToConstant:UIScreen.mainScreen.bounds.size.width - 32.0],
        [self.body.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-16.0]
    ]];
    
    [self.contentView addSubview:self.icon];
    self.icon.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.icon.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-16.0],
        [self.icon.centerYAnchor constraintEqualToAnchor:self.title.centerYAnchor],
        [self.icon.widthAnchor constraintEqualToConstant:10.0],
        [self.icon.heightAnchor constraintEqualToConstant:18.0]
    ]];

    [self.contentView addSubview:self.date];
    self.date.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.date.rightAnchor constraintEqualToAnchor:self.icon.leftAnchor constant:-8.0],
        [self.date.centerYAnchor constraintEqualToAnchor:self.title.centerYAnchor],
        [self.date.widthAnchor constraintGreaterThanOrEqualToConstant:0],
        [self.date.heightAnchor constraintEqualToAnchor:self.title.heightAnchor]
    ]];
}

- (void)configWithEmailModel:(SWPEmailModel *)model
{
    self.title.text = model.title;
    self.subtitle.text = model.subTitle;
    self.body.text = model.body;
    self.date.text = model.formattorDate;
}

#pragma mark - Getter

- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = UIColor.labelColor;
        _title.textAlignment = NSTextAlignmentLeft;
        _title.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightHeavy];
    }
    return _title;
}

- (UILabel *)subtitle
{
    if (!_subtitle) {
        _subtitle = [[UILabel alloc] init];
        _subtitle.textColor = [UIColor.labelColor colorWithAlphaComponent:0.9];
        _subtitle.textAlignment = NSTextAlignmentLeft;
        _subtitle.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
    }
    return _subtitle;
}

- (UILabel *)body
{
    if (!_body) {
        _body = [[UILabel alloc] init];
        _body.numberOfLines = 0;
        _body.textColor = [UIColor.labelColor colorWithAlphaComponent:0.5];
        _body.textAlignment = NSTextAlignmentLeft;
        _body.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
    }
    return _body;
}

- (UILabel *)date
{
    if (!_date) {
        _date = [[UILabel alloc] init];
        _date.textColor = [UIColor.labelColor colorWithAlphaComponent:0.7];
        _date.textAlignment = NSTextAlignmentLeft;
        _date.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
    }
    return _date;
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.forward"
                                                           withConfiguration:[UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightBold]]];
        _icon.tintColor = UIColor.tertiaryLabelColor;
    }
    return _icon;
}

@end
