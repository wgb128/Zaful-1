


//
//  ZFCommunityUserInfoApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityUserInfoApi.h"

@interface ZFCommunityUserInfoApi () {
    NSString *_userid;
}

@end

@implementation ZFCommunityUserInfoApi
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
             @"userId" : _userid ?: @"0",
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
