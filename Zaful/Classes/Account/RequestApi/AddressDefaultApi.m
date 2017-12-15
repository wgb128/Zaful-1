//
//  AddressDefaultApi.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/15.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "AddressDefaultApi.h"

@implementation AddressDefaultApi
{
    NSString *_addressId;
}
-(instancetype)initWithAddressId:(NSString *)addressId {
    
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
             
             @"action"      :   @"address/default_address",
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
