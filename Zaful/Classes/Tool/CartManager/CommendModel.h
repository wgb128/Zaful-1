//
//  CommendModel.h
//  Yoshop
//
//  Created by zhaowei on 16/6/18.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommendModel : NSObject<BCORMEntityProtocol>
@property (nonatomic,copy) NSString *rowid;//数据库ID
@property (nonatomic,copy) NSString *goodsId;//商品ID
@property (nonatomic,copy) NSString *goodsName;//商品名称
@property (nonatomic,copy) NSString *goodsPrice;//商品价格
@property (nonatomic,copy) NSString *promotePrice;
@property (nonatomic,copy) NSString *goodsAttr;//商品属性
@property (nonatomic,copy) NSString *goodsThumb;//商品缩略图
@property (nonatomic,copy) NSString *modify;//修改时间
@property (nonatomic,copy) NSString *groupId;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,copy) NSString *wp_image; //webpImage
/**
 * 是否促销 (根据这个字段决定是否显示marketprice)
 */
@property (nonatomic, assign) BOOL   is_promote;

@property (nonatomic, assign) BOOL   is_cod;
/**
 * 折扣数 (为 0 不显示 折扣标)
 */
@property (nonatomic, copy) NSString   *promote_zhekou;


/**
 * 是否显示APP标示 (手机专享价)
 */
@property (nonatomic, copy) NSString   *is_mobile_price;
@end
