//
//  StyleLikesApi.m
//  Yoshop
//
//  Created by zhaowei on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "StyleLikesApi.h"

@implementation StyleLikesApi {
    NSString *_userid;
    NSInteger _currentPage;
}

- (instancetype)initWithUserid:(NSString *)userid currentPage:(NSInteger)currentPage; {
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

-(BOOL)encryption {
    return NO;
}

- (id)requestParameters {
    
    return @{
             @"action"      : @"Community/index",
             @"is_enc"      : @"0",
             @"site" : @"zafulcommunity" ,
             @"type" : @"9",
             @"directory" : @"29",
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
