//
//  GoogleLoginApi.m
//  Zaful
//
//  Created by TsangFa on 2/5/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "GoogleLoginApi.h"

@implementation GoogleLoginApi
{
    NSMutableDictionary *_dict;
}

- (instancetype)initWithDict:(NSMutableDictionary *)dict {
    if (self = [super init]) {
        _dict = dict;
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
             @"action"       : @"User/googleLogin",
             @"sess_id"      : SESSIONID,
             @"email"        : NullFilter(_dict[@"email"]),
             @"googleId"     : NullFilter(_dict[@"googleId"]),
             @"sex"          : NullFilter(_dict[@"sex"]),
             @"access_token" : NullFilter(_dict[@"access_token"]),
             @"wj_linkid"    : [NSStringUtils getLkid]
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}



- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
