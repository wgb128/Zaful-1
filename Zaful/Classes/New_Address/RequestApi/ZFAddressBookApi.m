


//
//  ZFAddressBookApi.m
//  Zaful
//
//  Created by liuxi on 2017/8/30.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressBookApi.h"

@implementation ZFAddressBookApi

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
             @"action"     :   @"address/get_address_list",
             @"token"      :   TOKEN
             };
    
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
