

//
//  ZFCartCancelCollectionApi.m
//  Zaful
//
//  Created by liuxi on 2017/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartCancelCollectionApi.h"

@implementation ZFCartCancelCollectionApi {
    NSString *_goodsId;
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
                 @"action"      :  @"collection/del_collection",
                 @"goods_id"    :  _goodsId,
                 @"token"       :  TOKEN
                 };
    }else{
        
        return @{
                 @"action"      :  @"collection/del_collection",
                 @"goods_id"    :  _goodsId,
                 @"sess_id"     :  SESSIONID
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
