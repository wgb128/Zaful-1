//
//  CategoryDataApi.m
//  ListPageViewController
//
//  Created by Tsang_Fa on 2017/6/27.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryDataApi.h"

@implementation CategoryDataApi

-(instancetype)initCategoryDataApi {
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)enableCache {
    return YES;
}

- (BOOL)enableAccessory {
    return YES;
}

-(BOOL)encryption {
    return NO;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)requestPath {
    return ENCPATH;
}

- (id)requestParameters {
    return @{
             @"action"   :  @"common/get_children_category" ,
             @"is_enc"   :  @"0"
            };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
