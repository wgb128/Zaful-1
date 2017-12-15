//
//  ZFGoodsDetailCollectionApi.m
//  Zaful
//
//  Created by liuxi on 2017/11/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailCollectionApi.h"

@implementation ZFGoodsDetailCollectionApi {
    NSString *_goodsId;
}

- (instancetype)initWithAddCollectionGoodsId:(NSString *)goodsId {
    self = [super init];
    if (self) {
        _goodsId = goodsId ? goodsId : @"";
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

-(BOOL)encryption {
    return NO;
}

- (id)requestParameters {
    
    if ([AccountManager sharedManager].isSignIn) {
        return @{
                 @"goods_id"       : _goodsId,
                 @"action"         : @"collection/add_collection",
                 @"token"          : [AccountManager sharedManager].account.token,
                 @"is_enc"         :  @"0"
                 };
    } else {
        return @{
                 @"goods_id"       : _goodsId,
                 @"action"         : @"collection/add_collection",
                 @"sess_id"        : SESSIONID,
                 @"is_enc"         :  @"0"
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
