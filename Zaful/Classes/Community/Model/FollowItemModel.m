//
//  FollowItemModel.m
//  Yoshop
//
//  Created by Stone on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "FollowItemModel.h"

@implementation FollowItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"avatar"       : @"avatar",
             @"nikename"     : @"nickname",
             @"userId"       : @"userId",
             @"isFollow"     : @"isFollow"
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"avatar",
             @"nikename",
             @"userId",
             @"isFollow"
             ];
}

@end
