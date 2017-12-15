

//
//  ZFCommunityTopicHeadApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityTopicHeadApi.h"

@interface ZFCommunityTopicHeadApi () {
    NSString *_topicId;
}

@end

@implementation ZFCommunityTopicHeadApi

- (instancetype)initWithTopicId:(NSString *)topicId {
    if (self = [super init]) {
        _topicId = topicId;
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
             @"directory"   :   @"46",
             @"topic_id"    :   _topicId,
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
