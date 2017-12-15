//
//  VideoDetailInfoModel.m
//  Zaful
//
//  Created by huangxieyue on 16/11/30.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "VideoDetailInfoModel.h"

@implementation VideoDetailInfoModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
                 @"videoId" : @"id",
                 @"viewNum" : @"view_num",
                 @"videoUrl" : @"video_url",
                 @"videoDescription" : @"video_description",
                 @"likeNum" : @"like_num"
                 };
}

+ (NSArray *)modelPropertyWhitelist
{
    return @[
                 @"videoId",
                 @"viewNum",
                 @"videoUrl",
                 @"videoDescription",
                 @"likeNum",
                 @"isLike"
                 ];
}

@end
