//
//  CommunityDetailReviewsListMode.h
//  Yoshop
//
//  Created by huangxieyue on 16/7/15.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityDetailReviewsListMode : NSObject

@property (nonatomic,copy) NSString *nickname;//昵称
@property (nonatomic,copy) NSString *content;//评论内容
@property (nonatomic,copy) NSString *userId;//评论用户ID
@property (nonatomic,copy) NSString *avatar;//用户头像
@property (nonatomic,copy) NSString *reviewId;//评论ID
@property (nonatomic,copy) NSString *isSecondFloorReply;//是否被回复
@property (nonatomic,copy) NSString *replyId;//回复ID
@property (nonatomic,copy) NSString *replyAvatar;//回复头像
@property (nonatomic,copy) NSString *replyUserId;//回复用户ID
@property (nonatomic,copy) NSString *replyNickName;//回复昵称

@end
