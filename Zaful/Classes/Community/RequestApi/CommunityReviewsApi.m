//
//  CommunityReviewsApi.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/15.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CommunityReviewsApi.h"

@implementation CommunityReviewsApi {
    NSInteger _curPage;
    NSString *_pageSize;
    NSString *_reviewId;
}

- (instancetype)initWithcurPage:(NSInteger)curPage pageSize:(NSString*)pageSize reviewId:(NSString *)reviewId {
    if (self = [super init]) {
        _curPage = curPage;
        _pageSize = pageSize;
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
             @"directory"   : @"38",
             @"site"        : @"zafulcommunity",
             @"loginUserId"    : USERID,
             
             @"pageSize" : _pageSize,
             @"curPage" : @(_curPage),
             @"reviewId"    : _reviewId,
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
