//
//  TopicDetailApi.m
//  Zaful
//
//  Created by DBP on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "TopicDetailApi.h"

@implementation TopicDetailApi {
    NSInteger _curPage;
    NSString *_pageSize;
    NSString *_topicId;
    NSString *_sort;
}


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
             @"userId"      :   USERID,
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
