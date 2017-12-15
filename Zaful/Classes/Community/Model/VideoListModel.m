//
//  VideoListModel.m
//  Zaful
//
//  Created by zhaowei on 2016/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "VideoListModel.h"
#import "BannerModel.h"
#import "VideoInfoModel.h"

@implementation VideoListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"bannerList" : @"bannerlist",
             @"videoList" : @"video_list"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"bannerList" : [BannerModel class],
             @"videoList" : [VideoInfoModel class]
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
