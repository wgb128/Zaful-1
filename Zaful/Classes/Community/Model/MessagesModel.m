//
//  MessagesModel.m
//  Zaful
//
//  Created by DBP on 17/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "MessagesModel.h"
#import "MessagesListModel.h"

@implementation MessagesModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list"    :   [MessagesListModel class]
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
