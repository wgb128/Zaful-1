//
//  AccountManager.h
//  Yoshop
//
//  Created by zhaowei on 16/5/31.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountModel.h"

@interface AccountManager : NSObject

@property (nonatomic,strong) AccountModel *account;

// 是否登录
@property(nonatomic,assign)BOOL isSignIn;

+ (AccountManager *)sharedManager;

- (void)updateUserInfo:(AccountModel *)account;

/**
 *  编辑个人资料时,更改部分item ,FirstName...
 */
- (void)editUserSomeItems:(AccountModel *)account;

/**
 *  刷新用户头像
 *
 *  @param url 返回的url链接
 */
- (void)updateUserAvatar:(NSString *)url;

/**
 *  刷新用户头像
 *
 *  @param url 返回的url链接
 */
- (void)updateUserDefaultAddressId:(NSString *)addressId;

- (void)clearUserInfo;

- (void)clearWebCookie;

- (NSString *)userId;

- (NSString *)token;

- (NSString *)defaultAddressId;

- (NSString *)sessionId;

@end
