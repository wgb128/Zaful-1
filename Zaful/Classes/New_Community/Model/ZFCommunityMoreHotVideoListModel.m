
//
//  ZFCommunityMoreHotVideoListModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/5.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityMoreHotVideoListModel.h"
#import "BannerModel.h"
#import "ZFCommunityMoreHotVideoModel.h"

@implementation ZFCommunityMoreHotVideoListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"bannerList" : @"bannerlist",
             @"videoList" : @"video_list"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"bannerList" : [BannerModel class],
             @"videoList" : [ZFCommunityMoreHotVideoModel class]
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
             @"curPage",
             @"pageCount",
             @"bannerList",
             @"videoList"
             ];
}
@end
