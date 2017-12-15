//
//  CartCheckOutModel.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/6.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CartCheckOutModel.h"

#import "CheckOutGoodListModel.h"
#import "ShippingListModel.h"

@implementation CartCheckOutModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
              @"goods_list"    : [CheckOutGoodListModel class],
              @"shipping_list" : [ShippingListModel class],
              @"payment_list"  : [PaymentListModel class],
              @"footer"   : [ZFOrderInfoFooterModel class]
             };
}

@end
