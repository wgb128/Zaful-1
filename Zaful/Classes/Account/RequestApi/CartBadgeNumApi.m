//
//  CartBadgeNumApi.m
//  Zaful
//
//  Created by 7FD75 on 16/9/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "CartBadgeNumApi.h"

@implementation CartBadgeNumApi

- (BOOL)enableCache {
    return YES;
}

- (BOOL)encryption {
    return NO;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)requestPath {
    return ENCPATH;
}

- (id)requestParameters {
    /**
     *  目前只需要登录后请求购物车Badge数量，这个接口只给登录后,支付完成后，获取的Badge数量
     */
    if ([AccountManager sharedManager].isSignIn) {
        return @{
                 @"action"      :   @"cart/get_cart_num",
                 @"token"       :   TOKEN,
                  @"is_enc"     : @"0"
                 };
    }else{
        return @{
                 @"action"      :   @"cart/get_cart_num",
                 @"sess_id"     :   SESSIONID,
                 @"is_enc"     : @"0"
                 };
        
        
    }
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
