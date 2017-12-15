//
//  ZFCommunityAccountInfoView.h
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCommunityAccountInfoModel;

typedef void(^BackButtonActionCompletionHandler)(void);

typedef void(^MessageButtonActionCompletionHandler)(void);

typedef void(^TipsButtonActionCompletionHandler)(void);

typedef void(^FollowingButtonActionCompletionHandler)(void);

typedef void(^FollowerButtonActionCompletionHandler)(void);

typedef void(^CommunityAccountFollowCompletionHandler)(ZFCommunityAccountInfoModel *model);

@interface ZFCommunityAccountInfoView : UIView

@property (nonatomic, strong) ZFCommunityAccountInfoModel           *model;

@property (nonatomic, assign) BOOL                                  isFollow;

@property (nonatomic, copy) NSString                                *messageCount;

@property (nonatomic, copy) BackButtonActionCompletionHandler       backButtonActionCompletionHandler;

@property (nonatomic, copy) MessageButtonActionCompletionHandler    messageButtonActionCompletionHandler;

@property (nonatomic, copy) TipsButtonActionCompletionHandler       tipsButtonActionCompletionHandler;

@property (nonatomic, copy) FollowingButtonActionCompletionHandler  followingButtonActionCompletionHandler;

@property (nonatomic, copy) FollowerButtonActionCompletionHandler   followerButtonActionCompletionHandler;

@property (nonatomic, copy) CommunityAccountFollowCompletionHandler communityAccountFollowCompletionHandler;
@end
