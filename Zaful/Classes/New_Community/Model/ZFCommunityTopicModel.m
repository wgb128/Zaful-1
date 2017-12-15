//
//  ZFCommunityTopicModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityTopicModel.h"
#import "PictureModel.h"

@implementation ZFCommunityTopicModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"reviewPic" : [PictureModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"reviewId"    :   @"reviewId",
             @"userId"       :   @"userId",
             @"avatar"       :   @"avatar",
             @"nickname"     :   @"nickname",
             @"addTime"      :   @"add_time",
             @"isFollow"     :   @"isFollow",
             @"content"      :   @"content",
             @"reviewPic"    :   @"reviewPic",
             @"likeCount"    :   @"likeCount",
             @"isLiked"      :   @"isLiked",
             @"topicList"    :   @"topicList",
             @"replyCount"   :   @"replyCount"
             };
}


@end
