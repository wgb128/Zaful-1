//
//  HomeApi.m
//  Zaful
//
//  Created by Y001 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HomeApi.h"

@implementation HomeApi

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

- (BOOL)encryption {
    return NO;
}

- (id)requestParameters {
    return @{
             @"action"    : @"index/get_data",
             @"is_enc"    : @"0",
             @"token"     : TOKEN
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
