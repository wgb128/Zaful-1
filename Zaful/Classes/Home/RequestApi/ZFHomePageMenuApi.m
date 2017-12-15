//
//  ZFHomePageMenuApi.m
//  Zaful
//
//  Created by QianHan on 2017/10/10.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomePageMenuApi.h"

@implementation ZFHomePageMenuApi

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
             @"action"    : @"channel/get_channel_list",
             @"is_enc"    : @"0"
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
