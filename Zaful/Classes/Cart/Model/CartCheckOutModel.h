//
//  CartCheckOutModel.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/6.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFAddressInfoModel.h"
#import "PaymentListModel.h"
#import "PointModel.h"
#import "CartCheckOutTotalModel.h"
#import "CartGoodsModel.h"
#import "CartCodModel.h"
#import "ZFOrderInfoFooterModel.h"

@interface CartCheckOutModel : NSObject

@property (nonatomic, strong) CartCodModel   *cod;

@property (nonatomic, strong) ZFAddressInfoModel *address_info;

@property (nonatomic, strong) CartGoodsModel *cart_goods;

@property (nonatomic, copy) NSString *default_shipping_id;

@property (nonatomic, copy) NSString *notice_msg;

@property (nonatomic, strong) NSArray *payment_list;

@property (nonatomic, strong) PointModel *point;

@property (nonatomic, strong) NSArray *shipping_list;

@property (nonatomic, strong) CartCheckOutTotalModel *total;

@property (nonatomic, strong) ZFOrderInfoFooterModel   *footer;

@property (nonatomic,assign) BOOL ifNeedInsurance; // 是否需要保险

/************************下面参数用于快速支付***************************/
@property (nonatomic,copy) NSString *payertoken;
@property (nonatomic,copy) NSString *payerId;
@end
