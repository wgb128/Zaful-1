//
//  FollowApi.m
//  Yoshop
//
//  Created by Stone on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "FollowApi.h"

@implementation FollowApi
{
    NSInteger _followStatue;
    NSString *_followedUserId;
}

- (instancetype)initWithFollowStatue:(NSInteger)followStatue followedUserId:(NSString *)followedUserId
{
    if (self = [super init]) {
        _followedUserId = followedUserId ?: @"0";
        _followStatue = followStatue;
    }
    return self;
}

- (BOOL)enableCache {
    return YES;
}

- (BOOL)enableAccessory {
    return NO;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)baseURL {
    return CommunityURL;
}

- (NSString *)requestPath {
    return @"";
}

- (id)requestParameters {
    return @{
             @"type"           : @"2",
             @"site"           : @"zafulcommunity",
             @"loginUserId"    : USERID,
             @"flag"           : @(_followStatue),  // 1关注 0取消关注
             @"followedUserId" : _followedUserId
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
