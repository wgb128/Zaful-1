
//
//  ZFCommunityAccountOutfitsApi.m
//  Zaful
//
//  Created by liuxi on 2017/8/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityAccountOutfitsApi.h"

@interface ZFCommunityAccountOutfitsApi () {
    NSString *_userid;
    NSInteger _currentPage;
}
@end

@implementation ZFCommunityAccountOutfitsApi
- (instancetype)initWithUserid:(NSString *)userid currentPage:(NSInteger)currentPage {
    self = [super init];
    if (self) {
        _userid = userid;
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

- (BOOL)encryption {
    return NO;
}

- (id)requestParameters {
    
    return @{
             @"action"      : @"Community/index",
             @"is_enc"      : @"0",
             @"site" : @"zafulcommunity" ,
             @"type" : @(9),
             @"directory" : @(61),
             @"userId" : USERID ?: @"0",
             @"follow_user_id" : _userid ?: @"0",
             @"page" : @(_currentPage),
             @"size" : @"10",
             @"app_type":@"2"
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
