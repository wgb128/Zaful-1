//
//  StyleLikesListModel.m
//  Yoshop
//
//  Created by zhaowei on 16/7/13.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "StyleLikesListModel.h"
#import "StyleLikesModel.h"

@implementation StyleLikesListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list" : [StyleLikesModel class]
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
