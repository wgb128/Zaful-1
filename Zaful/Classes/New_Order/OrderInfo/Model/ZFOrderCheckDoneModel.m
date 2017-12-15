//
//  ZFOrderCheckDoneModel.m
//  Zaful
//
//  Created by TsangFa on 24/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderCheckDoneModel.h"
#import "ZFOrderCheckDoneDetailModel.h"

@implementation ZFOrderCheckDoneModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"order_info" : [ZFOrderCheckDoneDetailModel class]
             };
}

@end
