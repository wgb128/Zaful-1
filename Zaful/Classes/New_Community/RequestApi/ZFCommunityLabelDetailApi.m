
//
//  ZFCommunityLabelDetailApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityLabelDetailApi.h"

@interface ZFCommunityLabelDetailApi () {
    NSInteger _curPage;
    NSString *_pageSize;
    NSString *_topicLabel;
}
@end

@implementation ZFCommunityLabelDetailApi - (instancetype)initWithcurPage:(NSInteger)curPage pageSize:(NSString*)pageSize topicLabel:(NSString *)topicLabel{
    if (self = [super init]) {
        _curPage = curPage;
        _pageSize = pageSize;
        _topicLabel = topicLabel;
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
             @"type"        :   @"9",
             @"site"        :   @"zafulcommunity",
             @"directory"   :   @"48",
             @"topic_label" :   _topicLabel,  //话题标签得带上#
             @"curPage"     :   @(_curPage),
             @"pageSize"    :   _pageSize,
             @"userId"      :   USERID ?: @"0",
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
