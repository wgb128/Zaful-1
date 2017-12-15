

//
//  ZFCartGoodsModel.m
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartGoodsModel.h"
#import "ZFMultAttributeModel.h"

@implementation ZFCartGoodsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"multi_attr" : [ZFMultAttributeModel class],
             };
}
@end
