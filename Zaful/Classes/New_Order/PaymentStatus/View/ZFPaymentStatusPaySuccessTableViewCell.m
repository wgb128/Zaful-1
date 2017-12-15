

//
//  ZFPaymentStatusPaySuccessTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPaymentStatusPaySuccessTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFOrderCheckDoneDetailModel.h"
#import "FilterManager.h"

@interface ZFPaymentStatusPaySuccessTableViewCell() <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView           *statusImageView;
@property (nonatomic, strong) UIView                *containerView;
@property (nonatomic, strong) UILabel               *payMethodsLabel;
@property (nonatomic, strong) UIImageView           *lineView;
@property (nonatomic, strong) UILabel               *statusLabel;
@property (nonatomic, strong) UILabel               *orderLabel;
@property (nonatomic, strong) UILabel               *priceLabel;

@end

@implementation ZFPaymentStatusPaySuccessTableViewCell
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
    self.contentView.backgroundColor = ZFCOLOR(241, 241, 241, 1.f);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.containerView];
    [self.contentView addSubview:self.statusImageView];
    [self.containerView addSubview:self.payMethodsLabel];
    [self.containerView addSubview:self.lineView];
    [self.containerView addSubview:self.statusLabel];
    [self.containerView addSubview:self.orderLabel];
    [self.containerView addSubview:self.priceLabel];
}

- (void)zfAutoLayoutView {
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(40, 16, 0, 16));
    }];
    
    [self.payMethodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusImageView.mas_bottom).offset(4);
        make.centerX.mas_equalTo(self.containerView);
        make.height.mas_equalTo(24);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.containerView.mas_leading).offset(28);
        make.trailing.mas_equalTo(self.containerView.mas_trailing).offset(-28);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.payMethodsLabel.mas_bottom).offset(4);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(4);
        make.height.mas_equalTo(32);
        make.leading.trailing.mas_equalTo(self.lineView);
    }];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLabel.mas_bottom);
        make.height.mas_equalTo(20);
        make.leading.trailing.mas_equalTo(self.lineView);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderLabel.mas_bottom);
        make.height.mas_equalTo(20);
        make.leading.trailing.mas_equalTo(self.lineView);
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-20);
    }];
}

#pragma mark - setter
- (void)setModel:(ZFOrderCheckDoneDetailModel *)model {
    _model = model;
    self.payMethodsLabel.text = model.payName;
    self.orderLabel.text = model.order_sn;
    if ([model.payName isEqualToString:@"Online Payment"]) {
        self.priceLabel.text = [ExchangeManager transforPrice:model.order_amount];
    }else{
        // 这里cod取整逻辑在后台处理了,直接取值显示
        self.priceLabel.text = [FilterManager changeCodCurrencyToFront:model.multi_order_amount];
    }
}

#pragma mark - getter
- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _statusImageView.image = [UIImage imageNamed:@"combineSuccess"];
        _statusImageView.layer.cornerRadius = 24;
        _statusImageView.layer.masksToBounds = YES;
        [_statusImageView showCurrentViewBorder:0.5 color:ZFCOLOR(211, 211, 211, 1)];
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

- (UILabel *)payMethodsLabel {
    if (!_payMethodsLabel) {
        _payMethodsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _payMethodsLabel.textAlignment = NSTextAlignmentCenter;
        _payMethodsLabel.font = [UIFont systemFontOfSize:14];
        _payMethodsLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
    }
    return _payMethodsLabel;
}

- (UIImageView *)lineView {
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(153, 153, 153, 1.f);
        _lineView.image = [UIImage imageNamed:@"dottedLine"];
    }
    return _lineView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = [UIFont boldSystemFontOfSize:16];
        _statusLabel.text = ZFLocalizedString(@"ZFPayStateSuccess", nil);
        _statusLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
    }
    return _statusLabel;
}

- (UILabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _orderLabel.font = [UIFont systemFontOfSize:14];
        _orderLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
    }
    return _orderLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
    }
    return _priceLabel;
}


@end
