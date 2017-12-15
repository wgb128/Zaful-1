//
//  OrderDetailGoodModel.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/12.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "OrderDetailGoodModel.h"
#import "ZFMultAttributeModel.h"

@implementation OrderDetailGoodModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"multi_attr" : [ZFMultAttributeModel class],
             };
}
@end
