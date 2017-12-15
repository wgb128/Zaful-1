//
//  FilterApi.m
//  Zaful
//
//  Created by zhaowei on 2017/3/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "FilterApi.h"

@implementation FilterApi

-(BOOL)enableAccessory {
    return YES;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)requestPath {
    return ENCPATH;
}

-(BOOL)encryption {
    return NO;
}

- (id)requestParameters {
    return @{
             @"action"  : @"common/get_cp_currency",
             @"token"   : TOKEN,
             @"is_enc"  :  @"0"
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
