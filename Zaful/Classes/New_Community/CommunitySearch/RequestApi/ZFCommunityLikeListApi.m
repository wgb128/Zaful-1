

//
//  ZFCommunityLikeListApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityLikeListApi.h"

@interface ZFCommunityLikeListApi () {
    NSString *_curPage;
    NSString *_userId;
    NSString *_rid;
}

@end

@implementation ZFCommunityLikeListApi

- (instancetype)initWithRid:(NSString *)rid curPage:(NSString *)curPage userId:(NSString *)userId {
    if (self = [super init]) {
        _curPage = curPage;
        _userId = userId;
        _rid = rid;
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
             @"site"        : @"zafulcommunity",
             @"directory"   : @"36",
             @"loginUserId" : USERID,
             @"pageSize"    : @"15",
             @"curPage"     : _curPage,
             @"reviewId"    : _rid
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
