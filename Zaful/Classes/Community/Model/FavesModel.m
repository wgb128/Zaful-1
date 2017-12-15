//
//  FavesModel.m
//  Zaful
//
//  Created by huangxieyue on 16/11/26.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "FavesModel.h"
#import "FavesItemsModel.h"

@implementation FavesModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
                 @"list" : [FavesItemsModel class]
                 };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
                 @"list",
                 @"bannerlist",
                 @"pageCount",
                 @"curPage"
                 ];
}

@end
