 //
//  StyleShowsListModel.m
//  Yoshop
//
//  Created by zhaowei on 16/7/13.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "StyleShowsListModel.h"
#import "StyleShowsModel.h"

@implementation StyleShowsListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list" : [StyleShowsModel class]
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
             @"curPage",
             @"pageCount",
             @"list",
             @"type"
             ];
}
@end
