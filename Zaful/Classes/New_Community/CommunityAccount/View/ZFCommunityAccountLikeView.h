//
//  ZFCommunityAccountLikeView.h
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFCommunityAccountLikesModel;

typedef void(^CommunityAccountLikeTopicCompletionHandler)(NSString *topic);

typedef void(^CommunityAccountLikeDetailCompletionHandler)(NSString *userId, NSString *reviewsId);

typedef void(^CommunityAccountLikeUserAccountCompletionHandler)(NSString *userId);

typedef void(^CommunityAccountLikeShareCompletionHandler)(ZFCommunityAccountLikesModel *model);


@interface ZFCommunityAccountLikeView : UICollectionViewCell
@property (nonatomic, copy) NSString                *userId;
@property (nonatomic, weak) UIViewController        *controller;
@property (nonatomic, copy) CommunityAccountLikeTopicCompletionHandler          communityAccountLikeTopicCompletionHandler;

@property (nonatomic, copy) CommunityAccountLikeDetailCompletionHandler         communityAccountLikeDetailCompletionHandler;

@property (nonatomic, copy) CommunityAccountLikeUserAccountCompletionHandler    communityAccountLikeUserAccountCompletionHandler;

@property (nonatomic, copy) CommunityAccountLikeShareCompletionHandler          communityAccountLikeShareCompletionHandler;

@end
