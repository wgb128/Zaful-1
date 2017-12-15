//
//  VideoInfoModel.m
//  Zaful
//
//  Created by zhaowei on 2016/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "VideoInfoModel.h"

@implementation VideoInfoModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
                 @"videoId" : @"id",
                 @"videoTitle" : @"video_title",
                 @"viewNum" : @"view_num",
                 @"videoUrl" : @"video_url",
                 @"videoDesc" : @"duration"
                 };
}

+ (NSArray *)modelPropertyWhitelist
{
    return @[
                 @"videoId",
                 @"videoTitle",
                 @"viewNum",
                 @"videoUrl",
                 @"videoDesc"
                 ];
}

@end
