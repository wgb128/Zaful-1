//
//  ZFTrackingPackageModel.h
//  Zaful
//
//  Created by TsangFa on 4/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFTrackingPackageModel : NSObject


@property (nonatomic, copy) NSString   *order_sn;

/**
 * 物流方式
 */
@property (nonatomic, copy) NSString   *shipping_name;


/**
 * 物流编号
 */
@property (nonatomic, copy) NSString   *shipping_no;


/**
 * 商品列表
 */
@property (nonatomic, strong) NSArray   *track_goods;

/**
 * 物流信息
 */
@property (nonatomic, strong) NSArray   *track_list;



@end
