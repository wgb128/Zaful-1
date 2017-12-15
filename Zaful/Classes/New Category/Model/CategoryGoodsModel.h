//
//  ListPageModel.h
//  ListPageViewController
//  何以解忧,唯有暴富
//  Created by TsangFa on 21/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryGoodsModel : NSObject<YYModel>

/** 
 * 商品分类id
 */
@property (nonatomic, copy) NSString   *cat_id;

/**
 * 图片URl
 */
@property (nonatomic, copy) NSString   *wp_image;

/**
 * 活动标示
 */
@property (nonatomic, copy) NSString   *activityType;

/**
 * 商品id
 */
@property (nonatomic, copy) NSString   *goods_id;

/**
 * 市场价(中间画线那种)
 */
@property (nonatomic, copy) NSString   *market_price;

/**
 * 在售价
 */
@property (nonatomic, copy) NSString   *shop_price;

/**
 * 是否促销
 */
@property (nonatomic, assign) BOOL   is_promote;

/**
 * 折扣
 */
@property (nonatomic, copy) NSString   *discount;

/**
 * 是否手机专享
 */
@property (nonatomic, copy) NSString   *isExclusive;

/**
 * 产品名称
 */
@property (nonatomic, copy) NSString   *goodsName;

@property (nonatomic,assign) BOOL       is_cod;
@end
