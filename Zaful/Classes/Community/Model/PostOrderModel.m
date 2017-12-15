//
//  PostOrderModel.m
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "PostOrderModel.h"


@implementation PostOrderModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"total_page"    : @"total_page",
             @"page_size"     : @"page_size",
             @"data"          : @"data",
             @"page"          : @"page",
             @"total"         : @"total",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [PostOrderListModel class]
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"total_page",
             @"page_size" ,
             @"data" ,
             @"page" ,
             @"total"
             ];
}

@end
