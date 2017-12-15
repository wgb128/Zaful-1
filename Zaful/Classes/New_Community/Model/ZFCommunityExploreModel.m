//
//  ZFCommunityExploreModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityExploreModel.h"
#import "ZFCommunityFavesItemModel.h"
#import "BannerModel.h"

@implementation ZFCommunityExploreModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list" : [ZFCommunityFavesItemModel class],
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
