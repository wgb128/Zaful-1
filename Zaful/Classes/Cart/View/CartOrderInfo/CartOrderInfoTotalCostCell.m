//
//  CartOrderInfoTotalCostCell.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CartOrderInfoTotalCostCell.h"

@interface CartOrderInfoTotalCostCell ()

@property (nonatomic, strong) UILabel *subTotalLabel;

@property (nonatomic, strong) UILabel *subTotalSumLabel;

@property (nonatomic, strong) UILabel *rewardSaveLabel;

@property (nonatomic, strong) UILabel *rewardSaveSumLabel;

@property (nonatomic, strong) UILabel *codeSaveLabel;

@property (nonatomic, strong) UILabel *codeSaveSumLabel;

@property (nonatomic, strong) UILabel *costLabel;

@property (nonatomic, strong) UILabel *costSumLabel;

@property (nonatomic, strong) UILabel *insuranceLabel;

@property (nonatomic, strong) UILabel *insuranceSumLabel;

@property (nonatomic, strong) UIView *hLineViewOne;

@property (nonatomic, strong) UILabel *grandTotalLabel;

@property (nonatomic, strong) UILabel *grandTotalSumLabel;

@end

@implementation CartOrderInfoTotalCostCell

+ (CartOrderInfoTotalCostCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartOrderInfoTotalCostCell class] forCellReuseIdentifier:ORDERINFO_TOTALCOST_IDENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:ORDERINFO_TOTALCOST_IDENTIFIER forIndexPath:indexPath];
}

- (void)refreshDataWithTotalModel:(CartCheckOutTotalModel *)totalModel manager:(CartCreateOrderManager *)manager
{
    self.subTotalSumLabel.text = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:totalModel.goods_price]];

    if ([SystemConfigUtils isRightToLeftShow]) {
        self.rewardSaveSumLabel.text = [NSString stringWithFormat:@"%@-",[ExchangeManager transforPrice:manager.pointSavePrice]];
        
        self.codeSaveSumLabel.text = [NSString stringWithFormat:@"%@-",[ExchangeManager transforPrice:manager.couponAmount]];//优惠券
    } else {
        self.rewardSaveSumLabel.text = [NSString stringWithFormat:@"-%@",[ExchangeManager transforPrice:manager.pointSavePrice]];
        
        self.codeSaveSumLabel.text = [NSString stringWithFormat:@"-%@",[ExchangeManager transforPrice:manager.couponAmount]];//优惠券
    }
    
    self.costSumLabel.text = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:manager.shippingCost]];
    
    self.insuranceSumLabel.text = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:manager.insurance]];
    
    CGFloat num = [totalModel.goods_price floatValue] + [manager.shippingCost floatValue] + [manager.insurance floatValue] - [manager.couponAmount floatValue] - [manager.pointSavePrice floatValue];
    
    self.grandTotalSumLabel.text = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:[NSString stringWithFormat:@"%lf",num]]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.subTotalLabel];
        [self.subTotalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15);
            make.leading.offset(12);
        }];
        
        [self.contentView addSubview:self.subTotalSumLabel];
        [self.subTotalSumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.subTotalLabel);
            make.trailing.offset(-12);
        }];

        [self.contentView addSubview:self.rewardSaveLabel];
        [self.rewardSaveLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subTotalLabel.mas_bottom).offset(10);
            make.leading.offset(12);
        }];
        
        [self.contentView addSubview:self.rewardSaveSumLabel];
        [self.rewardSaveSumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.rewardSaveLabel);
            make.trailing.offset(-12);
        }];
        

        [self.contentView addSubview:self.codeSaveLabel];
        [self.codeSaveLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rewardSaveLabel.mas_bottom).offset(10);
            make.leading.offset(12);
        }];
        
        [self.contentView addSubview:self.codeSaveSumLabel];
        [self.codeSaveSumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.codeSaveLabel);
            make.trailing.offset(-12);
        }];

        [self.contentView addSubview:self.costLabel];
        [self.costLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.codeSaveSumLabel.mas_bottom).offset(10);
            make.leading.offset(12);
        }];
        
        [self.contentView addSubview:self.costSumLabel];
        [self.costSumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.costLabel);
            make.trailing.offset(-12);
        }];
        
        [self.contentView addSubview:self.insuranceLabel];
        [self.insuranceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.costLabel.mas_bottom).offset(10);
            make.leading.offset(12);
        }];
        
        [self.contentView addSubview:self.insuranceSumLabel];
        [self.insuranceSumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.insuranceLabel);
            make.trailing.offset(-12);
        }];
        
        [self.contentView addSubview:self.hLineViewOne];
        [self.hLineViewOne mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.insuranceLabel.mas_bottom).offset(10);
            make.leading.trailing.offset(0);
            make.height.equalTo(@(MIN_PIXEL));
        }];
        
        [self.contentView addSubview:self.grandTotalLabel];
        [self.grandTotalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hLineViewOne.mas_bottom).offset(1);
            make.leading.offset(10);
            make.height.equalTo(@48);
            make.bottom.offset(0);
        }];
        
        [self.contentView addSubview:self.grandTotalSumLabel];
        [self.grandTotalSumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.grandTotalLabel);
            make.height.equalTo(self.grandTotalLabel);
            make.trailing.offset(-10);
        }];
        
    }
    return self;
}

