//
//  UserInfoModel.h
//  Yoshop
//
//  Created by zhaowei on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) BOOL isFollow;
@end
