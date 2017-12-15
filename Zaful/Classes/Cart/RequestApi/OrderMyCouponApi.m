//
//  OrderMyCouponApi.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/18.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "OrderMyCouponApi.h"

@implementation OrderMyCouponApi

{
    NSString *_code;
}

-(instancetype)initWithCouponCode:(NSString *)code{
    
    self = [super init];
    if (self) {
        _code = code;
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
    
    return @{
             @"action"     :  @"cart/check_coupon",
             @"coupon"     :  _code,
             @"token"      :  TOKEN
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
