//
//  ZFAddressEditCountryTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressEditCountryTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressInfoModel.h"

@interface ZFAddressEditCountryTableViewCell () <ZFInitViewProtocol>
@property (nonatomic, strong) UILabel           *countryLabel;
@property (nonatomic, strong) UILabel           *countryInfoLabel;
@property (nonatomic, strong) UIImageView       *arrowView;
@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) UIImageView       *tipsImageView;
@property (nonatomic, strong) UILabel           *tipsLabel;
@end

@implementation ZFAddressEditCountryTableViewCell
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - private methods
- (void)errorEnterTipsLayout {
    self.lineView.backgroundColor = ZFCOLOR(255, 168, 0, 1.f);
    self.countryLabel.textColor = ZFCOLOR(255, 168, 0, 1.f);
    [self.contentView addSubview:self.tipsImageView];
    [self.contentView addSubview:self.tipsLabel];
    self.tipsImageView.hidden = NO;
    self.tipsLabel.hidden = NO;
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.countryLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.countryLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.lineView);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.tipsImageView.mas_trailing).offset(4);
        make.centerY.mas_equalTo(self.tipsImageView.mas_centerY);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-4);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
    }];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.countryLabel];
    [self.contentView addSubview:self.countryInfoLabel];
    [self.contentView addSubview:self.arrowView];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.countryInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.countryLabel.mas_trailing).offset(12);
        make.centerY.mas_equalTo(self.countryLabel);
        make.trailing.mas_equalTo(self.arrowView.mas_leading).offset(-16);
        make.height.mas_equalTo(30);
    }];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.countryLabel);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.countryLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
    }];
}

#pragma mark - setter
- (void)setModel:(ZFAddressInfoModel *)model {
    _model = model;
    self.countryInfoLabel.text = _model.country_str;
    
    if ([NSStringUtils isEmptyString:self.model.country_str]) {
        return ;
    }
    [self.countryLabel setContentHuggingPriority:UILayoutPriorityRequired
                                         forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.countryLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                       forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setIsContinueCheck:(BOOL)isContinueCheck {
    _isContinueCheck = isContinueCheck;
    if (_isContinueCheck) {
        BOOL isOk = YES;
        if([self.countryInfoLabel.text length] == 0){
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_Country_TipLabel",nil);
            isOk = NO;
        }
        if (!isOk) {
            [self errorEnterTipsLayout];
        } else {
            [self.tipsImageView removeFromSuperview];
            [self.tipsLabel removeFromSuperview];
        }
    } else {
        if (![NSStringUtils isEmptyString:self.model.country_str]) {
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            self.countryLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            [self.tipsImageView removeFromSuperview];
            [self.tipsLabel removeFromSuperview];
        }
    }
}

#pragma mark - getter
- (UILabel *)countryLabel {
    if (!_countryLabel) {
        _countryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countryLabel.font = [UIFont systemFontOfSize:14];
        _countryLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _countryLabel.text = ZFLocalizedString(@"ModifyAddress_Country_Placeholder", nil);
    }
    return _countryLabel;
}

- (UILabel *)countryInfoLabel {
    if (!_countryInfoLabel) {
        _countryInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countryInfoLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _countryInfoLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _countryInfoLabel;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowView.image = [UIImage imageNamed:![SystemConfigUtils isRightToLeftShow] ? @"account_arrow_right" : @"account_arrow_left"];
    }
    return _arrowView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}

- (UIImageView *)tipsImageView {
    if (!_tipsImageView) {
        _tipsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"!"]];
    }
    return _tipsImageView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.textColor = ZFCOLOR(255, 168, 0, 1.f);
        _tipsLabel.font = [UIFont systemFontOfSize:12];
    }
    return _tipsLabel;
}
@end
