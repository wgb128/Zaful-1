

//
//  ZFCommunityAccountLikesModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityAccountLikesModel.h"
#import "PictureModel.h"
@implementation ZFCommunityAccountLikesModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"nickName" : @"nickname",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"reviewPic" : [PictureModel class]
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
             @"addTime",
             @"avatar",
             @"content",
             @"isFollow",
             @"isLiked",
             @"likeCount",
             @"nickName",
             @"replyCount",
             @"reviewId",
             @"reviewPic",
             @"userId",
             @"topicList"
             ];
}
@end
