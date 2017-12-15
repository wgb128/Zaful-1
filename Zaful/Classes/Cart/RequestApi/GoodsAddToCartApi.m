//
//  GoodsAddCollectApi.m
//  Yoshop
//
//  Created by huangxieyue on 16/6/6.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "GoodsAddToCartApi.h"

@implementation GoodsAddToCartApi
{
    NSString *_goodsId;
}

-(void)setGoodsId:(NSString *)goodsId{
    _goodsId = goodsId;
}

- (instancetype)initWithGoodsId:(NSString *)goodsId {
    if (self = [super init]) {
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
    return ENCPATH;
}

- (id)requestParameters {
    
    if ([AccountManager sharedManager].isSignIn) {
        return @{
                 @"action"    : @"cart/add_to_cart",
                 @"goods_id"  : NullFilter(_goodsId),
                 @"num"       : @(1),
                 @"token"     : TOKEN
                 };
        
    }else{
        return @{
                 @"action"    : @"cart/add_to_cart",
                 @"goods_id"  : NullFilter(_goodsId),
                 @"num"       : @(1),
                 @"sess_id"   : SESSIONID
                 
                 };
    }
    
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

/// 请求的SerializerType
- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
