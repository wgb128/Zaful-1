//
//  ZFCommunityExploreListView.h
//  Zaful
//
//  Created by liuxi on 2017/7/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BannerModel;
@class ZFCommunityFavesItemModel;

typedef void(^CommunityExploreMoreVideoCompletionHandler)(void);
typedef void(^CommunityExploreMoreTopicCompletionHandler)(void);
typedef void(^CommunityExploreBannerCompletionHandler)(BannerModel *bannerModel);
typedef void(^CommunityExploreTopicCompletionHandler)(NSString *topic);
typedef void(^CommunityExploreMoreVideoDetailCompletionHandler)(NSString *videoId);
typedef void(^CommunityExploreShareCompletionHandler)(ZFCommunityFavesItemModel *model);
typedef void(^CommunityExploreDetailCompletionHandler)(NSString *userId, NSString *reviewId);
typedef void(^CommunityExploreUserAccountCompletionHandler)(NSString *userId);
@interface ZFCommunityExploreListView : UICollectionViewCell

@property (nonatomic, weak) UIViewController        *controller;

@property (nonatomic, copy) CommunityExploreMoreVideoCompletionHandler  communityExploreMoreVideoCompletionHandler;

@property (nonatomic, copy) CommunityExploreMoreTopicCompletionHandler  communityExploreMoreTopicCompletionHandler;

@property (nonatomic, copy) CommunityExploreTopicCompletionHandler      communityExploreTopicCompletionHandler;

@property (nonatomic, copy) CommunityExploreMoreVideoDetailCompletionHandler    communityExploreMoreVideoDetailCompletionHandler;

@property (nonatomic, copy) CommunityExploreBannerCompletionHandler     communityExploreBannerCompletionHandler;

@property (nonatomic, copy) CommunityExploreShareCompletionHandler      communityExploreShareCompletionHandler;

@property (nonatomic, copy) CommunityExploreDetailCompletionHandler     communityExploreDetailCompletionHandler;

@property (nonatomic, copy) CommunityExploreUserAccountCompletionHandler    communityExploreUserAccountCompletionHandler;
@end
