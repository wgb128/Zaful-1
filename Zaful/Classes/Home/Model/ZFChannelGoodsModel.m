//
//  ZFChannelGoodsModel.m
//  Zaful
//
//  Created by QianHan on 2017/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFChannelGoodsModel.h"

@implementation ZFChannelGoodsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"activityType": @"activityType",
             @"avgRate": @"avg_rate",
             @"avgRateImgURL": @"avg_rate_img",
             @"cateId": @"cat_id",
             @"flats": @"cat_name",
             
             @"cateName": @"cat_name",
             @"goodsBrief": @"goods_brief",
             @"goodsFullTitle": @"goods_full_title",
             @"goodsGrid": @"goods_grid",
             @"goodsId": @"goods_id",
             
             @"goodsImgURL": @"goods_img",
             @"goodsName": @"goods_name",
             @"goodsNumber": @"goods_number",
             @"goodsSN": @"goods_sn",
             @"goodsStyleName": @"goods_style_name",
             
             @"goodsThumb": @"goods_thumb",
             @"goodsTitle": @"goods_title",
             @"goodsWeight": @"goods_weight",
             @"is24hShip": @"is_24h_ship",
             @"isBest": @"is_best",
             
             @"isBundles": @"is_bundles",
             @"isCod": @"is_cod",
             @"isCollect": @"is_collect",
             @"isFreeShipping": @"is_free_shipping",
             @"isHot": @"is_hot",
             
             @"isMobilePrice": @"is_mobile_price",
             @"isNew": @"is_new",
             @"isPromote": @"is_promote",
             @"marketPrice": @"market_price",
             @"name": @"name",
             
             @"pointRate": @"point_rate",
             @"promotePrice": @"promote_price",
             @"promoteZheKou": @"promote_zhekou",
             @"reviewCount": @"review_count",
             @"savePerce": @"saveperce",
             
             @"savePrice": @"saveprice",
             @"shareAndSave": @"shareandsave",
             @"shelfDownType": @"shelf_down_type",
             @"shopPrice": @"shop_price",
             @"type": @"type",
             
             @"up": @"up",
             @"urlTitle": @"url_title",
             @"wpImage": @"wp_image"
             };
}

@end
