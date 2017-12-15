//
//  ZFPayMethodsListModel.m
//  Zaful
//
//  Created by liuxi on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPayMethodsListModel.h"
#import "ZFPayMethodsWaysModel.h"


@implementation ZFPayMethodsListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"pay_ways" : [ZFPayMethodsWaysModel class],
             @"cod"      : [CartCodModel class]
             };
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"cod_msg" : @"cod_msg",
             @"pay_ways" : @"pay_ways",
             @"cod"      : @"cod"
             };
}
@end
