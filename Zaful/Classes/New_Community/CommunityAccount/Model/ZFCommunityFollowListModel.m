
//
//  ZFCommunityFollowListModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityFollowListModel.h"
#import "ZFCommunityFollowModel.h"
@implementation ZFCommunityFollowListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"listArray"       : @"list",
             @"pageCount"       : @"pageCount",
             @"page"            : @"curPage"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"listArray"    : [ZFCommunityFollowModel class],
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"listArray",
             @"pageCount",
             @"page"
             ];
}
@end
