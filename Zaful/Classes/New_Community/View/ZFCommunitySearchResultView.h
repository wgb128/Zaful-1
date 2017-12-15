//
//  ZFCommunitySearchResultView.h
//  Zaful
//
//  Created by liuxi on 2017/7/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommunityUserFollowCompletionHandler)(NSString *userId);

typedef void(^CommunitySearchResultUserInfoCompletionHandler)(NSString *userId);

@interface ZFCommunitySearchResultView : UIView

@property (nonatomic, copy) NSString            *searchKey;

@property (nonatomic, copy) CommunityUserFollowCompletionHandler            communityUserFollowCompletionHandler;

@property (nonatomic, copy) CommunitySearchResultUserInfoCompletionHandler  communitySearchResultUserInfoCompletionHandler;
@end
