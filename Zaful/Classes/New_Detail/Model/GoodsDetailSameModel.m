//
//  GoodsDetailSameModel.m
//  Zaful
//
//  Created by ZJ1620 on 16/9/19.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "GoodsDetailSameModel.h"

@implementation GoodsDetailSameModel


+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"goods_id"           : @"goods_id",
             @"cat_id"             : @"cat_id",
             @"goods_title"        : @"goods_title",
             @"short_name"         : @"short_name",
             @"goods_thumb"        : @"goods_thumb",
             @"goods_grid"         : @"goods_grid",
             @"shop_price"         : @"shop_price",
             @"url_title"          : @"url_title",
             @"market_price"       : @"market_price",
             @"promote_price"      : @"promote_price",
             @"promote_zhekou"     : @"promote_zhekou",
             @"odr"                : @"odr",
             @"is_promote"         : @"is_promote",
             @"is_mobile_price"    : @"is_mobile_price",
             @"wp_image"           :@"wp_image",
             @"is_cod"             : @"is_cod"
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"goods_id",
             @"cat_id",
             @"goods_title",
             @"short_name",
             @"goods_thumb",
             @"goods_grid",
             @"shop_price",
             @"url_title",
             @"market_price",
             @"promote_price",
             @"promote_zhekou",
             @"odr",
             @"is_promote",
             @"is_mobile_price",
             @"wp_image",
             @"is_cod"
             ];
}


@end
