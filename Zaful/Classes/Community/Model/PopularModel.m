//
//  PopularModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "PopularModel.h"
#import "BannerModel.h"
#import "FavesItemsModel.h"

@implementation PopularModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
                 @"list" : [FavesItemsModel class],
                 @"bannerlist" : [BannerModel class]
                 };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
                 @"list",
                 @"bannerlist",
                 @"video",
                 @"topicList",
                 @"pageCount",
                 @"curPage",
                 @"type"
                 ];
}

@end
