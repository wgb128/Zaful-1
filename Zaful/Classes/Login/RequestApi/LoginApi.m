//
//  LoginApi.m
//  Zaful
//
//  Created by ZJ1620 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "LoginApi.h"

@implementation LoginApi {
    
    NSString *_email;
    NSString *_password;
}

- (instancetype)initWithEmail:(NSString *)email password:(NSString *)password {
    
    self = [super init];
    if (self) {
        _email = email;
        _password = password;
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
             @"action"       : @"user/sign",
             @"sess_id"      : SESSIONID,
             @"email"        : _email,
             @"password"     : _password
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}



- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
