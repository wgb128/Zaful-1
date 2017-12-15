//
//  ZFCommunityLikesListCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCommunityFollowModel;

typedef void(^CommunityFollowUserCompletionHandler)(ZFCommunityFollowModel *model);

@interface ZFCommunityLikesListCell : UITableViewCell
@property (nonatomic, strong) ZFCommunityFollowModel        *model;
@property (nonatomic, copy) CommunityFollowUserCompletionHandler        communityFollowUserCompletionHandler;
@end
