//
//  CountryListApi.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/15.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CountryListApi.h"

@implementation CountryListApi

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
             @"action"      :   @"common/get_country_list",
             @"token"       :   TOKEN,
             @"is_enc"      :  @"0"
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
