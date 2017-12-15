//
//  ZFCommunityAccountShowsModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureModel.h"

@interface ZFCommunityAccountShowsModel : NSObject
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
