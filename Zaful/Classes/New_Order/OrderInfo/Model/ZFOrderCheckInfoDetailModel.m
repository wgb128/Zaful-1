//
//  ZFOrderCheckInfoDetailModel.m
//  Zaful
//
//  Created by TsangFa on 26/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderCheckInfoDetailModel.h"

@implementation ZFOrderCheckInfoDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"goods_list"    : [CheckOutGoodListModel class],
             @"shipping_list" : [ShippingListModel class],
             @"payment_list"  : [PaymentListModel class],
             @"footer"        : [ZFOrderInfoFooterModel class],
             @"available": [ZFMyCouponModel class],
             @"disabled": [ZFMyCouponModel class]
             };
}
@end

