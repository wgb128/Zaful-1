//
//  CommunityFavesApi.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CommunityFavesApi.h"

@implementation CommunityFavesApi {
    NSInteger _curPage;
}

- (instancetype)initWithcurPage:(NSInteger)curPage {
    if (self = [super init]) {
        _curPage = curPage;
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
             @"type"         : @(9),
             @"directory"  : @(33),
             @"site"           : @"zafulcommunity",
             
             @"userId"      : USERID,
             @"pageSize" : @"15",
             @"curPage"   : @(_curPage),
             };
}


- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
