

//
//  ZFPaymentStatusTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPaymentStatusTableViewCell.h"
#import "ZFInitViewProtocol.h"

@interface ZFPaymentStatusTableViewCell() <ZFInitViewProtocol>

@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) UIImageView       *statusImageView;
@property (nonatomic, strong) UIView            *containerView;
@property (nonatomic, strong) UILabel           *statusLabel;
@property (nonatomic, strong) UILabel           *payTypeLabel;
@property (nonatomic, strong) UILabel           *orderSnLabel;
@property (nonatomic, strong) UILabel           *priceLabel;

@end

@implementation ZFPaymentStatusTableViewCell
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR(237, 237, 237, 1.f);
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.statusImageView];
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.statusLabel];
    [self.containerView addSubview:self.payTypeLabel];
    [self.containerView addSubview:self.orderSnLabel];
    [self.containerView addSubview:self.priceLabel];
}

- (void)zfAutoLayoutView {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.orderSnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
}

#pragma mark - setter
- (void)setStatusType:(ZFPaymentStatusType)statusType {
    _statusType = statusType;
    
}

#pragma mark - getter
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}

- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _statusImageView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = ZFCOLOR_WHITE;
    }
    return _containerView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = [UIFont boldSystemFontOfSize:16];
        _statusLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        
    }
    return _statusLabel;
}

- (UILabel *)payTypeLabel {
    if (!_payTypeLabel) {
        _payTypeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _payTypeLabel.font = [UIFont systemFontOfSize:14];
        _payTypeLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        
    }
    return _payTypeLabel;
}

- (UILabel *)orderSnLabel {
    if (!_orderSnLabel) {
        _orderSnLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _orderSnLabel.font = [UIFont systemFontOfSize:14];
        _orderSnLabel.textColor = ZFCOLOR(51, 51, 51, 1);
    }
    return _orderSnLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.textColor = ZFCOLOR(51, 51, 51, 1);
    }
    return _priceLabel;
}

@end
