//
//  CartCheckApi.m
//  Yoshop
//
//  Created by zhaowei on 16/6/13.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CartCheckOutApi.h"
#import "OrderInfoManager.h"

@implementation CartCheckOutApi {
    OrderInfoManager *_manager;
}

- (instancetype)initWithManager:(OrderInfoManager *)manager {
    if (self = [super init]) {
        _manager = manager;
    }
    return self;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)requestPath {
    return ENCPATH;
}

- (id)requestParameters {
   return  @{
             @"action"                  :   @"cart/checkout_info",
             @"token"                   :   TOKEN,
             @"coupon"                  :   [NSStringUtils emptyStringReplaceNSNull:_manager.couponCode],
             @"address_id"              :   [NSStringUtils emptyStringReplaceNSNull:_manager.addressId],
             @"shipping"                :   [NSStringUtils emptyStringReplaceNSNull:_manager.shippingId],
             @"insurance"               :   [NSStringUtils emptyStringReplaceNSNull:_manager.insurance],
             @"currentPoint"            :   [NSStringUtils emptyStringReplaceNSNull:_manager.currentPoint],
             @"payment"                 :   [NSStringUtils emptyStringReplaceNSNull:_manager.paymentCode],
             //用于快速支付
             @"payertoken"              :   [NSStringUtils emptyStringReplaceNSNull:_manager.payertoken],
             @"payerId"                 :   [NSStringUtils emptyStringReplaceNSNull:_manager.payerId]
             };
}


- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
