//
//  TopicDetailModel.m
//  Zaful
//
//  Created by DBP on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "TopicDetailModel.h"
#import "TopicDetailListModel.h"

@implementation TopicDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list"    :   [TopicDetailListModel class]
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
             @"list",
             @"pageCount",
             @"curPage",
             @"type"
             ];
}


@end
