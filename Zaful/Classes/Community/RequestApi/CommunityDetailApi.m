//
//  CommunityDetailApi.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/14.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CommunityDetailApi.h"

@implementation CommunityDetailApi {
    NSString *_reviewId;
}

- (instancetype)initWithReviewId:(NSString*)reviewId {
    if (self = [super init]) {
        _reviewId = reviewId;
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
             @"type"        : @"9",
             @"directory"   : @"35",
             @"site"        : @"zafulcommunity",
             @"loginUserId" : USERID,
             @"reviewId" : _reviewId,
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
