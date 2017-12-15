
//
//  ZFCartListApi.m
//  Zaful
//
//  Created by liuxi on 2017/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartListApi.h"

@implementation ZFCartListApi
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
                 @"action"   :  @"cart/get_group_cart_info",
                 @"token"    :  TOKEN
                 };
        
    }else{
        return @{
                 @"action"   :  @"cart/get_group_cart_info",
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
