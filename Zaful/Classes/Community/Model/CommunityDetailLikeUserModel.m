//
//  CommunityDetailLikeUserModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/21.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CommunityDetailLikeUserModel.h"

@implementation CommunityDetailLikeUserModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"userId"       : @"user_id"
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"avatar",
             @"userId"
             ];
}

@end
