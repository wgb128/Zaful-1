//
//  SearchGoodsModel.h
//  Zaful
//
//  Created by Y001 on 16/9/18.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchGoodsModel : NSObject<YYModel>

@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * goods_sn;
@property (nonatomic, copy) NSString * cat_id;
@property (nonatomic, copy) NSString * is_promote;
@property (nonatomic, copy) NSString * goods_number;
@property (nonatomic, copy) NSString * goods_brief;
@property (nonatomic, copy) NSString * goods_weight;
@property (nonatomic, copy) NSString * market_price;
@property (nonatomic, copy) NSString * shop_price;
@property (nonatomic, copy) NSString * promote_zhekou;
@property (nonatomic, copy) NSString * goods_thumb;
@property (nonatomic, copy) NSString * goods_img;
@property (nonatomic, copy) NSString * goods_grid;



@end
