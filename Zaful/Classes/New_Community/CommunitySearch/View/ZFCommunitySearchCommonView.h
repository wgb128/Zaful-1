//
//  ZFCommunitySearchCommonView.h
//  Zaful
//
//  Created by liuxi on 2017/7/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommunitySuggestedUserInfoCompletionHandler)(NSString *userId);

typedef void(^CommunityInviteFacebookCompletionHandler)(void);

typedef void(^CommunityInviteContactsCompletionHandler)(void);
@interface ZFCommunitySearchCommonView : UIView

@property (nonatomic, assign, getter=isNoResultTips) BOOL          noResultTips;

@property (nonatomic, copy) CommunitySuggestedUserInfoCompletionHandler         communitySuggestedUserInfoCompletionHandler;

@property (nonatomic, copy) CommunityInviteFacebookCompletionHandler    communityInviteFacebookCompletionHandler;

@property (nonatomic, copy) CommunityInviteContactsCompletionHandler    communityInviteContactsCompletionHandler;
@end
