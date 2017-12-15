//
//  CategoryVirtualApi.m
//  ListPageViewController
//
//  Created by TsangFa on 30/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryVirtualApi.h"

@implementation CategoryVirtualApi{
    NSDictionary *_dict;
}

-(instancetype)initVirtualApiWithParameter:(id)parameter {
    self = [super init];
    if (self) {
        _dict = parameter;
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
             @"action"              : @"category/get_promotion_goods",
             @"cat_id"              : [NSStringUtils emptyStringReplaceNSNull:_dict[@"cat_id"]],
             @"page"                : [NSStringUtils emptyStringReplaceNSNull:_dict[@"page"]] ,
             @"page_size"           : @(20),
             @"order_by"            : [NSStringUtils emptyStringReplaceNSNull:_dict[@"order_by"]],
             @"type"                : [NSStringUtils emptyStringReplaceNSNull:_dict[@"type"]],
             @"price_min"           : [NSStringUtils emptyStringReplaceNSNull:_dict[@"price_min"]],
             @"price_max"           : [NSStringUtils emptyStringReplaceNSNull:_dict[@"price_max"]],
             @"is_enc"              : @"0"
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
