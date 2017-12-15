//
//  ZFOrderManager.h
//  Zaful
//
//  Created by TsangFa on 27/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZFOrderCheckInfoDetailModel;
@class ZFOrderCheckDoneDetailModel;

@interface ZFOrderManager : NSObject

@property (nonatomic, copy) NSString *couponCode; // 优惠码

@property (nonatomic, copy) NSString *addressId;// 地址id

@property (nonatomic, copy) NSString *shippingId; // 物流id

@property (nonatomic, copy) NSString *need_traking_number;

@property (nonatomic, copy) NSString *insurance; // 物流保险费

@property (nonatomic, copy) NSString *currentPoint; // 目前使用积分

@property (nonatomic, copy) NSString *paymentCode; // 支付编码

@property (nonatomic, copy) NSString *verifyCode; // 手机验证码

@property (nonatomic, copy) NSString *isCod;// 是否是货到付款（给后台验证的）

@property (nonatomic, copy) NSString *node; // 1 cod方式， 2 online方式

@property (nonatomic, copy) NSString *orderID; // 订单号

/*************** 上面的参数是接口上传需要用的  *********************/

@property (nonatomic, copy) NSString   *currentInputPoint; // 当前输入的积分

@property (nonatomic, strong) NSMutableArray   *shippingListArray;

@property (nonatomic, copy) NSString *shippingPrice; // 物流运费

@property (nonatomic, copy) NSString *pointSavePrice; //point优惠

@property (nonatomic, copy) NSString *couponAmount; // coupon优惠

@property (nonatomic, copy) NSString *goods_price; // 商品价格

@property (nonatomic, copy) NSString *codFreight; // 货到付款收取的运费

@property (nonatomic, copy) NSString *countryID;

@property (nonatomic, copy) NSString *bizhong;

@property (nonatomic, copy) NSString *activities_amount; // 满减优惠的价格

@property (nonatomic, copy) NSString *addressCode;

@property (nonatomic, copy) NSString *supplierNumber;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, assign) CurrentPaymentType   currentPaymentType; // 用来判断当前支付方式,并切换货币符号

/************************下面参数用于快速支付***************************/
@property (nonatomic,copy) NSString *payertoken;
@property (nonatomic,copy) NSString *payerId;

- (void)adapterManagerWithModel:(ZFOrderCheckInfoDetailModel *)checkOutModel;
/**
 * 获取价格明细对应的model
 */
- (NSMutableArray *)queryAmountDetailArray;

/**
 * 获取商品原价格
 */
- (NSString *)querySubtotal;
/**
 * 获取订单运费
 */
- (NSString *)queryShippingCost;
/**
 * 获取保险费
 */
- (NSString *)queryShippingInsurance;
/**
 * 获取cod手续费
 */
- (NSString *)queryCodCost;
/**
 * 参与营销满减活动商品，对应分摊享受的优惠金额
 */
- (NSString *)querySalesEvents;
/**
 * 订单优惠券使用金额
 */
- (NSString *)queryCouponSaving;
/**
 * 积分优惠金额
 */
- (NSString *)queryZPointsSaving;
/**
 * 首次汇总金额
 */
- (NSString *)queryGrandTotal;
/**
 * 获取cod取整后价格
 */
- (NSString *)queryCodDiscount;
/**
 * 最终需要用户支付金额
 */
- (NSString *)queryTotalPayable;

/**
 * 判断cod商品是否超过规定金额限制 如果商品总额小于50 或 大于400 要做提示
 */
- (BOOL)isShowCODGoodsAmountLimit:(NSString *)payCode checkoutModel:(ZFOrderCheckInfoDetailModel *)checkoutModel;

/**
 * 获取cod 弹框显示的金额
 */
- (NSString *)queryCashOnDelivery;

/**
 * 获取当前订单显示的货币
 */
- (void)queryCurrentOrderCurrency;

/**
 * 拼接订单商品的订单号
 */
- (NSString *)appendGoodsSN:(ZFOrderCheckInfoDetailModel *)model;

/**
 * 支付方式统计
 */
- (void)analyticsClickButton:(NSString *)payMethod state:(NSInteger)state;


@end
