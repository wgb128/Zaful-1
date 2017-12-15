//
//  ZFOrderCheckDoneDetailModel.h
//  Zaful
//
//  Created by TsangFa on 26/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFOrderCheckDoneDetailModel : NSObject
/**
 * 快捷支付状态类型
 */
@property (nonatomic, assign) FastPaypalOrderType   flag;
/**
 * 0 为 成功状态
 */
@property (nonatomic, assign) NSInteger             error;
/**
 * 正常情况下的金额
 */
@property (nonatomic, copy) NSString                *order_amount;
/**
 * 订单 id
 */
@property (nonatomic, copy) NSString                *order_id;
/**
 * 订单号
 */
@property (nonatomic, copy) NSString                *order_sn;
/**
 * online 支付链接
 */
@property (nonatomic, copy) NSString                *pay_url;
/**
 * cod取整后的金额
 */
@property (nonatomic, copy) NSString                *multi_order_amount;
/**
 * cod取整方向
 */
@property (nonatomic, copy) NSString                *cod_orientation;
/**
 * 支付方式
 */
@property (nonatomic, copy) NSString                *pay_method;
/**
 * 提示语
 */
@property (nonatomic, copy) NSString                *msg;

@property (nonatomic, copy) NSString                *promote_pcode;

@property (nonatomic, copy) NSString                *shipping_fee;

// 下面参数不是 json 里的字段
@property (nonatomic, copy) NSString                *payName;

@property (nonatomic, assign) PaymentStateType      payState;

@end
