//
//  StyleLikesModel.h
//  Yoshop
//
//  Created by zhaowei on 16/7/13.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StyleLikesModel : NSObject
@property (nonatomic,copy) NSString *addTime;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) BOOL isFollow;
@property (nonatomic,assign) BOOL isLiked;
@property (nonatomic,copy) NSString *likeCount;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *replyCount;
@property (nonatomic,copy) NSString *reviewId;
@property (nonatomic,strong) NSArray *reviewPic;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,strong) NSArray *topicList;
@end
