
//
//  ZFCommunityAccountShowsListModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityAccountShowsListModel.h"
#import "ZFCommunityAccountShowsModel.h"
@implementation ZFCommunityAccountShowsListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list" : [ZFCommunityAccountShowsModel class]
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
