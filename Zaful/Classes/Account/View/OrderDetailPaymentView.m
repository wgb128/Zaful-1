//
//  OrderDetailPaymentView.m
//  Zaful
//
//  Created by DBP on 17/3/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "OrderDetailPaymentView.h"

@interface OrderDetailPaymentView ()
@property (nonatomic, strong) UIButton *payNowBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@end

@implementation OrderDetailPaymentView

- (instancetype)initWithPaymentStatus:(BOOL)hidden {
    if (self = [super initWithFrame:CGRectZero]) {
        NSString *localeLanguageCode = [ZFLocalizationString shareLocalizable].nomarLocalizable;
        self.payNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.payNowBtn.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
        [self.payNowBtn setTitle:ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_PayNow",nil) forState:UIControlStateNormal];
        self.payNowBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.payNowBtn.titleLabel.contentMode = NSTextAlignmentCenter;
        self.payNowBtn.tag = OrderDetailPay;
        [self.payNowBtn setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [self.payNowBtn addTarget:self action:@selector(orderPayStateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.payNowBtn];
        [self.payNowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
            make.top.mas_equalTo(self.mas_top).offset(12);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-12);
            if ([localeLanguageCode hasPrefix:@"ar"]) {
                make.width.mas_equalTo(80);
            }
        }];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelBtn setTitle:ZFLocalizedString(@"Cancel",nil) forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.cancelBtn.tag = OrderDetailCancel;
        self.cancelBtn.hidden = hidden;
        self.cancelBtn.titleLabel.contentMode = NSTextAlignmentCenter;
        [self.cancelBtn setTitleColor:ZFCOLOR(0, 0, 0, 1.0) forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(orderPayStateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.payNowBtn.mas_leading).offset(-20);
            make.size.mas_equalTo(self.payNowBtn);
            make.centerY.mas_equalTo(self.payNowBtn.mas_centerY);
        }];
    }
    return self;
}

- (void)changeName:(NSString *)states {
    if ([states isEqualToString:@"0"]) {
        [self.payNowBtn setTitle:ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_Contiue",nil) forState:UIControlStateNormal];
    }else if ([states isEqualToString:@"1"]) {
        [self.payNowBtn setTitle:ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_Check",nil) forState:UIControlStateNormal];
    }
}

- (void)orderPayStateBtnClick:(UIButton *)sender{
    if(self.orderDetailPayStatueBlock){
        self.orderDetailPayStatueBlock(sender.tag);
    }
}



@end
