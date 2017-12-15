//
//  TopicModel.m
//  Zaful
//
//  Created by DBP on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "TopicModel.h"
#import "TopicListModel.h"

@implementation TopicModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"topic"    :   [TopicListModel class]
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
             @"topic",
             @"pageCount",
             @"curPage",
             @"type"
             ];
}


@end
