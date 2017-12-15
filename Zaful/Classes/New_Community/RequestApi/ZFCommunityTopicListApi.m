
//
//  ZFCommunityTopicListApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityTopicListApi.h"

@interface ZFCommunityTopicListApi () {
    NSInteger _curPage;
    NSString *_pageSize;
}

@end

@implementation ZFCommunityTopicListApi
- (instancetype)initWithcurPage:(NSInteger)curPage pageSize:(NSString*)pageSize{
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
             @"directory"   :   @"45",
             @"curPage"     :   @(_curPage),
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
