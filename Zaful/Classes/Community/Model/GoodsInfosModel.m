//
//  GoodsInfosModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/19.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "GoodsInfosModel.h"

@implementation GoodsInfosModel

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
                 @"goodsImg",
                 @"goodsTitle",
                 @"shopPrice",
                 @"goodsId"                 ];
}

@end