-(UILabel *)subTotalLabel{
    if (!_subTotalLabel) {
        _subTotalLabel = [[UILabel alloc] init];
        _subTotalLabel.backgroundColor = [UIColor whiteColor];
        _subTotalLabel.text = ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_Subtotal",nil);
        _subTotalLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        _subTotalLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return  _subTotalLabel;
}

-(UILabel *)subTotalSumLabel{
    if (!_subTotalSumLabel) {
        _subTotalSumLabel = [[UILabel alloc] init];
        _subTotalSumLabel.backgroundColor = [UIColor whiteColor];
        _subTotalSumLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _subTotalSumLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _subTotalSumLabel;
}

-(UILabel *)rewardSaveLabel{
    if (!_rewardSaveLabel) {
        _rewardSaveLabel = [[UILabel alloc] init];
        _rewardSaveLabel.backgroundColor = [UIColor whiteColor];
        _rewardSaveLabel.text = ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_RewardsSaving",nil);
        _rewardSaveLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        _rewardSaveLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return  _rewardSaveLabel;
}

-(UILabel *)rewardSaveSumLabel{
    if (!_rewardSaveSumLabel) {
        _rewardSaveSumLabel = [[UILabel alloc] init];
        _rewardSaveSumLabel.backgroundColor = [UIColor whiteColor];
        _rewardSaveSumLabel.textColor = ZFCOLOR(244, 67, 69, 1.0);
        _rewardSaveSumLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _rewardSaveSumLabel;
}

-(UILabel *)codeSaveLabel{
    if (!_codeSaveLabel) {
        _codeSaveLabel = [[UILabel alloc] init];
        _codeSaveLabel.backgroundColor = [UIColor whiteColor];
        _codeSaveLabel.text = ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_PromotionCodeSaving",nil);
        _codeSaveLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        _codeSaveLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return  _codeSaveLabel;
}

-(UILabel *)codeSaveSumLabel{
    if (!_codeSaveSumLabel) {
        _codeSaveSumLabel = [[UILabel alloc] init];
        _codeSaveSumLabel.backgroundColor = [UIColor whiteColor];
        _codeSaveSumLabel.text = ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_PromotionCodeSaving",nil);
        _codeSaveSumLabel.textColor = ZFCOLOR(244, 67, 69, 1.0);
        _codeSaveSumLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _codeSaveSumLabel;
}

-(UILabel *)costLabel{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.backgroundColor = [UIColor whiteColor];
        _costLabel.text = ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_ShippingCost",nil);
        _costLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        _costLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return  _costLabel;
}

-(UILabel *)costSumLabel{
    if (!_costSumLabel) {
        _costSumLabel = [[UILabel alloc] init];
        _costSumLabel.backgroundColor = [UIColor whiteColor];
        _costSumLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _costSumLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _costSumLabel;
}

-(UILabel *)insuranceLabel{
    if (!_insuranceLabel) {
        _insuranceLabel = [[UILabel alloc] init];
        _insuranceLabel.backgroundColor = [UIColor whiteColor];
        _insuranceLabel.text = ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_ShippingInsurance",nil);
        _insuranceLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        _insuranceLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return  _insuranceLabel;
}

-(UILabel *)insuranceSumLabel{
    if (!_insuranceSumLabel) {
        _insuranceSumLabel = [[UILabel alloc] init];
        _insuranceSumLabel.backgroundColor = [UIColor whiteColor];
        _insuranceSumLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _insuranceSumLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _insuranceSumLabel;
}

-(UIView *)hLineViewOne{
    if (!_hLineViewOne) {
        _hLineViewOne = [[UIView alloc] init];
        _hLineViewOne.backgroundColor = ZFCOLOR(178, 178, 178, 1.0);
    }
    return _hLineViewOne;
}

-(UILabel *)grandTotalLabel{
    if (!_grandTotalLabel) {
        _grandTotalLabel = [[UILabel alloc] init];
        _grandTotalLabel.backgroundColor = [UIColor whiteColor];
        _grandTotalLabel.text = ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_GrandTotal",nil);
        _grandTotalLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        _grandTotalLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return  _grandTotalLabel;
}

-(UILabel *)grandTotalSumLabel{
    if (!_grandTotalSumLabel) {
        _grandTotalSumLabel = [[UILabel alloc] init];
        _grandTotalSumLabel.backgroundColor = [UIColor whiteColor];
        _grandTotalSumLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _grandTotalSumLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _grandTotalSumLabel;
}

@end
