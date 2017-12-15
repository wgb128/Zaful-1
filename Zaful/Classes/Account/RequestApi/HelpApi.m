//
//  HelpApi.m
//  Zaful
//
//  Created by Y001 on 16/9/21.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HelpApi.h"

@implementation HelpApi

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
             @"action"  :   @"article/index"
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

/// 请求的SerializerType
- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
