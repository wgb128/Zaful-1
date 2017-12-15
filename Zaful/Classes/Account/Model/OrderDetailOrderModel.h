//
//  OrderDetailOrderModel.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/12.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailOrderModel : NSObject

@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *consignee;
@property (nonatomic, copy) NSString *country_str;
@property (nonatomic, copy) NSString *country_id;
@property (nonatomic, copy) NSString *coupon;
@property (nonatomic, copy) NSString *goods_amount;
@property (nonatomic, copy) NSString *grand_total;
@property (nonatomic, copy) NSString *insurance;
@property (nonatomic, copy) NSString *insure_fee;
@property (nonatomic, copy) NSString *order_amount;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *order_status;
@property (nonatomic, copy) NSString *order_status_str;
@property (nonatomic, copy) NSString *pay_name;
@property (nonatomic, copy) NSString *pay_time;
@property (nonatomic, copy) NSString *pay_status;
@property (nonatomic, copy) NSString *point_money;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *shipping;
@property (nonatomic, copy) NSString *shipping_fee;
@property (nonatomic, copy) NSString *shipping_name;
@property (nonatomic, copy) NSString *subtotal;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *total_cost;
@property (nonatomic, copy) NSString *total_fee;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *z_point;
@property (nonatomic, copy) NSString *zipcode;
@property (nonatomic, copy) NSString *order_currency;
@property (nonatomic, copy) NSString *pay_id;
@property (nonatomic, copy) NSString *formalities_fee;

@property (nonatomic, copy) NSString *code; //区号
@property (nonatomic, copy) NSString *supplier_number; //运营商号
/**
 *  新增orderDetail 支付链接
 */

@property (nonatomic, copy) NSString *pay_url;


/**
 *  新增的优惠券金额
 */
@property (nonatomic, copy) NSString *cod_orientation;
@property (nonatomic, copy) NSString *cod_discount;
@property (nonatomic, copy) NSString *total_payable;
@end
