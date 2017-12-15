//
//  CheckOrderStatusApi.m
//  Zaful
//
//  Created by 7FD75 on 16/9/20.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "CheckOrderStatusApi.h"

@implementation CheckOrderStatusApi
{
    NSString *_orderSN;
}
-(instancetype)initWithOrderSN:(NSString *)orderSN {
    
    self = [super init];
    if (self) {
        _orderSN = orderSN;
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
             @"action"      :   @"order/get_order_status",
             @"token"       :   TOKEN,
             @"order_sn"    :   _orderSN
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
