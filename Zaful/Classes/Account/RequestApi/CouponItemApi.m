//
//  CouponItemApi.m
//  Zaful
//
//  Created by zhaowei on 2017/6/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CouponItemApi.h"

@implementation CouponItemApi {
    NSString *_kind;
    NSInteger _page;
    NSInteger _pageSize;
}

-(instancetype)initWithKind:(NSString *)kind page:(NSInteger)page pageSize:(NSInteger)pageSize {
    
    self = [super init];
    if (self) {
        _kind = kind;
        _page = page;
        _pageSize = pageSize;
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

- (id)requestParameters {
    
    return @{
             @"action"      :   @"user/get_coupons",
             @"type"        :   _kind,
             @"token"       :   TOKEN,
             @"page"        :   @(_page),
             @"size"        :   @(_pageSize)
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
