
//
//  ZFCommunitySuggestedUsersModel.m
//  Zaful
//
//  Created by liuxi on 2017/7/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunitySuggestedUsersModel.h"
@implementation ZFCommunitySuggestedUsersModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"avatar"       : @"avatar",
             @"isFollow"        : @"isFollow",
             @"likes_total"        : @"likes_total",
             @"nickname"        : @"nickname",
             @"review_total"        : @"review_total",
             @"user_id"        : @"user_id",
             @"postlist"          : @"postlist"
             };
}
@end
