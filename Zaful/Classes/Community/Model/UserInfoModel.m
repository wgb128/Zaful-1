//
//  UserInfoModel.m
//  Yoshop
//
//  Created by zhaowei on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"nickName"       : @"nick_name"
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
             @"state",
             @"avatar",
             @"nickName",
             @"followingCount",
             @"followersCount",
             @"userId",
             @"likeCount",
             @"isFollow"
             ];
}
@end
