//
//  ZFOrderInsuranceCell.m
//  Zaful
//
//  Created by TsangFa on 19/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderInsuranceCell.h"
#import "ZFInitViewProtocol.h"
#import "FilterManager.h"

@interface ZFOrderInsuranceCell ()<ZFInitViewProtocol>
@property (nonatomic, strong) UIButton      *selectButton;
@property (nonatomic, strong) UILabel       *infoLabel;
@property (nonatomic, strong) UILabel       *amountLabel;
@end

@implementation ZFOrderInsuranceCell
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
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.amountLabel];
}

- (void)zfAutoLayoutView {
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.contentView).offset(12);
        make.bottom.equalTo(self.contentView).offset(-12);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.selectButton.mas_trailing).offset(12);
        make.centerY.equalTo(self.selectButton);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.infoLabel.mas_trailing).offset(5);
        make.centerY.equalTo(self.infoLabel);
    }];
}

#pragma mark - Setter
- (void)setIsChoose:(BOOL)isChoose {
    _isChoose = isChoose;
    self.selectButton.selected = isChoose;
}

- (void)setInsuranceFee:(NSString *)insuranceFee {
    _insuranceFee = insuranceFee;
    self.amountLabel.text = [FilterManager adapterCodWithAmount:insuranceFee andCod:self.isCod];
}

#pragma mark - Getter
- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"default_no"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"default_ok"] forState:UIControlStateSelected];
        _selectButton.userInteractionEnabled = NO;
    }
    return _selectButton;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont systemFontOfSize:14];
        _infoLabel.text = ZFLocalizedString(@"CartOrderInfo_ShippingInsuranceCell_Cell_ShippingInsurance",nil);
        _infoLabel.textColor = ZFCOLOR(51, 51, 51, 1);
    }
    return _infoLabel;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont boldSystemFontOfSize:14];
        _amountLabel.textColor = ZFCOLOR(51, 51, 51, 1);
    }
    return _amountLabel;
}

@end
