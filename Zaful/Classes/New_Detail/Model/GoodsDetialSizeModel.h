//
//  GoodsDetialSizeModel.h
//  Dezzal
//
//  Created by ZJ1620 on 16/8/1.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetialSizeModel : NSObject

@property (nonatomic, copy) NSString   *  goods_id;         //商品ID
@property (nonatomic, copy) NSString   *  attr_value;      //属性值
@property (nonatomic, assign) NSInteger    is_click;//商品是否售罄，0否，1是没有库存，2是下架
@property (nonatomic, copy) NSString   *data_tips;
@end
