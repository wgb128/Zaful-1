

//
//  ZFCartDeleteGoodsApi.m
//  Zaful
//
//  Created by liuxi on 2017/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartDeleteGoodsApi.h"

@implementation ZFCartDeleteGoodsApi {
    NSArray *_goodsId;
}

- (instancetype)initWithGoodsId:(NSArray *)goodsId{
    if (self = [super init]) {
        _goodsId = goodsId;
    }
    return self;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (id)requestParameters {
    if ([AccountManager sharedManager].isSignIn) {
        return @{
                 @"action" : @"cart/del_cart",
                 @"goods"  : _goodsId,
                 @"token"  : TOKEN
                 };
    } else {
        return @{
                 @"action" : @"cart/del_cart",
                 @"sess_id": SESSIONID,
                 @"goods"  : _goodsId
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
