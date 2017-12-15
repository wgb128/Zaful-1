//
//  FollowModel.m
//  Yoshop
//
//  Created by Stone on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "FollowModel.h"

@implementation FollowModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"listArray"       : @"list",
             @"pageCount"       : @"pageCount",
             @"page"            : @"curPage"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"listArray"    : [FollowItemModel class],
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
