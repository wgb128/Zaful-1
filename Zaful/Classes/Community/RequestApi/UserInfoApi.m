//
//  UserInfoApi.m
//  Yoshop
//
//  Created by zhaowei on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "UserInfoApi.h"

@implementation UserInfoApi {
    NSString *_userid;
}

- (instancetype)initWithUserid:(NSString *)userid {
    self = [super init];
    if (self) {
        _userid = userid;
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
    return ENCPATH;
}

-(BOOL)encryption {
    return NO;
}

- (id)requestParameters {
    
    return @{
             @"action"      : @"Community/index",
             @"is_enc"      : @"0",
             @"app_type": @"2",
             @"site" : @"zafulcommunity" ,
             @"type" : @"9",
             @"directory" : @"34",
             @"userId" : _userid,
             @"loginId" : USERID
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
