//
//  ZFCommunityFavesListView.h
//  Zaful
//
//  Created by liuxi on 2017/7/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFCommunityFavesItemModel;

typedef void(^CommunityFavesListTopicCompletionHandler)(NSString *topic);
typedef void(^CommunityFavesListDetailCompletionHandler)(NSString *userId, NSString *reviewId);
typedef void(^CommunityFavesListShareCompletionHandler)(ZFCommunityFavesItemModel *model);
typedef void(^CommunityFavesUserAccountCompletionHandler)(NSString *userId);
typedef void(^CommunityFavesAddMoreFriendsCompletionHandler)(void);

@interface ZFCommunityFavesListView : UICollectionViewCell
@property (nonatomic, weak) UIViewController                *controller;

@property (nonatomic, copy) CommunityFavesListTopicCompletionHandler        communityFavesListTopicCompletionHandler;
@property (nonatomic, copy) CommunityFavesListDetailCompletionHandler       communityFavesListDetailCompletionHandler;
@property (nonatomic, copy) CommunityFavesListShareCompletionHandler        communityFavesListShareCompletionHandler;
@property (nonatomic, copy) CommunityFavesUserAccountCompletionHandler      communityFavesUserAccountCompletionHandler;
@property (nonatomic, copy) CommunityFavesAddMoreFriendsCompletionHandler   communityFavesAddMoreFriendsCompletionHandler;
@end
