//
//  ZFCollectionModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCollectionModel.h"

@implementation ZFCollectionModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"multi_attr" : [ZFMultAttributeModel class],
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"wp_image"          : @"wp_image",
             @"goods_number"      : @"goods_number",
             @"goods_grid"        : @"goods_grid",
             @"rec_id"            : @"rec_id",
             @"is_attention"      : @"is_attention",
             @"goods_id"          : @"goods_id",
             @"goods_title"       : @"goods_title",
             @"market_price"      : @"market_price",
             @"shop_price"        : @"shop_price",
             @"promote_price"     : @"promote_price",
             @"attr_color"        : @"attr_color",
             @"attr_size"         : @"attr_size",
             @"is_promote"        : @"is_promote",
             @"is_mobile_price"    : @"is_mobile_price",
             @"promote_zhekou"      : @"promote_zhekou",
             @"is_cod"            : @"is_cod",
             @"multi_attr"        : @"multi_attr"
             };
}
// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"wp_image",
             @"goods_number",
             @"goods_grid",
             @"rec_id",
             @"is_attention",
             @"goods_id",
             @"goods_title",
             @"market_price",
             @"shop_price",
             @"promote_price",
             @"attr_color",
             @"attr_size",
             @"is_promote",
             @"is_mobile_price",
             @"promote_zhekou",
             @"is_cod",
             @"multi_attr"
             ];
}

@end
