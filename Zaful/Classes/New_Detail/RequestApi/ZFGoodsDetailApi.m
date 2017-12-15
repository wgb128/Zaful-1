


//
//  ZFGoodsDetailApi.m
//  Zaful
//
//  Created by liuxi on 2017/11/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailApi.h"

@implementation ZFGoodsDetailApi {
    NSString *_userId;
    NSString *_goodsId;
}

- (instancetype)initWithGoodsDetialUserId:(NSString *)userId goodsId:(NSString *)goodsId {
    self = [super init];
    if (self) {
        _userId = userId ? userId : @"";
        _goodsId = goodsId ? goodsId : @"";
    }
    return self;
}

- (BOOL)enableCache {
    return YES;
}

- (BOOL)enableAccessory {
    return YES;
}

-(BOOL)encryption {
    return NO;
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
                 @"action"     :  @"goods/detail",
                 @"goods_id"   :  _goodsId,
                 @"token"      :  [AccountManager sharedManager].account.token,
                 @"is_enc"      :  @"0"
                 };
    } else {
        return @{
                 @"goods_id"       : _goodsId,
                 @"action"         : @"goods/detail",
                 @"sess_id"        : SESSIONID,
                 @"is_enc"         : @"0"
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
