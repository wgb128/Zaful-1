

//
//  ZFCommunityReviewsApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityReviewsApi.h"

@interface ZFCommunityReviewsApi () {
    NSInteger _curPage;
    NSString *_pageSize;
    NSString *_reviewId;
}
@end

@implementation ZFCommunityReviewsApi
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
             @"directory"   : @"38",
             @"site"        : @"zafulcommunity",
             @"loginUserId"    : USERID ?: @"0",
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