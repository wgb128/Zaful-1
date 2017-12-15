//
//  ZFBaseGoodsModel.h
//  Zaful
//
//  Created by TsangFa on 14/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFBaseGoodsModel : NSObject
/**
 * 售价
 */
@property (nonatomic, copy) NSString   *shopPrice;

/**
 * 原价 (带中间线那种)
 */
@property (nonatomic, copy) NSString   *marketPrice;

/**
 * 是否促销 (根据这个字段决定是否显示marketprice)
 */
@property (nonatomic, assign) BOOL   is_promote;


/**
 * 折扣数
 */
@property (nonatomic, copy) NSString   *promote_zhekou;


/**
 * 是否显示APP标示 (手机专享价)
 */
@property (nonatomic, copy) NSString   *is_mobile_price;

@property (nonatomic, assign) BOOL      is_cod;
@end
