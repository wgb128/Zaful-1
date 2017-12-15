//
//  GoodsDetailMulitAttrModel.m
//  Zaful
//
//  Created by liuxi on 2017/10/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "GoodsDetailMulitAttrModel.h"

@implementation GoodsDetailMulitAttrModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"value"       : [GoodsDetailMulitAttrInfoModel class],

             };
}
@end
