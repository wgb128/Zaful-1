//
//  ZFOrderCouponCell.m
//  Zaful
//
//  Created by TsangFa on 20/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderCouponCell.h"
#import "ZFInitViewProtocol.h"
#import "FilterManager.h"

@interface ZFOrderCouponCell ()<ZFInitViewProtocol>
@property (nonatomic, strong) YYAnimatedImageView   *icon;
@property (nonatomic, strong) UILabel               *infoLabel;
@property (nonatomic, strong) UILabel               *amountLabel;
@end

@implementation ZFOrderCouponCell
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
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.amountLabel];
}

- (void)zfAutoLayoutView {
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(12);
        make.size.mas_equalTo(CGSizeMake(20, 15));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.icon.mas_trailing).offset(12);
        make.centerY.equalTo(self.icon);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.icon);
    }];
}

#pragma mark - Setter
- (void)setCouponAmount:(NSString *)couponAmount {
    _couponAmount = couponAmount;
    self.amountLabel.text = [FilterManager adapterCodWithAmount:couponAmount andCod:self.isCod];
}

- (void)initCouponAmount:(NSString *)couponAmount {
    _couponAmount = couponAmount;
    self.amountLabel.text = couponAmount;
}

#pragma mark - Getter
- (YYAnimatedImageView *)icon {
    if (!_icon) {
        _icon = [YYAnimatedImageView new];
        _icon.image = [UIImage imageNamed:@"coupon"];
    }
    return _icon;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont boldSystemFontOfSize:14];
        _infoLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        _infoLabel.text = ZFLocalizedString(@"CartOrderInfo_PromotionCodeCell_PromotionCodeLabel",nil);
        [_infoLabel sizeToFit];
    }
    return _infoLabel;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont systemFontOfSize:14];
        _amountLabel.textColor = ZFCOLOR(183, 96, 42, 1);
    }
    return _amountLabel;
}

@end
