//
//  ZFCommunityFavesListCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCommunityFavesItemModel;

typedef void(^CommunityFavesShareCompletionHandler)(ZFCommunityFavesItemModel  *model);

typedef void(^CommunityFavesFollowCompletionHandler)(void);

typedef void(^CommunityFavesReviewCompletionHandler)(void);

typedef void(^CommunityFavesTopicDetailCompletionHandler)(NSString *topic);

typedef void(^CommunityFavesLikeCompletionHandler)(ZFCommunityFavesItemModel *model);

typedef void(^CommunityFavesUserAccountCompletionHandler)(NSString *userId);
@interface ZFCommunityFavesListCell : UITableViewCell

@property (nonatomic, strong) ZFCommunityFavesItemModel       *model;

@property (nonatomic, copy) CommunityFavesShareCompletionHandler        communityFavesShareCompletionHandler;
@property (nonatomic, copy) CommunityFavesFollowCompletionHandler       communityFavesFollowCompletionHandler;
@property (nonatomic, copy) CommunityFavesReviewCompletionHandler       communityFavesReviewCompletionHandler;
@property (nonatomic, copy) CommunityFavesTopicDetailCompletionHandler  communityFavesTopicDetailCompletionHandler;
@property (nonatomic, copy) CommunityFavesLikeCompletionHandler         communityFavesLikeCompletionHandler;
@property (nonatomic, copy) CommunityFavesUserAccountCompletionHandler  communityFavesUserAccountCompletionHandler;
@end
