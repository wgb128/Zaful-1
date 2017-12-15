//
//  GoodsDetailSameModel.h
//  Zaful
//
//  Created by ZJ1620 on 16/9/19.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetailSameModel : NSObject

@property (nonatomic, copy) NSString *goods_id;//商品编号
@property (nonatomic, copy) NSString *cat_id;//分类ID
@property (nonatomic, copy) NSString *goods_title;//商品标题
@property (nonatomic, copy) NSString *short_name;//简称
@property (nonatomic, copy) NSString *goods_thumb;// 商品缩略图（100*100）
@property (nonatomic, copy) NSString *goods_grid;// 商品缩略图（150*150）
@property (nonatomic, copy) NSString *shop_price;// 商品销售价
@property (nonatomic, copy) NSString *url_title;//URL使用标题
@property (nonatomic, copy) NSString *market_price;//商品市场价
@property (nonatomic, copy) NSString *promote_price;// 商品促销价
@property (nonatomic, copy) NSString *promote_zhekou;//折扣百分数
@property (nonatomic, copy) NSString *odr;//排序
@property (nonatomic, copy) NSString *is_promote;//是否促销
@property (nonatomic, copy) NSString *is_mobile_price;//是否手机专享价
@property (nonatomic, copy) NSString *wp_image;//webpImage
@property (nonatomic, assign) BOOL   is_cod;

@end
