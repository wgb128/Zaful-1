
//
//  ZFCartGoodsListModel.m
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartGoodsListModel.h"
#import "ZFCartGoodsModel.h"

@implementation ZFCartGoodsListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"cartList" : [ZFCartGoodsModel class],
             };
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"url" : @"url",
             @"msg" : @"msg",
             @"goodsModuleType" : @"goods_module_type",
             @"cartList" : @"cart_list",
             };
}
@end
