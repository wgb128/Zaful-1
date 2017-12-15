//
//  ZFCommunityAccountShowView.h
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFCommunityAccountShowsModel;

typedef void(^CommunityAccountShowTopicCompletionHandler)(NSString *topic);

typedef void(^CommunityAccountShowShareCompletionHandler)(ZFCommunityAccountShowsModel *model);

typedef void(^CommunityAccountShowDetailCompletionHandler)(NSString *userId, NSString *reviewsId);

typedef void(^CommunityAccountShowUserAccountCompletionHandler)(NSString *userId);

@interface ZFCommunityAccountShowView : UICollectionViewCell
@property (nonatomic, weak) UIViewController    *controller;
@property (nonatomic, copy) NSString            *userId;

@property (nonatomic, copy) CommunityAccountShowTopicCompletionHandler          communityAccountShowTopicCompletionHandler;

@property (nonatomic, copy) CommunityAccountShowShareCompletionHandler          communityAccountShowShareCompletionHandler;

@property (nonatomic, copy) CommunityAccountShowDetailCompletionHandler         communityAccountShowDetailCompletionHandler;

@property (nonatomic, copy) CommunityAccountShowUserAccountCompletionHandler    communityAccountShowUserAccountCompletionHandler;
@end
