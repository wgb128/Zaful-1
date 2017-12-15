//
//  OrderDetailGoodModel.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/12.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZFMultAttributeModel;
@interface OrderDetailGoodModel : NSObject
/**
 "attr_color" = COLORMIX;
 "attr_size" = L;
 "goods_grid" = "http://gloimg.zaful.com/zaful/pdm-product-pic/Clothing/2016/03/21/grid-img/1458602285867153008.jpg";
 "goods_id" = 167108;
 "goods_name" = "Flower Print Cami A-Line Dress";
 "goods_number" = 3;
 "goods_price" = "17.49";
 "is_presale" = 0;
 "is_promote" = 0;
 "market_price" = "26.34";
 "order_rate" = "1.000000";
 "promote_end_date" = 0;
 "promote_price" = "0.00";
 "promote_start_date" = 0;
 subtotal = "52.47";
 "url_title" = "http://app-zaful.com.trunk.s1.egomsl.com/flower-print-cami-a-line-dress-p_167108.html";
 */
@property (nonatomic, copy) NSString *order_currency;
@property (nonatomic, copy) NSString *attr_color;
@property (nonatomic, copy) NSString *attr_size;
@property (nonatomic, copy) NSString *goods_grid;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_title;
@property (nonatomic, copy) NSString *goods_number;
@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, copy) NSString *is_presale;
@property (nonatomic, copy) NSString *is_promote;
@property (nonatomic, copy) NSString *market_price;
@property (nonatomic, copy) NSString *order_rate;
@property (nonatomic, copy) NSString *promote_end_date;
@property (nonatomic, copy) NSString *promote_price;
@property (nonatomic, copy) NSString *promote_start_date;
@property (nonatomic, copy) NSString *subtotal;
@property (nonatomic, copy) NSString *url_title;

@property (nonatomic, copy) NSString *goods_sn;

@property (nonatomic,assign) NSInteger is_review;//是否评论
@property (nonatomic, copy) NSString *wp_image; 
@property (nonatomic, strong) NSArray<ZFMultAttributeModel *>           *multi_attr;
@end
