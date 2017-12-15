//
//  ZFCommunityOutfitsApi.m
//  Zaful
//
//  Created by liuxi on 2017/8/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityOutfitsApi.h"

@interface ZFCommunityOutfitsApi () {
    NSInteger _currentPage;
}

@end

@implementation ZFCommunityOutfitsApi
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
             @"action"          : @"Community/index",
             @"is_enc"          : @"0",
             @"type"            : @(9),
             @"directory"       : @(60),
             @"site"            : @"zafulcommunity",
             @"userId"          : USERID ?: @"0",
             @"size"            : @"10",
             @"page"            : @(_currentPage),
             @"app_type"        : @"2"
             };
}


- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
