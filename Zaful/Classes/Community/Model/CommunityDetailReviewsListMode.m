//
//  CommunityDetailReviewsListMode.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/15.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CommunityDetailReviewsListMode.h"

@implementation CommunityDetailReviewsListMode

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"userId",
             @"content",
             @"avatar",
             @"nickname",
             @"reviewId",
             @"isSecondFloorReply",
             @"replyId",
             @"replyAvatar",
             @"replyUserId",
             @"replyNickName"
             ];
}

@end
