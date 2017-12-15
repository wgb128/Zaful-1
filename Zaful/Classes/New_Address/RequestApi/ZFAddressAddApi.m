
//
//  ZFAddressAddApi.m
//  Zaful
//
//  Created by liuxi on 2017/9/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressAddApi.h"

@implementation ZFAddressAddApi {
    NSDictionary *_addressDic;
}

- (instancetype)initWithDic:(NSDictionary *)addressDic
{
    self = [super init];
    if (self) {
        _addressDic = addressDic;
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_addressDic];
    [dic setValue:@"address/edit_address" forKey: @"action"];
    [dic setValue:TOKEN forKey: @"token"];
    return dic;
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
