


//
//  ZFAddressDeleteApi.m
//  Zaful
//
//  Created by liuxi on 2017/8/30.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressDeleteApi.h"

@implementation ZFAddressDeleteApi {
    
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
