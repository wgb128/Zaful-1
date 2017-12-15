


//
//  ZFGoodsAddToCartApi.m
//  Zaful
//
//  Created by liuxi on 2017/11/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsAddToCartApi.h"

@implementation ZFGoodsAddToCartApi {
    NSString *_goodsId;
    NSInteger _number;
}

- (instancetype)initWithGoodsId:(NSString *)goodsId goodsNumber:(NSInteger)number{
    if (self = [super init]) {
        _goodsId = goodsId;
        _number = number;
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

-(BOOL)encryption {
    return NO;
}

- (id)requestParameters {
    
    if ([AccountManager sharedManager].isSignIn) {
        return @{
                 @"action"    : @"cart/add_to_cart",
                 @"goods_id"  : NullFilter(_goodsId),
                 @"num"       : @(_number),
                 @"token"     : TOKEN,
                 @"is_enc"   :  @"0"
                 };
        
    }else{
        return @{
                 @"action"    : @"cart/add_to_cart",
                 @"goods_id"  : NullFilter(_goodsId),
                 @"num"       : @(_number),
                 @"sess_id"   : SESSIONID,
                 @"is_enc"   :  @"0"
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
