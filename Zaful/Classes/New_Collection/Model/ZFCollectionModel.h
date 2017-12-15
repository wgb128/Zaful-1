//
//  ZFCollectionModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFMultAttributeModel.h"

@interface ZFCollectionModel : NSObject
@property (nonatomic, copy) NSString        *wp_image; //webp_image
@property (nonatomic, copy) NSString        *goods_id;        //商品ID
@property (nonatomic, copy) NSString        *goods_title;    //商品标题
@property (nonatomic, copy) NSString        *shop_price;     //| 商品销售价格
@property (nonatomic, copy) NSString        *rec_id;         //收藏编号
@property (nonatomic, copy) NSString        *goods_grid;     //商品缩略图（150*150）
@property (nonatomic, copy) NSString        *is_attention;     //关注{1是0否}
@property (nonatomic, copy) NSString        *attr_size;       //商品尺寸
@property (nonatomic, copy) NSString        *promote_price;   //商品促销价格
@property (nonatomic, copy) NSString        *market_price;   // 商品市场价格
@property (nonatomic, copy) NSString        *attr_color;     //商品颜色
@property (nonatomic, copy) NSString        *cat_id;
@property (nonatomic, assign) NSInteger     goods_number;  //商品数量
@property (nonatomic, assign) NSInteger     is_promote;   //是否促销商品，1是，0否
@property (nonatomic, assign) NSInteger     is_mobile_price;   //是否手机专享价，1是，0否
@property (nonatomic, assign) BOOL           isSelected;
@property (nonatomic, assign) BOOL          is_cod;
@property (nonatomic, copy) NSString        *promote_zhekou;
@property (nonatomic, strong) NSArray<ZFMultAttributeModel *>       *multi_attr;
@end
