//
//  ZFCommunityFavesItemModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureModel.h"

@interface ZFCommunityFavesItemModel : NSObject
@property (nonatomic, copy) NSString *reviewId;//评论ID
@property (nonatomic, copy) NSString *userId;//用户ID
@property (nonatomic, copy) NSString *avatar;//用户头像
@property (nonatomic, copy) NSString *nickname;//昵称
@property (nonatomic, copy) NSString *addTime;//评论时间
@property (nonatomic, assign) BOOL isFollow;//是否关注
@property (nonatomic, copy) NSString *content;//评论内容
@property (nonatomic, strong) NSArray *topicList;//标签数组
@property (nonatomic, strong) NSArray<PictureModel *> *reviewPic;//图片数组
@property (nonatomic, copy) NSString *likeCount;//点赞数
@property (nonatomic, assign) BOOL isLiked;//是否点赞
@property (nonatomic, copy) NSString *replyCount;//评论数
@property (nonatomic, copy) NSString *sort;//是否显示top

@end
