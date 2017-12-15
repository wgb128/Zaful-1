//
//  FavesItemsModel.m
//  Zaful
//
//  Created by huangxieyue on 16/11/26.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "FavesItemsModel.h"
#import "PictureModel.h"

@implementation FavesItemsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
                 @"reviewPic" : [PictureModel class],
                 };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
                 @"reviewId",
                 @"userId",
                 @"avatar",
                 @"nickname",
                 @"addTime",
                 @"isFollow",
                 @"content",
                 @"topicList",
                 @"reviewPic",
                 @"likeCount",
                 @"isLiked",
                 @"replyCount",
                 @"topicList",
                 @"sort"
                 ];
}

@end
