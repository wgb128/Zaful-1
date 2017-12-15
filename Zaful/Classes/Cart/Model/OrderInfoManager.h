//
//  OrderInfoManager.h
//  Zaful
//
//  Created by TsangFa on 17/3/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfoManager : NSObject

@property (nonatomic, copy) NSString *couponCode; // 优惠码

@property (nonatomic, copy) NSString *addressId;// 地址id

@property (nonatomic, copy) NSString *shippingId; // 物流id

@property (nonatomic, copy) NSString *need_traking_number;

@property (nonatomic, copy) NSString *insurance; // 物流保险费

@property (nonatomic, copy) NSString *currentPoint; // 目前使用积分

@property (nonatomic, copy) NSString *paymentCode; // 支付编码

@property (nonatomic, copy) NSString *verifyCode; // 手机验证码

@property (nonatomic, copy) NSString *isCod;// 是否是货到付款（给后台验证的）

/*************** 上面的参数是接口上传需要用的  *********************/

@property (nonatomic, copy) NSString *shippingPrice; // 物流运费

@property (nonatomic, copy) NSString *pointSavePrice; //point优惠

@property (nonatomic, copy) NSString *couponAmount; // coupon优惠

@property (nonatomic, copy) NSString *goods_price; // 商品价格

@property (nonatomic, copy) NSString *codFreight; // 货到付款收取的运费

@property (nonatomic,copy) NSString *countryID;

@property (nonatomic, copy) NSString   *bizhong;

@property (nonatomic, copy) NSString   *activities_amount; // 满减优惠的价格

/************************下面参数用于快速支付***************************/
@property (nonatomic,copy) NSString *payertoken;
@property (nonatomic,copy) NSString *payerId;
@end
