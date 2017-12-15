//
//  CartGoodsModel.m
//  Zaful
//
//  Created by 7FD75 on 16/9/19.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "CartGoodsModel.h"
#import "CheckOutGoodListModel.h"

@implementation CartGoodsModel


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"goods_list" : [CheckOutGoodListModel class]
             };
}


@end
