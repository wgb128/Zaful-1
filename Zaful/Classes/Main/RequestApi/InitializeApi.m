//
//  InitializeApi.m
//  Zaful
//
//  Created by zhaowei on 2017/6/24.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "InitializeApi.h"

@implementation InitializeApi
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
             @"action"  : @"common/initialization",
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
