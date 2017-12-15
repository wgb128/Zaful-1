//
//  GoodListModel.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/2.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoodListModel : NSObject
@property (nonatomic, copy) NSString *wp_image; //webp_image
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *attr_color;
@property (nonatomic, copy) NSString *attr_size;
@property (nonatomic, assign) NSInteger buy_number;
@property (nonatomic, copy) NSString *cat_id;
@property (nonatomic, copy) NSString *cat_name;
@property (nonatomic, copy) NSString *custom_size;
@property (nonatomic, copy) NSString *goods_attr_id;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_img;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, assign) NSInteger goods_number;
@property (nonatomic, copy) NSString *goods_off;
@property (nonatomic, copy) NSString *goods_sn;
@property (nonatomic, copy) NSString *goods_title;
@property (nonatomic, copy) NSString *goods_volume_weight;
@property (nonatomic, copy) NSString *goods_weight;
@property (nonatomic, assign) BOOL if_collect;
@property (nonatomic, copy) NSString *is_dinghuo_goods;
@property (nonatomic, assign) NSInteger is_mobile_price;
@property (nonatomic, copy) NSString *is_free_shipping;
@property (nonatomic, assign) NSInteger is_promote;
@property (nonatomic, assign) NSInteger is_selected;
@property (nonatomic, copy) NSString *last_modified;
@property (nonatomic, copy) NSString *market_price;
@property (nonatomic, copy) NSString *promote_end_date;
@property (nonatomic, copy) NSString *promote_price;
@property (nonatomic, copy) NSString *promote_start_date;
@property (nonatomic, copy) NSString *rec_id;
@property (nonatomic, copy) NSString *session_id;
@property (nonatomic, copy) NSString *shipping_method;
@property (nonatomic, copy) NSString *shop_price;
@property (nonatomic, copy) NSString *subtotal;
@property (nonatomic, copy) NSString *url_title;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic,assign) BOOL isSelected;

@end
