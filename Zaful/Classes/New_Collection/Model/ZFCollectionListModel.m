//
//  ZFCollectionListModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCollectionListModel.h"
#import "ZFCollectionModel.h"

@implementation ZFCollectionListModel
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
             @"data" : [ZFCollectionModel class]
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
