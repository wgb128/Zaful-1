//
//  ZFOrderCouponModel.m
//  Zaful
//
//  Created by QianHan on 2017/12/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderCouponModel.h"
#import "ZFMyCouponModel.h"

@implementation ZFOrderCouponModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"available" : [ZFMyCouponModel class],
             @"disabled": [ZFMyCouponModel class]
             };
}

@end
