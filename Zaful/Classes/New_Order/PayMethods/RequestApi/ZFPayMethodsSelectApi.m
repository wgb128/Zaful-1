
//
//  ZFPayMethodsSelectApi.m
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPayMethodsSelectApi.h"

@implementation ZFPayMethodsSelectApi
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
              @"action"                  :   @"cart/get_checkout_cod_payments",
              @"token"                   :   TOKEN,
              @"is_enc"                  :  @"0"
              };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
