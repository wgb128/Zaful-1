//
//  ZFCommunityDetailModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFCommunityDetailModel : NSObject
@property (nonatomic, copy) NSString *avatar;//用户头像
@property (nonatomic, copy) NSString *userId;//当前回复用户的ID
@property (nonatomic, copy) NSString *nickname;//昵称
@property (nonatomic, copy) NSString *addTime;//评论时间
@property (nonatomic, assign) BOOL isFollow;//是否关注
@property (nonatomic, copy) NSString *content;//评论内容
@property (nonatomic, strong) NSArray *reviewPic;//图片
@property (nonatomic, strong) NSArray *likeUsers;//被关注
@property (nonatomic, copy) NSString *likeCount;//点赞数
@property (nonatomic, assign) BOOL isLiked;//是否点赞
@property (nonatomic, copy) NSString *replyCount;//评论数
@property (nonatomic, strong) NSArray *labelInfo;//标签数组
@property (nonatomic, strong) NSArray *goodsInfos;//商品推荐
@property (nonatomic, copy) NSString *type;//类型
@property (nonatomic, copy) NSString *sort;//热榜

/*
 *
 *   -> 未返回这个字段 -> 这个字段是自己添加的
 *  从首页获取 发通知需要到
 *
 */
@property (nonatomic, copy) NSString *reviewsId;//评论ID
@end
