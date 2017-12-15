//
//  TopicDetailListModel.m
//  Zaful
//
//  Created by DBP on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "TopicDetailListModel.h"
#import "PictureModel.h"

@implementation TopicDetailListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"reviewPic" : [PictureModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"reviewsId"    :   @"reviewId",
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


// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"reviewsId",
             @"userId",
             @"avatar",
             @"nickname",
             @"addTime",
             @"isFollow",
             @"content",
             @"reviewPic",
             @"likeCount",
             @"isLiked",
             @"topicList",
             @"replyCount"
             ];
}

@end
