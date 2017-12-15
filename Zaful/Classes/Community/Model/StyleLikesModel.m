//
//  StyleLikesModel.m
//  Yoshop
//
//  Created by zhaowei on 16/7/13.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "StyleLikesModel.h"

@implementation StyleLikesModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"nickName" : @"nickname",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"reviewPic" : [NSDictionary class]
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
