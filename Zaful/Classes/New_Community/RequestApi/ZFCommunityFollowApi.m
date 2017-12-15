


//
//  ZFCommunityFollowApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityFollowApi.h"

@interface ZFCommunityFollowApi () {
    NSInteger _followStatue;
    NSString *_followedUserId;
}
@end

@implementation ZFCommunityFollowApi
- (instancetype)initWithFollowStatue:(NSInteger)followStatue followedUserId:(NSString *)followedUserId
{
    if (self = [super init]) {
        _followedUserId = followedUserId;
        _followStatue = followStatue;
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
