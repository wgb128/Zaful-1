//
//  AccountCancelMyOrdersApi.m
//  Yoshop
//
//  Created by huangxieyue on 16/6/16.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "AccountCancelMyOrdersApi.h"

@implementation AccountCancelMyOrdersApi {
    NSString *_orderId;
}

- (instancetype)initWithOrderId:(NSString *)orderId {
    if (self = [super init]) {
        _orderId = orderId;
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

- (id)requestParameters {
    
    return @{
             @"action"      :   @"order/cancel",
             @"user_id"     :   USERID,
             @"token"       :   TOKEN,
             @"order_id"    :   _orderId,
             @"version"     :   [NSString stringWithFormat:@"%@",ZFSYSTEM_VERSION]
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

/// 请求的SerializerType
- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
