//
//  ZFCommunityExploreVideosCell.h
//  Zaful
//
//  Created by liuxi on 2017/7/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCommunityExploreModel;

typedef void(^CommunityMoreVideoCompletionHandler)(void);
typedef void(^CommunityMoreVideoSeeAllCompletionHandler)(void);
typedef void(^CommunityMoreVideoDetailCompletionHandler)(NSString *videoId);

@interface ZFCommunityExploreVideosCell : UITableViewCell
@property (nonatomic, strong) ZFCommunityExploreModel       *model;

@property (nonatomic, copy) CommunityMoreVideoCompletionHandler         communityMoreVideoCompletionHandler;
@property (nonatomic, copy) CommunityMoreVideoSeeAllCompletionHandler   communityMoreVideoSeeAllCompletionHandler;
@property (nonatomic, copy) CommunityMoreVideoDetailCompletionHandler   communityMoreVideoDetailCompletionHandler;
@end
