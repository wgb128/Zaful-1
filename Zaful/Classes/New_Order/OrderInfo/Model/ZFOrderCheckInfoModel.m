//
//  ZFOrderCheckInfoModel.m
//  Zaful
//
//  Created by TsangFa on 23/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderCheckInfoModel.h"
#import "ZFOrderCheckInfoDetailModel.h"

@implementation ZFOrderCheckInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"order_info" : [ZFOrderCheckInfoDetailModel class]
             };
}

@end
