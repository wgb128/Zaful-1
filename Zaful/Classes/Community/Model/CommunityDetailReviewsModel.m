//
//  CommunityDetailReviewsModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/15.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CommunityDetailReviewsModel.h"
#import "CommunityDetailReviewsListMode.h"

@implementation CommunityDetailReviewsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list" : [CommunityDetailReviewsListMode class]
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"list",
             @"curPage",
             @"pageCount",
             @"type"
             ];
}

@end