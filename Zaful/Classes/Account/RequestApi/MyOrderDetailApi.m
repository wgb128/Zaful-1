//
//  MyOrderDetailApi.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/12.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "MyOrderDetailApi.h"

@implementation MyOrderDetailApi
{
    NSString *_orderId;
}
-(instancetype)initWithOrderId:(NSString *)orderId {
    
    self = [super init];
    if (self) {
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
             @"action"      :   @"order/detail",
             @"user_id"     :   USERID,
             @"token"       :   TOKEN,
             @"order_id"    :   _orderId,
             @"version"     :   [NSString stringWithFormat:@"%@",ZFSYSTEM_VERSION]
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
