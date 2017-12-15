//
//  ZFCommunityTopicModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PictureModel;

@interface ZFCommunityTopicModel : NSObject
@property (nonatomic, copy) NSString *addTime;//评论时间
@property (nonatomic, copy) NSString *avatar;//用户头像
@property (nonatomic, copy) NSString *content;//评论内容
@property (nonatomic, assign) BOOL isFollow;//是否关注
@property (nonatomic, assign) BOOL isLiked;//是否点赞
@property (nonatomic, copy) NSString *likeCount;//点赞数
@property (nonatomic, copy) NSString *nickname;//昵称
@property (nonatomic, copy) NSString *replyCount;//评论数
@property (nonatomic, copy) NSString *reviewId;//评论ID
@property (nonatomic, strong) NSArray<PictureModel *> *reviewPic;//图片
@property (nonatomic, strong) NSArray *topicList;//话题标签
@property (nonatomic, copy) NSString *userId;//当前回复用户的ID
@end
