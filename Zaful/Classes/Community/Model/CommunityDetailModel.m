//
//  CommunityDetailModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/14.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CommunityDetailModel.h"

#import "GoodsInfosModel.h"
#import "CommunityDetailLikeUserModel.h"
#import "PictureModel.h"

@implementation CommunityDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
                 @"reviewPic" : [PictureModel class],
                 @"goodsInfos" : [GoodsInfosModel class],
                 @"likeUsers" : [CommunityDetailLikeUserModel class]
                 };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
                 @"avatar",
                 @"userId",
                 @"nickname",
                 @"addTime",
                 @"isFollow",
                 @"content",
                 @"reviewPic",
                 @"likeUsers",
                 @"likeCount",
                 @"isLiked",
                 @"replyCount",
                 @"goodsInfos",
                 @"type",
                 @"reviewsId",
                 @"labelInfo",
                 @"sort"
                 ];
}

@end
