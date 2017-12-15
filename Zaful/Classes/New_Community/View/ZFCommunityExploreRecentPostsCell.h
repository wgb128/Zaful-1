//
//  ZFCommunityExploreRecentPostsCell.h
//  Zaful
//
//  Created by liuxi on 2017/7/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFCommunityFavesItemModel;

typedef void(^CommunityExploreShareCompletionHandler)(ZFCommunityFavesItemModel *model);

typedef void(^CommunityExploreFollowCompletionHandler)(ZFCommunityFavesItemModel *model);

typedef void(^CommunityExploreReviewCompletionHandler)(void);

typedef void(^CommunityExploreTopicDetailCompletionHandler)(NSString *topic);

typedef void(^CommunityExploreLikeCompletionHandler)(ZFCommunityFavesItemModel *model);

typedef void(^CommunityExploreUserAccountCompletionHandler)(NSString *userId);

@interface ZFCommunityExploreRecentPostsCell : UITableViewCell

@property (nonatomic, strong) ZFCommunityFavesItemModel       *model;

@property (nonatomic, copy) CommunityExploreTopicDetailCompletionHandler    communityExploreTopicDetailCompletionHandler;

@property (nonatomic, copy) CommunityExploreShareCompletionHandler          communityExploreShareCompletionHandler;

@property (nonatomic, copy) CommunityExploreFollowCompletionHandler         communityExploreFollowCompletionHandler;

@property (nonatomic, copy) CommunityExploreReviewCompletionHandler         communityExploreReviewCompletionHandler;

@property (nonatomic, copy) CommunityExploreLikeCompletionHandler           communityExploreLikeCompletionHandler;

@property (nonatomic, copy) CommunityExploreUserAccountCompletionHandler    communityExploreUserAccountCompletionHandler;
@end
