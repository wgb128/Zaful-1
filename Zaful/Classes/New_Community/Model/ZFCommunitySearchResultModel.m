
//
//  ZFCommunitySearchResultModel.m
//  Zaful
//
//  Created by liuxi on 2017/7/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunitySearchResultModel.h"
@implementation ZFCommunitySearchResultModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"avatar"       : @"avatar",
             @"isFollow"        : @"isFollow",
             @"likes_total"        : @"likes_total",
             @"nick_name"        : @"nick_name",
             @"review_total"        : @"review_total",
             @"user_id"        : @"user_id"
             };
}

@end
