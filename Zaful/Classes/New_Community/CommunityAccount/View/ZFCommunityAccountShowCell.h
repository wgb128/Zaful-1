//
//  ZFCommunityAccountShowCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCommunityAccountShowsModel;

typedef void(^CommunityAccountShowsTopicCompletionHandler)(NSString *topic);

typedef void(^CommunityAccountShowsLikeCompletionHandler)(ZFCommunityAccountShowsModel *model);

typedef void(^CommunityAccountShowsDeleteCompletionHandler)(ZFCommunityAccountShowsModel *model);

typedef void(^CommunityAccountShowsShareCompletionHandler)(ZFCommunityAccountShowsModel *model);

typedef void(^CommunityAccountShowsUserAccountCompletionHandler)(NSString *userId);

typedef void(^CommunityAccountShowsReviewCompletionHandler)(void);

@interface ZFCommunityAccountShowCell : UITableViewCell
@property (nonatomic, strong) ZFCommunityAccountShowsModel      *model;

@property (nonatomic, copy) CommunityAccountShowsTopicCompletionHandler         communityAccountShowsTopicCompletionHandler;

@property (nonatomic, copy) CommunityAccountShowsLikeCompletionHandler          communityAccountShowsLikeCompletionHandler;

@property (nonatomic, copy) CommunityAccountShowsDeleteCompletionHandler        communityAccountShowsDeleteCompletionHandler;

@property (nonatomic, copy) CommunityAccountShowsShareCompletionHandler         communityAccountShowsShareCompletionHandler;

@property (nonatomic, copy) CommunityAccountShowsUserAccountCompletionHandler   communityAccountShowsUserAccountCompletionHandler;

@property (nonatomic, copy) CommunityAccountShowsReviewCompletionHandler        communityAccountShowsReviewCompletionHandler;
@end
