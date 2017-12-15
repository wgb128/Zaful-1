//
//  ZFOrderInformationViewController.h
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"

@class ZFOrderCheckInfoModel;
@class ZFOrderCheckInfoDetailModel;

@interface ZFOrderContentViewController : ZFBaseViewController

@property (nonatomic, assign) PaymentUIType         paymentUIType;

@property (nonatomic, assign) PaymentProcessType    paymentProcessType;

@property (nonatomic, assign) PayCodeType           payCode;

@property (nonatomic, strong) ZFOrderCheckInfoDetailModel   *checkoutModel;

@property (nonatomic, strong) NSArray<ZFOrderCheckInfoModel *>   *pages;

@end
