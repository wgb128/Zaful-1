//
//  ZFOrderInfoViewController.h
//  Zaful
//
//  Created by TsangFa on 13/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"

@class ZFOrderCheckInfoDetailModel;
@class ZFOrderManager;

@interface ZFOrderInfoViewController : ZFBaseViewController

@property (nonatomic, strong) ZFOrderManager                *manager;

@property (nonatomic, strong) ZFOrderCheckInfoDetailModel   *checkOutModel;

@property (nonatomic, assign) PaymentUIType                 paymentUIType;

@property (nonatomic, assign) PayCodeType                   payCode;


@end
