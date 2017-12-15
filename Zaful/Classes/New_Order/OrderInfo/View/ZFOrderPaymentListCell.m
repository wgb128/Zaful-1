//
//  ZFOrderPaymentListCell.m
//  Zaful
//
//  Created by TsangFa on 18/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderPaymentListCell.h"
#import "ZFInitViewProtocol.h"
#import "PaymentListModel.h"

@interface ZFOrderPaymentListCell ()<ZFInitViewProtocol>
@property (nonatomic, strong) UIButton              *selectButton;
@property (nonatomic, strong) YYAnimatedImageView   *payImageView;
@property (nonatomic, strong) UILabel               *infoLabel;
@end

@implementation ZFOrderPaymentListCell
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
    self.contentView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.payImageView];
    [self.contentView addSubview:self.infoLabel];
}

- (void)zfAutoLayoutView {
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(12);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.payImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.selectButton.mas_trailing).offset(12);
        make.top.equalTo(self.contentView).offset(20);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.selectButton.mas_trailing).offset(13);
        make.trailing.equalTo(self.contentView).offset(-12);
        make.top.equalTo(self.payImageView.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

#pragma mark - Setter
- (void)setIsChoose:(BOOL)isChoose {
    _isChoose = isChoose;
    self.selectButton.selected = isChoose;
}

- (void)setPaymentListmodel:(PaymentListModel *)paymentListmodel {
    _paymentListmodel = paymentListmodel;
    self.infoLabel.text = paymentListmodel.pay_shuoming;
    self.payImageView.image = [UIImage imageNamed:paymentListmodel.pay_code];
}

#pragma mark - Getter
- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"order_unchoose"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"order_choose"] forState:UIControlStateSelected];
         _selectButton.userInteractionEnabled = NO;
    }
    return _selectButton;
}

- (YYAnimatedImageView *)payImageView {
    if (!_payImageView) {
        _payImageView = [YYAnimatedImageView new];
    }
    return _payImageView;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont systemFontOfSize:14];
        _infoLabel.textColor = ZFCOLOR(178, 178, 178, 1);
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}

@end
