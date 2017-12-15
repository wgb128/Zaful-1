
//
//  ZFCommunityTopicListModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityTopicListModel.h"
#import "ZFCommunityTopicModel.h"

@implementation ZFCommunityTopicListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list"    :   [ZFCommunityTopicModel class]
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
