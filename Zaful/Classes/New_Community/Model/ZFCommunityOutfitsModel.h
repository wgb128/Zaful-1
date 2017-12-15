//
//  ZFCommunityOutfitsModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "id": "2039",	//评论id
 "user_id": "1428",	//用户id
 "property": "0",	//帖子的信息，0用户帖 1运营帖
 "title": "#1234 klsajflaksvk.ndvk\n",	//评论标题
 "content": "sdfajsdgl;kdklfjgal;dkjvskldfjvkl sjdklfvjadkl sdkj aj",	//评论内容
 "add_time": 1498682888,	//评论时间
 "site_version": "0",	//评论来源站点版本,1为android,2为ios
 "like_count": "2",	//点赞数
 "view_num": 864,	//评论被浏览的次数
 "avatar": "http://www.upload.com.trunk.cg.egomsl.com/upload/zaful/avatar/20170302/64DB2EA4AD2DC4320DF45220D4C0A50C.jpg",	//用户头像
 "nickname": "KKK165",	//昵称
 "sort": "1",	//社区排序
 "review_type": "1",	//帖子的类型，0普通帖 1穿搭帖
 "liked": 0,	//被点赞数
 "followed": 0,	//被关注数
 "reply_count": "3",	//回复数
 "pic": {
 "review_id": "2039",
 "small_pic": "http://www.upload.com.trunk.cg.egomsl.com/upload/zaful/review/20170628/thumb/5E882BE061D0A4A7469B9E320DBE185B_thumb.png",
 "big_pic": "http://www.upload.com.trunk.cg.egomsl.com/upload/zaful/review/20170628/5E882BE061D0A4A7469B9E320DBE185B_640-640.png",
 "origin_pic": "http://www.upload.com.trunk.cg.egomsl.com/upload/zaful/review/20170628/5E882BE061D0A4A7469B9E320DBE185B.png",
 "is_first_pic": "1",
 "width": "640",
 "height": "640"
 }
 */

@interface ZFCommunityOutfitsModel : NSObject
@property (nonatomic, copy) NSString        *reviewId;
@property (nonatomic, copy) NSString        *userId;
@property (nonatomic, copy) NSString        *propertyType;
@property (nonatomic, copy) NSString        *reviewTitle;
@property (nonatomic, copy) NSString        *reviewContent;
@property (nonatomic, copy) NSString        *reviewAddTime;
@property (nonatomic, copy) NSString        *siteVersion;
@property (nonatomic, copy) NSString        *likeCount;
@property (nonatomic, copy) NSString        *viewsCount;
@property (nonatomic, copy) NSString        *avatar;
@property (nonatomic, copy) NSString        *nikename;
@property (nonatomic, copy) NSString        *sort;
@property (nonatomic, copy) NSString        *reviewType;
@property (nonatomic, copy) NSString        *liked;
@property (nonatomic, copy) NSString        *followedCount;
@property (nonatomic, copy) NSString        *replyCount;
@property (nonatomic, copy) NSDictionary    *picInfo;
@end
