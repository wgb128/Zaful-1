//
//  ZFOrderAddressCell.m
//  Zaful
//
//  Created by TsangFa on 17/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderAddressCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressInfoModel.h"

@interface ZFOrderAddressCell ()<ZFInitViewProtocol>
@property (nonatomic, strong) YYAnimatedImageView   *addressIcon;
@property (nonatomic, strong) UILabel               *userNameLabel;
@property (nonatomic, strong) UILabel               *userTelLabel;
@property (nonatomic, strong) UILabel               *addressLabel;
@end

@implementation ZFOrderAddressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - Public method
+ (NSString *)queryReuseIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - ZFInitViewProtocol
- (void)zfInitView {
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.contentView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    [self.contentView addSubview:self.addressIcon];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.userTelLabel];
    [self.contentView addSubview:self.addressLabel];
    
}

- (void)zfAutoLayoutView {
    [self.addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(12);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(44);
        make.top.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(24);
    }];
    
    [self.userTelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-24);
        make.leading.equalTo(self.userNameLabel.mas_trailing).offset(12);
        make.centerY.equalTo(self.userNameLabel);
        make.height.mas_equalTo(24);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(44);
        make.top.equalTo(self.userNameLabel.mas_bottom);
        make.trailing.equalTo(self.contentView).offset(-24);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    [self.userTelLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.userTelLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - Setter
- (void)setAddressModel:(ZFAddressInfoModel *)addressModel {
    _addressModel = addressModel;
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@",addressModel.firstname,addressModel.lastname];
    self.userTelLabel.text = [NSString stringWithFormat:@"+%@ %@%@",[NSStringUtils isEmptyString:addressModel.code withReplaceString:@""],[NSStringUtils isEmptyString:addressModel.supplier_number withReplaceString:@""],addressModel.tel];
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@,\n%@ %@/%@ %@",addressModel.addressline1,addressModel.addressline2,addressModel.province,addressModel.country_str,addressModel.city,addressModel.zipcode];
}

#pragma mark - Getter
- (YYAnimatedImageView *)addressIcon {
    if (!_addressIcon) {
        _addressIcon = [YYAnimatedImageView new];
        _addressIcon.image = [UIImage imageNamed:@"address_icon"];
    }
    return _addressIcon;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:14];
        _userNameLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _userNameLabel;
}

- (UILabel *)userTelLabel {
    if (!_userTelLabel) {
        _userTelLabel = [[UILabel alloc] init];
        _userTelLabel.font = [UIFont systemFontOfSize:14];
        _userTelLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        _userTelLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _userTelLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textColor = ZFCOLOR(153, 153, 153, 1);
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.numberOfLines = 0;
        _addressLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 80;
    }
    return _addressLabel;
}

@end
