//
//  LabelDetailModel.m
//  Zaful
//
//  Created by DBP on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "LabelDetailModel.h"
#import "LabelDetailListModel.h"

@implementation LabelDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list"    :   [LabelDetailListModel class]
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
