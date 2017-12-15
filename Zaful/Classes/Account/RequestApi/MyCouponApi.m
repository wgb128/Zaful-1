//
//  MyCouponApi.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/11.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "MyCouponApi.h"

@implementation MyCouponApi {
    NSInteger _page;
    NSInteger _pageSize;
}

-(instancetype)initWithPage:(NSInteger)page pageSize:(NSInteger)pageSize {
    
    self = [super init];
    if (self) {
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
             @"type"        :   @(0),
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
