//
//  ZFCouponWarningView.m
//  Zaful
//
//  Created by QianHan on 2017/12/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCouponWarningView.h"
#import "ZFInitViewProtocol.h"

@interface ZFCouponWarningView() <ZFInitViewProtocol>

@property (nonatomic, strong) UIView  *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ZFCouponWarningView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = ZFCOLOR(244, 239, 221, 1.0);
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - ZFInitViewProtocol
- (void)zfInitView {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
}

- (void)zfAutoLayoutView {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.leading.mas_equalTo(self.contentView.mas_leading);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.leading.mas_equalTo(self.titleLabel.mas_trailing).offset(5.0f);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
    }];
}

#pragma mark - getter/setter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = ZFCOLOR(128.0, 128.0, 128.0, 1.0);
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.text = ZFLocalizedString(@"MyCoupon_Coupon_Warning_Title", nil);
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = ZFCOLOR(255.0, 168, 0, 1.0);
        _contentLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _contentLabel;
}

- (void)setCouponAmount:(NSString *)couponAmount {
    _couponAmount = couponAmount;
    self.contentLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"MyCoupon_Coupon_Warning_Content", nil), [ExchangeManager transforPrice:couponAmount]] ;
    
}

@end
