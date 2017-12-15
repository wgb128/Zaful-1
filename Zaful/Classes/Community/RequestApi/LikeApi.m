//
//  LikeApi.m
//  Yoshop
//
//  Created by Stone on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "LikeApi.h"

@implementation LikeApi
{
    NSInteger _flag;
    NSString *_reviewId;
}

- (instancetype)initWithReviewId:(NSString *)reviewId flag:(NSInteger)flag
{
    if (self = [super init]) {
        _reviewId = reviewId;
        _flag = flag;
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
             @"type"      : @"4",
             @"site"      : @"zafulcommunity",
             @"userId"    : USERID,
             @"reviewId"  : _reviewId,
             @"flag"      : @(_flag),  // 0为点赞;1为取消点赞
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
