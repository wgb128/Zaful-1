//
//  MyOrdersModel.h
//  Yoshop
//
//  Created by huangxieyue on 16/6/7.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrdersModel : NSObject

@property (nonatomic, copy) NSString *order_currency;

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, copy) NSString *order_sn;

@property (nonatomic, copy) NSString *order_status;

@property (nonatomic, copy) NSString *order_status_str;

@property (nonatomic, copy) NSString *order_time;

@property (nonatomic, copy) NSString *pay_id;

@property (nonatomic, copy) NSString *pay_url;

@property (nonatomic, copy) NSString *total_fee;

@property (nonatomic, copy) NSArray *goods;

@property (nonatomic, copy) NSString *promote_pcode;

@property (nonatomic, copy) NSString *shipping_fee;

// 用于显示 boletoBancario 支付状态
@property (nonatomic, copy) NSString *pay_status;

@end

