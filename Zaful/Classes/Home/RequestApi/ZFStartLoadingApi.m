

//
//  ZFStartLoadingApi.m
//  Zaful
//
//  Created by liuxi on 2017/11/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFStartLoadingApi.h"

@interface ZFStartLoadingApi() {
    NSString        *_models;
}

@end

@implementation ZFStartLoadingApi

- (instancetype)initWithModels:(NSString *)models {
    self = [super init];
    if (self) {
        _models = models;
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

- (BOOL)encryption {
    return NO;
}

- (id)requestParameters {
    return @{
             @"action"    : @"index/get_start_page",
             @"models"    : _models ?: @"2",
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
