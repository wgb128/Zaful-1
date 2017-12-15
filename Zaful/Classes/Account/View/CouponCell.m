//
//  CouponCell.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/28.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CouponCell.h"
#import "ZFInitViewProtocol.h"

@interface CouponCell () <ZFInitViewProtocol>

@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *expiresLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *percentOffBtn;

@end

@implementation CouponCell
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    [self.contentView addSubview:self.codeLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.percentOffBtn];
    [self.contentView addSubview:self.expiresLabel];
}

- (void)zfAutoLayoutView {
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(25);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.codeLabel.mas_leading);
        make.top.mas_equalTo(self.codeLabel.mas_bottom).offset(12);
    }];
    
    [self.percentOffBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(100 * DSCREEN_WIDTH_SCALE));
        make.trailing.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.expiresLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.codeLabel.mas_leading);
        make.trailing.mas_equalTo(self.percentOffBtn.mas_leading).offset(-1);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(12);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-25);
    }];
}

#pragma mark - setter
-(void)setCouponModel:(MyCouponsListModel *)couponModel{
    
    _couponModel = couponModel;
    self.nameLabel.text = couponModel.code;
#if 0
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM/dd/YYYY HH:mm:ss aa"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[couponModel.exp_time floatValue]];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
#endif
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.expiresLabel.text = [NSString stringWithFormat:@"%@ :%@",couponModel.exp_time,ZFLocalizedString(@"MyCoupon_Coupon_Cell_Expires_Date",nil)];
    } else {
        self.expiresLabel.text = [NSString stringWithFormat:@"%@: %@",ZFLocalizedString(@"MyCoupon_Coupon_Cell_Expires_Date",nil),couponModel.exp_time];
    }
    
    if ([couponModel.exp_time longLongValue] < [self.currentTime longLongValue]) {
        self.percentOffBtn.backgroundColor = ZFCOLOR(178, 178, 178, 1.0);
    }else{
        self.percentOffBtn.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
    }
    [self.percentOffBtn setTitle:couponModel.youhui forState:UIControlStateNormal];
}

#pragma mark - getter
- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.text = ZFLocalizedString(@"MyCoupon_Coupon_Cell_CouponCode",nil);
        _codeLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _codeLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _codeLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    return _nameLabel;
}

- (UIButton *)percentOffBtn {
    if (!_percentOffBtn) {
        _percentOffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _percentOffBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _percentOffBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _percentOffBtn.titleLabel.numberOfLines = 0;
        [_percentOffBtn setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        _percentOffBtn.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
        _percentOffBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    }
    return _percentOffBtn;
}

- (UILabel *)expiresLabel {
    if (!_expiresLabel) {
        _expiresLabel = [[UILabel alloc] init];
        _expiresLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        _expiresLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _expiresLabel;
}
@end
