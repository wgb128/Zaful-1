//
//  CategoryRefineApi.m
//  ListPageViewController
//
//  Created by TsangFa on 3/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryNewRefineApi.h"

@implementation CategoryNewRefineApi {
    NSString *_cat_id;
}

- (instancetype)initWithCategoryRefineApiCat_id:(NSString *)cateId{
    self = [super init];
    if (self) {
        _cat_id = cateId;
    }
    return  self;
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
             @"action"      :   @"category/get_attr_list",
             @"cat_id"      :   [NSStringUtils emptyStringReplaceNSNull:_cat_id],
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
