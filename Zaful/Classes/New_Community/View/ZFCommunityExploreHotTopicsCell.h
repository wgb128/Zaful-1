//
//  ZFCommunityExploreHotTopicsCell.h
//  Zaful
//
//  Created by liuxi on 2017/7/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCommunityExploreModel;

typedef void(^CommunityMoreTopicsCompletionHandler)(void);

typedef void(^CommunityExploreHotTopicDetailCompletionHandler)(NSString *topicId);

@interface ZFCommunityExploreHotTopicsCell : UITableViewCell

@property (nonatomic, strong) ZFCommunityExploreModel       *model;

@property (nonatomic, copy) CommunityMoreTopicsCompletionHandler        communityMoreTopicsCompletionHandler;

@property (nonatomic, copy) CommunityExploreHotTopicDetailCompletionHandler communityExploreHotTopicDetailCompletionHandler;
@end
