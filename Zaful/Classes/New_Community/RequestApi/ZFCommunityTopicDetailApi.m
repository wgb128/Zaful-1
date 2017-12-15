

//
//  ZFCommunityTopicDetailApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityTopicDetailApi.h"

@interface ZFCommunityTopicDetailApi () {
    NSInteger _curPage;
    NSString *_pageSize;
    NSString *_topicId;
    NSString *_sort;
}

@end

@implementation ZFCommunityTopicDetailApi
- (instancetype)initWithcurPage:(NSInteger)curPage pageSize:(NSString*)pageSize topicId:(NSString *)topicId sort:(NSString *)sort {
    if (self = [super init]) {
        _curPage = curPage;
        _pageSize = pageSize;
        _topicId = topicId;
        _sort = sort;
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
             @"directory"   :   @"47",
             @"topic_id"    :   _topicId,
             @"curPage"     :   @(_curPage),
             @"pageSize"    :   _pageSize,
             @"userId"      :   USERID ?: @"0",
             @"sort"        :   _sort,
             @"app_type"    :   @"2"
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
