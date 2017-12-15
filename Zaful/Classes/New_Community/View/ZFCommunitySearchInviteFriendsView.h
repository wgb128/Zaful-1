//
//  ZFCommunitySearchInviteFriendsView.h
//  Zaful
//
//  Created by liuxi on 2017/7/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InviteContactCompletionHandler)(void);
typedef void(^InviteFacebookCompletionHandler)(void);

@interface ZFCommunitySearchInviteFriendsView : UIView

@property (nonatomic, copy) InviteContactCompletionHandler      inviteContactCompletionHandler;
@property (nonatomic, copy) InviteFacebookCompletionHandler     inviteFacebookCompletionHandler;

@end
