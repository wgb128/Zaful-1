//
//  GoodsModel.h
//  Zaful
//
//  Created by Y001 on 16/9/19.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject<YYModel>

//market_price | double | 市场价格
//shop_price | double | 本店售价，如果有折扣价，则为折扣价

//goods_thumb | String | 商品缩略图
//goods_img | String | 商品缩略图
//goods_grid | String | 商品缩略图，跟上面两个是3种不同尺寸的缩略图
//original_img | String | 商品原图
//goods_brief | String | 商品简述
//goods_desc | String | 商品详情
//attr_color | String | 商品颜色
//attr_size | String | 商品尺寸
//goods_weight | String | 商品重量
//goods_title | String | 商品标题
//goods_sn | String | 商品SKU

//goods_id | int | 商品ID
//cat_id | Int | 分类ID
//is_promote | Int | 是否有优惠
//goods_number | Int | 商品库存
//isonsale | Int | 是否上架，0=下架，1=上架
//add_time | Int | 添加时间，时间戳
//promote_zhekou | Int | 折扣率
//more_color | Int | 该颜色是否有更多同款,1表示有，0表示没有

@property (nonatomic, strong) NSString *wp_image; //webp_image
@property (nonatomic, copy) NSString * goods_thumb;
@property (nonatomic, copy) NSString * goods_img;
@property (nonatomic, copy) NSString * goods_grid;
@property (nonatomic, copy) NSString * original_img;
@property (nonatomic, copy) NSString * goods_brief;
@property (nonatomic, copy) NSString * goods_desc;
@property (nonatomic, copy) NSString * attr_color;
@property (nonatomic, copy) NSString * attr_size;
@property (nonatomic, copy) NSString * goods_weight;
@property (nonatomic, copy) NSString * goods_title;
@property (nonatomic, copy) NSString * goods_sn;

@property (nonatomic, assign) NSInteger goods_id;
@property (nonatomic, assign) NSInteger cat_id;
@property (nonatomic, assign) NSInteger is_promote;
@property (nonatomic, assign) NSInteger is_mobile_price;
@property (nonatomic, assign) NSInteger goods_number;
@property (nonatomic, assign) NSInteger isonsale;
@property (nonatomic, assign) NSInteger add_time;
@property (nonatomic, assign) NSInteger promote_zhekou;
@property (nonatomic, assign) NSInteger more_color;
@property (nonatomic, assign) ZFActivityType activityType;

@property (nonatomic, assign) double market_price;
@property (nonatomic, assign) double shop_price;
@property (nonatomic, assign) BOOL      is_cod;

@end
