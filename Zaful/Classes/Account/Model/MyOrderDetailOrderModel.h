//
//  OrderDetailOrderModel.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/12.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailOrderModel : NSObject

@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *consignee;
@property (nonatomic, strong) NSString *country_str;
@property (nonatomic, strong) NSString *country_id;
@property (nonatomic, strong) NSString *coupon;
@property (nonatomic, strong) NSString *goods_amount;
@property (nonatomic, strong) NSString *grand_total;
@property (nonatomic, strong) NSString *insurance;
@property (nonatomic, strong) NSString *insure_fee;
@property (nonatomic, strong) NSString *order_amount;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_sn;
@property (nonatomic, strong) NSString *order_status;
@property (nonatomic, strong) NSString *order_status_str;
@property (nonatomic, strong) NSString *pay_name;
@property (nonatomic, strong) NSString *pay_time;
@property (nonatomic, strong) NSString *point_money;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *shipping;
@property (nonatomic, strong) NSString *shipping_fee;
@property (nonatomic, strong) NSString *shipping_name;
@property (nonatomic, strong) NSString *subtotal;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *total_cost;
@property (nonatomic, strong) NSString *total_fee;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *z_point;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSString *order_currency;
@property (nonatomic, strong) NSString *pay_id;
@property (nonatomic, strong) NSString *formalities_fee;
/**
 *  新增orderDetail 支付链接
 */

@property (nonatomic, strong) NSString *pay_url;


/**
 *  新增的优惠券金额
 */

//@property (nonatomic, copy) NSString *coupon_discount;

@end
