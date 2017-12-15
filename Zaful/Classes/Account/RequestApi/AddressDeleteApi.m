//
//  AddressDeleteApi.m
//  Yoshop
//
//  Created by Qiu on 16/6/6.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "AddressDeleteApi.h"


@implementation AddressDeleteApi
{
    
    NSString *_addressId;
}

- (instancetype)initWithDeleteAddressId:(NSString *)addressId {
    
    self = [super init];
    if (self) {
        _addressId = addressId;
    }
    return self;
}

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
             @"action"      :   @"address/del_address",
             @"token"       :   TOKEN,
             @"address_id"  :   _addressId
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
