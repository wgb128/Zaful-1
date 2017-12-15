//
//  GoodsDetialSizeModel.m
//  Dezzal
//
//  Created by ZJ1620 on 16/8/1.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "GoodsDetialSizeModel.h"

@implementation GoodsDetialSizeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"goods_id"           : @"goods_id",
             @"attr_value"         : @"attr_value",
             @"is_click"           : @"is_click",
             @"data_tips"          : @"data_tips",
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"goods_id",
             @"attr_value",
             @"is_click",
             @"data_tips",
             ];
}

@end
