//
//  ZFCollectionDeleteApi.m
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCollectionDeleteApi.h"

@implementation ZFCollectionDeleteApi {
    NSString *_user_id;//用户ID
    NSString *_goodsId;//
}

- (instancetype)initDeleteCollectionWith:(NSString *)userId goodsId:(NSString *)goodsId
{
    self = [super init];
    if (self) {
        _user_id = userId;
        _goodsId = goodsId;
        
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
                 @"goods_id"    : _goodsId,
                 @"action"      : @"collection/del_collection",
                 @"token"       : [AccountManager sharedManager].account.token
                 };
    }else
    {
        return @{
                 @"goods_id"    : _goodsId,
                 @"action"      : @"collection/del_collection",
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
