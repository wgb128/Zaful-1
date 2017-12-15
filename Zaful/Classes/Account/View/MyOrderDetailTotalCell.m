//
//  MyOrderDetailTotalCell.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/13.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "MyOrderDetailTotalCell.h"

@interface MyOrderDetailTotalCell ()

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

@property (nonatomic, strong) UIView *bottomView; //是否有Paynow和Cancel 按钮

@property (nonatomic, strong) UIButton *payNowBtn;

@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation MyOrderDetailTotalCell



-(void)setOrderModel:(MyOrderDetailOrderModel *)orderModel{
    
    _orderModel = orderModel;
    
    if (orderModel == nil) return ;
    
    CGFloat subTotalPrice = 0.00;
    
    for (NSInteger i = 0; i < self.goodsArray.count; i++) {
        
        MyOrderDetailGoodModel *model = self.goodsArray[i];
        
        subTotalPrice += [model.goods_number floatValue] * [model.goods_price floatValue];
    }
    
    self.subTotalSumLabel.text = [NSString stringWithFormat:@"%@%@",orderModel.order_currency,[NSString stringWithFormat:@"%.2f",subTotalPrice]];
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.rewardSaveSumLabel.text = [NSString stringWithFormat:@"%@%@-",orderModel.order_currency,orderModel.point_money];
        
        self.codeSaveSumLabel.text = [NSString stringWithFormat:@"%@%@-",orderModel.order_currency,orderModel.coupon];
    } else {
        self.rewardSaveSumLabel.text = [NSString stringWithFormat:@"-%@%@",orderModel.order_currency,orderModel.point_money];
        
        self.codeSaveSumLabel.text = [NSString stringWithFormat:@"-%@%@",orderModel.order_currency,orderModel.coupon];
    }
    
    
    self.costSumLabel.text = [NSString stringWithFormat:@"%@%@",orderModel.order_currency,orderModel.shipping_fee];
    
    self.insuranceSumLabel.text = [NSString stringWithFormat:@"%@%@",orderModel.order_currency,orderModel.insure_fee];
    
    self.grandTotalSumLabel.text = [NSString stringWithFormat:@"%@%@",orderModel.order_currency,orderModel.order_amount];

    

    if ([orderModel.order_status integerValue] != 0 && [orderModel.order_status integerValue] != 8) {
        
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        self.bottomView.hidden = YES;
    }else{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
        }];
        self.bottomView.hidden = NO;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        kContentView;

        [wc addSubview:self.subTotalLabel];
        [self.subTotalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(25);
            make.leading.offset(12);
        }];
        
        [wc addSubview:self.subTotalSumLabel];
        [self.subTotalSumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.subTotalLabel);
            make.trailing.offset(-12);
        }];

        [wc addSubview:self.rewardSaveLabel];
        [self.rewardSaveLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subTotalLabel.mas_bottom).offset(10);
            make.leading.offset(12);
        }];

        [wc addSubview:self.rewardSaveSumLabel];
        [self.rewardSaveSumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.rewardSaveLabel);
            make.trailing.offset(-12);
        }];
        
        [wc addSubview:self.codeSaveLabel];
        [self.codeSaveLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rewardSaveLabel.mas_bottom).offset(10);
            make.leading.offset(12);
        }];
        
        [wc addSubview:self.codeSaveSumLabel];
        [self.codeSaveSumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.codeSaveLabel);
            make.trailing.offset(-12);
        }];

        [wc addSubview:self.costLabel];
        [self.costLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.codeSaveSumLabel.mas_bottom).offset(10);
            make.leading.offset(12);
        }];

        [wc addSubview:self.costSumLabel];
        [self.costSumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.costLabel);
            make.trailing.offset(-12);
        }];
        
        [wc addSubview:self.insuranceLabel];
        [self.insuranceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.costLabel.mas_bottom).offset(10);
            make.leading.offset(12);
        }];
        
        [wc addSubview:self.insuranceSumLabel];
        [self.insuranceSumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.insuranceLabel);
            make.trailing.offset(-12);
        }];
        
        [wc addSubview:self.hLineViewOne];
        [self.hLineViewOne mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.insuranceLabel.mas_bottom).offset(10);
            make.leading.trailing.offset(0);
            make.height.equalTo(@(MIN_PIXEL));
        }];
        
        [wc addSubview:self.grandTotalLabel];
        [self.grandTotalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hLineViewOne.mas_bottom).offset(1);
            make.leading.offset(10);
            make.height.equalTo(@48);
        }];
        
        [wc addSubview:self.grandTotalSumLabel];
        [self.grandTotalSumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.grandTotalLabel);
            make.height.equalTo(self.grandTotalLabel);
            make.trailing.offset(-10);
        }];
        /**
         *  默认让PayPal 按钮的View 隐藏 不然针对Cancelled的订单,push时效果看起来会有Paypal的BottomView显示
         */
        
        [wc addSubview:self.bottomView];
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.grandTotalLabel.mas_bottom).offset(0);
            make.leading.trailing.offset(0);
            make.height.equalTo(@60);
            make.bottom.offset(0);
        }];
        
        [self.bottomView addSubview:self.payNowBtn];
        [self.payNowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.bottomView.mas_trailing).offset(-12);
            make.centerY.equalTo(self.bottomView);
            make.height.equalTo(@35);
            make.width.equalTo(@100);
        }];
        
        [self.bottomView addSubview:self.cancelBtn];
        [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.payNowBtn.mas_leading).offset(-20);
            make.size.equalTo(self.payNowBtn);
            make.centerY.equalTo(self.payNowBtn);
        }];
    }
    return self;
}

