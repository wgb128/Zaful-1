//
//  CommendListModel.m
//  Zaful
//
//  Created by zhaowei on 2017/1/15.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CommendListModel.h"
#import "CommendUserModel.h"

@implementation CommendListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list" : [CommendUserModel class]
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
             @"list",
             @"pageCount",
             @"curPage"
             ];
}
@end
