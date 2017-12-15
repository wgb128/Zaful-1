//
//  CartOrderInfoShippingInsuranceView.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/19.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CartOrderInfoShippingInsuranceCell.h"

@interface CartOrderInfoShippingInsuranceCell ()

@property (nonatomic, strong) UILabel *shippingInsuranceTitleLabel;

@property (nonatomic, strong) UILabel *shippingInsuranceLabel;

@property (nonatomic, strong) UIButton *shippingInsuranceBtn;

@end

@implementation CartOrderInfoShippingInsuranceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviewsContraint];
    }
    return self;
}

-(void)setManager:(CartCreateOrderManager *)manager{
    
    _manager = manager;
    self.shippingInsuranceLabel.text = manager.shippingInsuranceLabelText;
    
    if ([manager.insurance integerValue] == 0) {
        self.shippingInsuranceBtn.selected = NO;
    }else{
        self.shippingInsuranceBtn.selected = YES;
    }
}


+ (CartOrderInfoShippingInsuranceCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartOrderInfoShippingInsuranceCell class] forCellReuseIdentifier:ORDERINFO_SHIPPINGINSURANCE_IDENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:ORDERINFO_SHIPPINGINSURANCE_IDENTIFIER forIndexPath:indexPath];
}

- (void)addSubviewsContraint
{
    
    [self addSubview:self.shippingInsuranceBtn];
    [self.shippingInsuranceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(5);
        make.size.equalTo(@30);
        make.top.offset(25);
    }];
    
    [self addSubview:self.shippingInsuranceTitleLabel];
    [self.shippingInsuranceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shippingInsuranceBtn.mas_trailing).offset(5);
        make.centerY.equalTo(self.shippingInsuranceBtn);
        make.bottom.offset(-25);
    }];
    
    [self addSubview:self.shippingInsuranceLabel];
    [self.shippingInsuranceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shippingInsuranceTitleLabel.mas_trailing).offset(5);
        make.centerY.equalTo(self.shippingInsuranceBtn);
    }];
}

-(UILabel *)shippingInsuranceTitleLabel{
    if (!_shippingInsuranceTitleLabel) {
        _shippingInsuranceTitleLabel = [[UILabel alloc] init];
        _shippingInsuranceTitleLabel.text = ZFLocalizedString(@"CartOrderInfo_ShippingInsuranceCell_Cell_ShippingInsurance",nil);
        _shippingInsuranceTitleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _shippingInsuranceTitleLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
    }
    return _shippingInsuranceTitleLabel;
}

-(UILabel *)shippingInsuranceLabel{
    if (!_shippingInsuranceLabel) {
        _shippingInsuranceLabel = [[UILabel alloc] init];
        _shippingInsuranceLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _shippingInsuranceLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
    }
    return _shippingInsuranceLabel;
}

- (void)shippingInsuranceBtnClick:(UIButton *)sender
{
    if (self.insuranceSelectBlock) {
        sender.selected = !sender.selected;
        self.insuranceSelectBlock(sender.selected);
    }
}

-(UIButton *)shippingInsuranceBtn{
    if (!_shippingInsuranceBtn) {
        _shippingInsuranceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shippingInsuranceBtn setImage:[UIImage imageNamed:@"default_no"] forState:UIControlStateNormal];
        [_shippingInsuranceBtn setImage:[UIImage imageNamed:@"default_ok"] forState:UIControlStateSelected];
        _shippingInsuranceBtn.selected = YES;
        [_shippingInsuranceBtn addTarget:self action:@selector(shippingInsuranceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shippingInsuranceBtn;
}

@end
