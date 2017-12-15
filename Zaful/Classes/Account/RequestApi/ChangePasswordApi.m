//
//  ChangePasswordApi.m
//  Dezzal
//
//  Created by ZJ1620 on 16/8/6.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "ChangePasswordApi.h"

@implementation ChangePasswordApi
{
    NSString *_confirmPassWord;
    NSString *_oldPassword;
    NSString *_newPassword;
    NSString *_userId;
    
}
- (instancetype)initWithChangePasswordWith:(NSString *)oldPassword newPassword:(NSString *)newPassword confirmPassWord:(NSString *)confirmPassWord userId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _confirmPassWord = confirmPassWord;
        _newPassword = newPassword;
        _oldPassword = oldPassword;
        _userId = userId;
    }
    return self;
}

- (BOOL)enableCache {
    return YES;
}

- (BOOL)enableAccessory {
    return YES;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)requestPath {
    
    return [NSStringUtils buildRequestPath:@""];
}


- (id)requestParameters {
    
    return @{
             @"action"      :   @"user/edit_password",
             @"token"       :   TOKEN,
             @"old_password":   _oldPassword,
             @"password"    :   _newPassword,
             @"repassword"  :   _confirmPassWord
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
