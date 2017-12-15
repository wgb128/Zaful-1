//
//  CheckReviewApi.m
//  Zaful
//
//  Created by DBP on 16/12/27.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "CheckReviewApi.h"

@implementation CheckReviewApi
{
    NSDictionary *_dict;
}

- (instancetype)initWithDict : (NSDictionary *)dict {
    if (self = [super init]) {
        _dict = dict;
    }
    return self;
}

- (BOOL)enableCache {
    return YES;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)baseURL {
    return CommentURL;
}

- (NSString *)requestPath {
    return @"";
}

- (id)requestParameters {
    return @{
             @"site"        : @"zaful",
             @"type"        : @"9",
             @"app_type"    : @"31",
             @"user_id"     : USERID,
             @"directory"   : @"99",
             @"order_id"    : _dict[@"order_id"],
             @"goods_id"    : _dict[@"goods_id"]
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
