//
//  ZFCollectionLikeApi.m
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCollectionLikeApi.h"

@implementation ZFCollectionLikeApi {
    NSString *_user_id;//用户ID
    NSInteger _page;//当前页
    NSInteger _size;//每页显示数量
}

- (instancetype)initWithCollectionWith:(NSString *)userId page:(NSInteger)page pageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        _user_id = userId;
        _page = page;
        _size = pageSize;
    }
    return self;
}


- (BOOL)enableCache {
    return YES;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)requestPath {
    return [NSStringUtils buildRequestPath:@""];
}

- (id)requestParameters {
    
    if ([AccountManager sharedManager].isSignIn) {
        return @{
                 @"page"        : @(_page),
                 @"action"      : @"collection/get_collection",
                 @"token"       : [AccountManager sharedManager].account.token
                 };
    }else
    {
        return @{
                 @"page"        : @(_page),
                 @"action"      : @"collection/get_collection",
                 @"sess_id"     : SESSIONID
                 };
    }
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
