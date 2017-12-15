//
//  ZFOrderCheckInfoDetailModel.h
//  Zaful
//
//  Created by TsangFa on 26/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PaymentListModel.h"
#import "ShippingListModel.h"
#import "CartCodModel.h"
#import "ZFAddressInfoModel.h"
#import "CartGoodsModel.h"
#import "PointModel.h"
#import "CartCheckOutTotalModel.h"
#import "ZFOrderInfoFooterModel.h"
#import "CheckOutGoodListModel.h"
#import "ZFOrderCouponModel.h"
#import "ZFMyCouponModel.h"

@interface ZFOrderCheckInfoDetailModel : NSObject

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

@property (nonatomic, strong) ZFOrderCouponModel *coupon_list;

/************************下面参数用于快速支付***************************/
@property (nonatomic,copy) NSString *payertoken;
@property (nonatomic,copy) NSString *payerId;

@end

