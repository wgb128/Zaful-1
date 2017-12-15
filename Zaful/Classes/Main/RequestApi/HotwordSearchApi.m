//
//  HotwordSearchApi.m
//  Zaful
//
//  Created by TsangFa on 16/12/30.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HotwordSearchApi.h"

@implementation HotwordSearchApi

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
             @"action"  : @"search/getHotWord",
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
