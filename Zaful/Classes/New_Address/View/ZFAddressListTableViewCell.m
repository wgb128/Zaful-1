
//
//  ZFAddressListTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressListTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressInfoModel.h"
#import "UIView+GBGesture.h"

@interface ZFAddressListTableViewCell () <ZFInitViewProtocol>

@property (nonatomic, strong) UIImageView            *selectAddressIcon;
@property (nonatomic, strong) UILabel                *nameLabel;
@property (nonatomic, strong) UILabel                *telphoneLabel;
@property (nonatomic, strong) UILabel                *addressInfoLabel;

@end

@implementation ZFAddressListTableViewCell
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        @weakify(self);
        [self addTapGestureWithComplete:^(UIView * _Nonnull view) {
            @strongify(self);
            if (self.addressEditSelectCompletionHandler) {
                self.addressEditSelectCompletionHandler(self.model);
            }
        }];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.selectAddressIcon];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.telphoneLabel];
    [self.contentView addSubview:self.addressInfoLabel];
}

- (void)zfAutoLayoutView {
    [self.selectAddressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(17.5);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@25);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.selectAddressIcon.mas_trailing).offset(17);
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
    }];
    
    [self.telphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_top);
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(30);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
    }];
    
    [self.addressInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(12);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    [self.telphoneLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.telphoneLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - setter
- (void)setModel:(ZFAddressInfoModel *)model {
    _model = model;
    self.selectAddressIcon.hidden = !model.is_default;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",model.firstname,model.lastname];
    
    if([NSStringUtils isEmptyString:model.code] && [NSStringUtils isEmptyString:model.supplier_number]) {
        self.telphoneLabel.text = [NSString stringWithFormat:@"%@",model.tel];
    } else {
        self.telphoneLabel.text = [NSString stringWithFormat:@"+%@ %@%@",[NSStringUtils isEmptyString:model.code withReplaceString:@""],[NSStringUtils isEmptyString:model.supplier_number withReplaceString:@""],model.tel];
    }
    self.addressInfoLabel.text = [NSString stringWithFormat:@"%@ %@,\n%@ %@/%@ %@",model.addressline1,model.addressline2,model.province,model.country_str,model.city,model.zipcode];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.telphoneLabel.mas_leading).offset(-10);
    }];
}

#pragma mark - getter
- (UIImageView *)selectAddressIcon {
    if (!_selectAddressIcon) {
        _selectAddressIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addressNew"]];
        _selectAddressIcon.hidden = YES;
    }
    return _selectAddressIcon;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);

    }
    return _nameLabel;
}

- (UILabel *)telphoneLabel {
    if (!_telphoneLabel) {
        _telphoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _telphoneLabel.textAlignment = NSTextAlignmentRight;
        _telphoneLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _telphoneLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _telphoneLabel;
}

- (UILabel *)addressInfoLabel {
    if (!_addressInfoLabel) {
        _addressInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addressInfoLabel.numberOfLines = 0;
        _addressInfoLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        _addressInfoLabel.font =  [UIFont systemFontOfSize:14.0];
    }
    return _addressInfoLabel;
}

@end
