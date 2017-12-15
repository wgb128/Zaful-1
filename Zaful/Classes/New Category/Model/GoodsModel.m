//
//  GoodsModel.m
//  Zaful
//
//  Created by Y001 on 16/9/19.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"wp_image"         :@"wp_image",
             @"goods_thumb"      :@"goods_thumb",
             @"goods_img"        :@"goods_img",
             @"goods_grid"       :@"goods_grid",
             @"original_img"     :@"original_img",
             @"goods_brief"      :@"goods_brief",
             @"goods_desc"       :@"goods_desc",
             @"attr_color"       :@"attr_color",
             @"attr_size"        :@"attr_size",
             @"goods_weight"     :@"goods_weight",
             @"goods_title"      :@"goods_title",
             @"goods_sn"         :@"goods_sn",
             @"goods_id"         :@"goods_id",
             @"cat_id"           :@"cat_id",
             @"is_promote"       :@"is_promote",
             @"goods_number"     :@"goods_number",
             @"isonsale"         :@"isonsale",
             @"add_time"         :@"add_time",
             @"promote_zhekou"   :@"promote_zhekou",
             @"more_color"       :@"more_color",
             @"market_price"     :@"market_price",
             @"shop_price"       :@"shop_price",
             @"is_mobile_price"  :@"is_mobile_price",
             @"activityType"     :@"activityType",
             @"is_cod"           :@"is_cod"
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return  @[
              @"wp_image",
              @"goods_thumb",
              @"goods_img",
              @"goods_grid",
              @"original_img",
              @"goods_brief",
              @"goods_desc",
              @"attr_color",
              @"attr_size",
              @"goods_weight",
              @"goods_title",
              @"goods_sn",
              @"goods_id",
              @"cat_id",
              @"is_promote",
              @"goods_number",
              @"isonsale",
              @"add_time",
              @"promote_zhekou",
              @"more_color",
              @"market_price",
              @"shop_price",
              @"is_mobile_price",
              @"activityType",
              @"is_cod"
              ];
}


@end
