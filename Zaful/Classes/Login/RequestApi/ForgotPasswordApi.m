//
//  ForgotPasswordApi.m
//  Zaful
//
//  Created by ZJ1620 on 16/9/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "ForgotPasswordApi.h"

@implementation ForgotPasswordApi

{
    NSString *_email;
}

-(instancetype)initWithEmail:(NSString *)email
{
    
    self = [super init];
    if (self) {
        _email = email;
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
             @"action"       :@"user/forget_password",
             @"email"        : _email
             };
    
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
