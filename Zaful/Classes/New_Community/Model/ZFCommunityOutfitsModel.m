//
//  ZFCommunityOutfitsModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityOutfitsModel.h"


@implementation ZFCommunityOutfitsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"reviewId" : @"id",
             @"userId" : @"user_id",
             @"propertyType" : @"property",
             @"reviewTitle" : @"title",
             @"reviewContent" : @"content",
             @"reviewAddTime" : @"add_time",
             @"siteVersion" : @"site_version",
             @"likeCount" : @"like_count",
             @"viewsCount" : @"view_num",
             @"avatar" : @"avatar",
             @"nikename" : @"nickname",
             @"sort" : @"sort",
             @"reviewType" : @"review_type",
             @"liked" : @"liked",
             @"followedCount" : @"followed",
             @"replyCount" : @"reply_count",
             @"picInfo" : @"pic"
             };
}
@end
