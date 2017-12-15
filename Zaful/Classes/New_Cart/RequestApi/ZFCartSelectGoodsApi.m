


//
//  ZFCartSelectGoodsApi.m
//  Zaful
//
//  Created by liuxi on 2017/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartSelectGoodsApi.h"

@implementation ZFCartSelectGoodsApi {
    NSString *_goodsId;
    NSInteger _isSelected;
    NSArray  *_goods;
}

- (instancetype)initWithGoodsId:(NSString *)goodsId selectStatus:(NSInteger)isSelected{
    if (self = [super init]) {
        _goodsId = goodsId;
        _isSelected = isSelected;
    }
    return self;
}

- (instancetype)initWithGoodsArray:(NSArray *)goodsArray {
    if (self = [super init]) {
        _goods = goodsArray;
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
                 @"action"      :  @"cart/select_cart_goods",
                 @"goods_id"    :  _goodsId ?: @"",
                 @"select"      :  @(_isSelected),
                 @"goods"       :  _goods ?: @[],
                 @"token"       :  TOKEN
                 };
    }else{
        
        return @{
                 @"action"      :  @"cart/select_cart_goods",
                 @"goods_id"    :  _goodsId ?: @"",
                 @"select"      :  @(_isSelected),
                 @"goods"       :  _goods ?: @[],
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
