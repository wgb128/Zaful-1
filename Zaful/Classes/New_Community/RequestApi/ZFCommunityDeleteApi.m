

//
//  ZFCommunityDeleteApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityDeleteApi.h"

@interface ZFCommunityDeleteApi () {
    NSString *_deleteId;
    NSString *_userId;
}

@end

@implementation ZFCommunityDeleteApi

- (instancetype)initWithDeleteId:(NSString *)deleteId andUserId:(NSString *)userId
{
    if (self = [super init]) {
        _deleteId = deleteId;
        _userId = userId;
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
             @"directory"   : @"55",
             @"userId"      : _userId ?: @"0",
             @"loginUserId" : USERID ?: @"0",
             @"isDelete"    : @"1",
             @"reviewId"    : _deleteId
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
