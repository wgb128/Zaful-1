


//
//  ZFCommunityLikeApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityLikeApi.h"

@interface ZFCommunityLikeApi (){
    NSInteger _flag;
    NSString *_reviewId;
}

@end

@implementation ZFCommunityLikeApi

- (instancetype)initWithReviewId:(NSString *)reviewId flag:(NSInteger)flag {
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
