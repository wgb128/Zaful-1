//
//  GoodsDetailModel.m
//  Dezzal
//
//  Created by ZJ1620 on 16/8/1.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "GoodsDetailModel.h"

@implementation GoodsDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"same_cat_goods"        : @"same_cat_goods",
             @"same_goods_spec"       : @"same_goods_spec",
             @"same_cat_goods_page"   : @"same_cat_goods_page",
             @"properties"            : @"properties",
             @"specification"         : @"specification",
             @"pictures"              : @"pictures",
             @"pic_count"             : @"pic_count",
             
             @"delivery_level"        : @"delivery_level",
             @"time_description"      : @"time_description",
             @"goods_name"            : @"goods_name",
             @"goods_number"          : @"goods_number",
             @"is_on_sale"            : @"is_on_sale",
             @"is_promote"            : @"is_promote",
             @"is_cod"                : @"is_cod",
             @"market_price"          : @"market_price",
             @"is_mobile_price"       : @"is_mobile_price",
             @"model_id"              : @"model_id",
             @"promote_end_time"      : @"promote_end_time",
             @"promote_price"         : @"promote_price",
             @"promote_zhekou"        : @"promote_zhekou",
             @"shelf_down_type"       : @"shelf_down_type",
             @"shop_price"            : @"shop_price",
             @"url"                   : @"url",
             
             @"size_url"              : @"size_url",
             @"model_url"             : @"model_url",
             @"desc_url"              : @"desc_url",
             @"is_collect"            : @"is_collect",
             @"like_count"            : @"like_count",
             @"goods_id"              : @"goods_id",
             @"goods_sn"              : @"goods_sn",
             @"shop_diff_mobile"      : @"shop_diff_mobile",
             
             @"reviewListModel"       : @"reviews",
             @"reviewList"            : @"review_list",
             @"reViewCount"           : @"review_count",
             @"rateAVG"               : @"review_avg_rate",
             @"group_goods_id"        : @"group_goods_id",
             @"wp_image"              : @"wp_image",
             @"shipping_tips"         : @"shipping_tips",
             @"reductionModel"        : @"is_bundles_reduction",
             @"goods_mulit_attr"      : @"goods_mulit_attr"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"pictures"       : [GoodsDetailPictureModel class],
             @"same_cat_goods" : [GoodsDetailSameModel class],
             @"same_goods_spec" :[GoodsDetailSizeColorModel class],
             @"reviewListModel" : [GoodsDetailFirstReviewModel class],
             @"reductionModel"  : [GoodsReductionModel class],
             @"goods_mulit_attr" : [GoodsDetailMulitAttrModel class],
             @"reviewList"      : [GoodsDetailFirstReviewModel class],
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"same_cat_goods",
             @"same_goods_spec",
             @"same_cat_goods_page",
             @"properties",
             @"specification",
             @"pictures",
             @"pic_count",
             @"delivery_level",
             @"time_description",
             @"goods_name",
             @"goods_number",
             @"is_on_sale",
             @"is_promote",
             @"is_mobile_price",
             @"market_price",
             @"model_id",
             @"promote_end_time",
             @"promote_price",
             @"promote_zhekou",
             @"shelf_down_type",
             @"shop_price",
             @"url",
             @"size_url",
             @"model_url",
             @"desc_url",
             @"is_collect",
             @"like_count",
             @"goods_id",
             @"goods_sn",
             @"shop_diff_mobile",
             @"reviewListModel",
             @"reViewCount",
             @"rateAVG",
             @"group_goods_id",
             @"wp_image",
             @"long_cat_name",
             @"reductionModel",
             @"is_cod",
             @"goods_mulit_attr",
             @"shipping_tips",
             @"reviewList",
             ];
}


@end
