//
//  MessagesApi.m
//  Zaful
//
//  Created by DBP on 17/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "MessagesApi.h"

@implementation MessagesApi {
    NSInteger _curPage;
    NSString *_pageSize;
}

- (instancetype)initWithcurPage:(NSInteger)curPage pageSize:(NSString *)pageSize{
    if (self = [super init]) {
        _curPage = curPage;
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

-(BOOL)encryption {
    return NO;
}

- (id)requestParameters {
    return @{
             @"action"      : @"Community/index",
             @"is_enc"      : @"0",
             @"site"        :   @"zafulcommunity",
             @"type"        :   @"9",
             @"directory"   :   @"58",
             @"user_id"     :   USERID,
             @"page"        :   @(_curPage),
             @"pageSize"    :   _pageSize
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