-(UILabel *)subTotalLabel{
    if (!_subTotalLabel) {
        _subTotalLabel = [[UILabel alloc] init];
        _subTotalLabel.backgroundColor = [UIColor whiteColor];
        _subTotalLabel.text = ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_Subtotal",nil);
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
        _rewardSaveLabel.text = ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_RewardsSaving",nil);
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
        if ([SystemConfigUtils isRightToLeftShow]) {
            _rewardSaveSumLabel.text = @"$0.00-";
        } else {
            _rewardSaveSumLabel.text = @"-$0.00";
        }
        
    }
    return _rewardSaveSumLabel;
}

-(UILabel *)codeSaveLabel{
    if (!_codeSaveLabel) {
        _codeSaveLabel = [[UILabel alloc] init];
        _codeSaveLabel.backgroundColor = [UIColor whiteColor];
        _codeSaveLabel.text = ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_PromotionCodeSaving",nil);
        _codeSaveLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        _codeSaveLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return  _codeSaveLabel;
}

-(UILabel *)codeSaveSumLabel{
    if (!_codeSaveSumLabel) {
        _codeSaveSumLabel = [[UILabel alloc] init];
        _codeSaveSumLabel.backgroundColor = [UIColor whiteColor];
        if ([SystemConfigUtils isRightToLeftShow]) {
            _codeSaveSumLabel.text = @"$0.00-";
        } else {
            _codeSaveSumLabel.text = @"-$0.00";
        }
        _codeSaveSumLabel.textColor = ZFCOLOR(244, 67, 69, 1.0);
        _codeSaveSumLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _codeSaveSumLabel;
}

-(UILabel *)costLabel{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.backgroundColor = [UIColor whiteColor];
        _costLabel.text = ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_ShippingCost",nil);
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
        _insuranceLabel.text = ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_ShippingInsurance",nil);
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
        _hLineViewOne.backgroundColor = ZFCOLOR(221, 221, 221, 1.0);
    }
    return _hLineViewOne;
}

-(UILabel *)grandTotalLabel{
    if (!_grandTotalLabel) {
        _grandTotalLabel = [[UILabel alloc] init];
        _grandTotalLabel.backgroundColor = [UIColor whiteColor];
        _grandTotalLabel.text = ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_GrandTotal",nil);
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


-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

-(UIButton *)payNowBtn{
    if (!_payNowBtn) {
        _payNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payNowBtn.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
        [_payNowBtn setTitle:ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_PayNow",nil) forState:UIControlStateNormal];
        _payNowBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_payNowBtn setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [_payNowBtn addTarget:self action:@selector(payNowBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payNowBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:ZFLocalizedString(@"Cancel",nil) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_cancelBtn setTitleColor:ZFCOLOR(0, 0, 0, 1.0) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

 - (void)payNowBtnClick
{
    if (self.payNowBlock) {
        self.payNowBlock();
    }
}

- (void)cancelBtnClick
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}


@end
