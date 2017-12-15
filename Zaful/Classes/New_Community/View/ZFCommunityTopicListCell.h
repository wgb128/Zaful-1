//
//  ZFCommunityTopicListCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCommunityTopicModel;

typedef void(^CommunityTopicListTopicCompletionHandler)(NSString *topic);

typedef void(^CommunityTopicListFollowCompletionHandler)(ZFCommunityTopicModel *model);

typedef void(^CommunityTopicListLikeCompletionHandler)(ZFCommunityTopicModel *model);

typedef void(^CommunityTopicListShareCompletionHandler)(ZFCommunityTopicModel *model);

typedef void(^CommunityTopicListAccountCompletionHandler)(ZFCommunityTopicModel *model);

typedef void(^CommunityTopicListReviewCompletionHandler)(void);

@interface ZFCommunityTopicListCell : UITableViewCell
@property (nonatomic, strong) ZFCommunityTopicModel     *model;

@property (nonatomic, copy) CommunityTopicListTopicCompletionHandler        communityTopicListTopicCompletionHandler;

@property (nonatomic, copy) CommunityTopicListFollowCompletionHandler       communityTopicListFollowCompletionHandler;

@property (nonatomic, copy) CommunityTopicListLikeCompletionHandler         communityTopicListLikeCompletionHandler;

@property (nonatomic, copy) CommunityTopicListShareCompletionHandler        communityTopicListShareCompletionHandler;

@property (nonatomic, copy) CommunityTopicListAccountCompletionHandler      communityTopicListAccountCompletionHandler;

@property (nonatomic, copy) CommunityTopicListReviewCompletionHandler       communityTopicListReviewCompletionHandler;
@end
