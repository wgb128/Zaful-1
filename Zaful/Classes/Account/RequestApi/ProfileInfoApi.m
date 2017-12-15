//
//  ProfileInfoApi.m
//  Zaful
//
//  Created by 7FD75 on 16/9/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "ProfileInfoApi.h"

@implementation ProfileInfoApi

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

-(BOOL)encryption {
    return NO;
}

- (id)requestParameters {
    
    return @{
             @"action"      :   @"user/get_userInfo",
             @"token"       :   TOKEN,
             @"is_enc"      :   @"0"
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
