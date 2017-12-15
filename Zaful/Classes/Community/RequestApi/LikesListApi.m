//
//  LikesListApi.m
//  Yoshop
//
//  Created by Stone on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "LikesListApi.h"

@implementation LikesListApi
{
    NSString *_curPage;
    NSString *_userId;
    NSString *_rid;
}

- (instancetype)initWithRid:(NSString *)rid curPage:(NSString *)curPage userId:(NSString *)userId
{
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
