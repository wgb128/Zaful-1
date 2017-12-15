
//
//  ZFCommunityFollowModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityFollowModel.h"

@implementation ZFCommunityFollowModel
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
