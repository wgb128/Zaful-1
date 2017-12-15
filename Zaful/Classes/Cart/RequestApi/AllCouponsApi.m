//
//  AllCouponsApi.m
//  Zaful
//
//  Created by 7FD75 on 16/9/19.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "AllCouponsApi.h"

@implementation AllCouponsApi

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)requestPath {
    return ENCPATH;
}

- (id)requestParameters {
    
    return @{
             @"action"  :  @"user/get_usable_coupons",
             @"token"   :  TOKEN
             };
    
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
