//
//  ZFCommunityMessageListCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFCommunityMessageModel;

typedef void(^CommunityMessageListFollowUserCompletionHandler)(NSString *userId);

typedef void(^CommunityMessageAccountDetailCompletioinHandler)(NSString *userId);

@interface ZFCommunityMessageListCell : UITableViewCell

@property (nonatomic, strong) ZFCommunityMessageModel       *model;

@property (nonatomic, copy) CommunityMessageListFollowUserCompletionHandler communityMessageListFollowUserCompletionHandler;

@property (nonatomic, copy) CommunityMessageAccountDetailCompletioinHandler communityMessageAccountDetailCompletioinHandler;
@end
