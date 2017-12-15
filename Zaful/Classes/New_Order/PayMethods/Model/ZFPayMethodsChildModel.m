//
//  ZFPayMethodsChildModel.m
//  Zaful
//
//  Created by liuxi on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPayMethodsChildModel.h"
#import "CheckOutGoodListModel.h"

@implementation ZFPayMethodsChildModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"goodsList" : [CheckOutGoodListModel class],
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"type" : @"type",
             @"goodsList" : @"goods_list",
             };
}
@end
