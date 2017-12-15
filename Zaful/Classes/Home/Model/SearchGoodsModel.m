//
//  SearchGoodsModel.m
//  Zaful
//
//  Created by Y001 on 16/9/18.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "SearchGoodsModel.h"

@implementation SearchGoodsModel

+ (NSDictionary *)modelCustomPropertyMapper {

    return @{@"goods_id"       :@"goods_id",
             @"goods_sn"       :@"goods_sn",
             @"cat_id"         :@"cat_id",
             @"is_promote"     :@"is_promote",
             @"goods_number"   :@"goods_number",
             @"goods_brief"    :@"goods_brief",
             @"goods_weight"   :@"goods_weight",
             @"market_price"   :@"market_price",
             @"shop_price"     :@"shop_price",
             @"promote_zhekou" :@"promote_zhekou",
             @"goods_thumb"    :@"goods_thumb",
             @"goods_img"      :@"goods_img",
             @"goods_grid"     :@"goods_grid",

             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[@"goods_id",
             @"goods_sn",
             @"cat_id",
             @"is_promote",
             @"goods_number",
             @"goods_brief",
             @"goods_weight",
             @"market_price",
             @"shop_price",
             @"promote_zhekou",
             @"goods_thumb",
             @"goods_img",
             @"goods_grid",];
}

@end
