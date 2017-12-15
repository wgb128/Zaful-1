//
//  CartCreateOrderModel.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/9.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartCreateOrderModel : NSObject

@property (nonatomic, copy) NSString *order_amount;//正常情况下的金额

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, copy) NSString *order_sn;

@property (nonatomic, copy) NSString *pay_url;

@property (nonatomic, copy) NSString *promote_pcode;

@property (nonatomic, copy) NSString *shipping_fee;

@property (nonatomic, copy) NSString *multi_order_amount;//取整后的金额

@property (nonatomic, copy) NSString *cod_orientation;//判断取整方向

@property (nonatomic, copy) NSString *pay_method;
@end
