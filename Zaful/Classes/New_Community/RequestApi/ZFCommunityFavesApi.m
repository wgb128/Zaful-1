
//
//  ZFCommunityFavesApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityFavesApi.h"

@interface ZFCommunityFavesApi () {
    NSInteger _currentPage;
}

@end

@implementation ZFCommunityFavesApi
- (instancetype)initWithcurrentPage:(NSInteger)currentPage {
    self = [super init];
    if (self) {
        _currentPage = currentPage;
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

-(BOOL)encryption {
    return NO;
}

- (id)requestParameters {
    return @{
             @"action"      : @"Community/index",
             @"is_enc"      : @"0",
             @"type"            : @(9),
             @"directory"       : @(33),
             @"site"            : @"zafulcommunity",
             
             @"userId"          : USERID ?: @"0",
             @"pageSize"        : @"15",
             @"curPage"         : @(_currentPage),
             };
}


- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
