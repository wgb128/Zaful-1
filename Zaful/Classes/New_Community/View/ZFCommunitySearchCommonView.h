//
//  ZFCommunitySearchCommonView.h
//  Zaful
//
//  Created by liuxi on 2017/7/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommunitySearchResultUserInfoCompletionHandler)(NSString *userId);
typedef void(^CommunityUserFollowCompletionHandler)(NSString *userId);

@interface ZFCommunitySearchCommonView : UIView

@property (nonatomic, assign, getter=isNoResultTips) BOOL          noResultTips;

@property (nonatomic, copy) CommunitySearchResultUserInfoCompletionHandler      communitySearchResultUserInfoCompletionHandler;

@property (nonatomic, copy) CommunityUserFollowCompletionHandler                communityUserFollowCompletionHandler;
@end
