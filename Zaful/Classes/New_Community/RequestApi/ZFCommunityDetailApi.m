
//
//  ZFCommunityDetailApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityDetailApi.h"

@interface ZFCommunityDetailApi () {
    NSString *_reviewId;
}

@end

@implementation ZFCommunityDetailApi
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
             @"type"        : @"9",
             @"directory"   : @"35",
             @"site"        : @"zafulcommunity",
             @"loginUserId" : USERID ?: @"0",
             @"reviewId"    : _reviewId
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
