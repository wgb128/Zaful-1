//
//  DRewardsApi.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/28.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "MyPointsApi.h"

@interface MyPointsApi ()
{
    NSInteger    _page;//当前页
    NSInteger    _size;//每页显示数量
}
@end

@implementation MyPointsApi

- (instancetype)initDRewardsApiWithPage:(NSInteger)page withSize:(NSInteger)size
{
    self = [super init];
    if (self) {
        _page    = page;
        _size = size;
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
    
             @"action"      :   @"user/get_points_record",
             @"token"       :   TOKEN,
             @"page"        :   @(_page),
             @"size"        :   @(_size),
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
