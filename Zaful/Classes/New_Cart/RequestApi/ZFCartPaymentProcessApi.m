//
//  ZFCartPaymentProcessApi.m
//  Zaful
//
//  Created by TsangFa on 23/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartPaymentProcessApi.h"

@implementation ZFCartPaymentProcessApi

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
    return  @{
              @"action"                  :   @"cart/get_checkout_flow",
              @"token"                   :   TOKEN,
              @"is_enc"                  :   @"0"
              };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
