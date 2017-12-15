//
//  StyleHeaderView.h
//  Yoshop
//
//  Created by zhaowei on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoModel;
typedef void (^ButtonTouchBlock)(UserInfoModel *userInfoModel);
@interface StyleHeaderView : UIView
@property (nonatomic,copy) ButtonTouchBlock followingTouchBlock;
@property (nonatomic,copy) ButtonTouchBlock followersTouchBlock;
@property (nonatomic,copy) ButtonTouchBlock followTouchBlock;
@property (nonatomic,copy) ButtonTouchBlock beLikedTouchBlock;
@property (nonatomic,strong) UserInfoModel *userInfoModel;
@end
