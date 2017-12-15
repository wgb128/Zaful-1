
//
//  ZFCommunityStyleShowsApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityStyleShowsApi.h"

@interface ZFCommunityStyleShowsApi (){
    NSString *_userid;
    NSInteger _currentPage;
}

@end

@implementation ZFCommunityStyleShowsApi

- (instancetype)initWithUserid:(NSString *)userid currentPage:(NSInteger)currentPage {
    self = [super init];
    if (self) {
        _userid = userid ?: @"0";
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
             @"site" : @"zafulcommunity" ,
             @"type" : @"9",
             @"directory" : @"28",
             @"userId" : USERID,
             @"listUserId" : _userid,
             @"curPage" : @(_currentPage),
             @"pageSize" : @"15"
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
