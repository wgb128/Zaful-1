//
//  ExchangeApi.m
//  Yoshop
//
//  Created by zhaowei on 16/6/1.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "ExchangeApi.h"

@implementation ExchangeApi


-(BOOL)enableAccessory {
    return YES;
}

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

    return @{
      @"action"  : @"common/get_exchange_rate",
      @"token"   : TOKEN,
      @"is_enc"  :  @"0"
      };
}


- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
