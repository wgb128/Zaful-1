//
//  ZFCommunityDetailModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityDetailModel.h"
#import "GoodsInfosModel.h"
#import "CommunityDetailLikeUserModel.h"
#import "PictureModel.h"

@implementation ZFCommunityDetailModel
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
