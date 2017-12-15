//
//  CartListApi.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/2.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CartListApi.h"

@implementation CartListApi

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
                 @"action"   :  @"cart/get_cart_info",
                 @"token"    :  TOKEN
                 };
        
    }else{
        return @{
                 @"action"   :  @"cart/get_cart_info",
                 @"sess_id"  :  SESSIONID
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
