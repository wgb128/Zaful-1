
//
//  ZFCartListResultModel.m
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartListResultModel.h"
#import "ZFCartGoodsListModel.h"

@implementation ZFCartListResultModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"goodsBlockList" : [ZFCartGoodsListModel class],
             };
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"totalNumber" : @"cart_total_number",
             @"discountAmount" : @"cart_discount_amount",
             @"totalAmount" : @"cart_total_amount",
             @"goodsBlockList" : @"goods_list",
             };
}
@end
