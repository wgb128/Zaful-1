


//
//  ZFCommunityFollowListApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityFollowListApi.h"

@interface ZFCommunityFollowListApi ()  {
    NSString *_curPage;
    NSString *_userId;
    ZFUserListType _userListType;
    
}
@end

@implementation ZFCommunityFollowListApi

- (instancetype)initWithCurPage:(NSString *)curPage userListType:(ZFUserListType)userListType userId:(NSString *)userId
{
    if (self = [super init]) {
        _curPage = curPage;
        _userId = userId;
        _userListType = userListType;
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
             @"directory"   : @"37",
             @"site"        : @"zafulcommunity",
             @"followType"  : @(_userListType),
             @"userId"      : _userId,
             @"loginUserId" : USERID,
             @"pageSize"    : @"15",
             @"curPage"     : _curPage
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
