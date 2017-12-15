//
//  SearchResultModel.m
//  Zaful
//
//  Created by Y001 on 16/9/18.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "SearchResultModel.h"
#import "GoodsModel.h"
@implementation SearchResultModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"goodsArray" : @"goods_list",
             @"result_num" : @"result_num",
             @"total_page" : @"total_page",
             @"cur_page"   : @"cur_page"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"goodsArray" : [GoodsModel class],
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[@"goodsArray",
             @"result_num",
             @"total_page",
             @"cur_page" ];
}
@end
