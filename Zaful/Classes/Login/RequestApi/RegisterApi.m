//
//  RegisterApi.m
//  Zaful
//
//  Created by ZJ1620 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "RegisterApi.h"
#import <AdSupport/AdSupport.h>

@implementation RegisterApi
{
    NSString *_email;
    NSString *_password;
    NSString *_confirmPassword;
    NSString *_sex;
    NSString *_issubscribe;
}

-(instancetype)initWithEmail:(NSString *)email
                    password:(NSString *)password
             confirmPassword:(NSString *)confirmPassword
                         sex:(NSString *)sex
                 issubscribe:(NSString *)issubscribe
{
    
    self = [super init];
    if (self) {
        _email = email;
        _password = password;
        _confirmPassword = confirmPassword;
        _sex = sex;
        _issubscribe = issubscribe;
    }
    return self;
}

- (BOOL)enableCache {
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
             @"action"       :@"user/register",
             @"repassword"   :_confirmPassword,
             @"email"        : _email,
             @"password"     : _password,
             @"sex"          : _sex,
             @"sess_id"      : SESSIONID,
             @"issubscribe"  : _issubscribe,
             @"wj_linkid"    : [NSStringUtils getLkid],
             @"af_uid"       :[AppsFlyerTracker sharedTracker].getAppsFlyerUID,
             @"ad_id"        :[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
