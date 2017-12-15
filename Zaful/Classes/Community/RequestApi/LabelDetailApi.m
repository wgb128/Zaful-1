//
//  LabelDetailApi.m
//  Zaful
//
//  Created by DBP on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "LabelDetailApi.h"

@implementation LabelDetailApi {
    NSInteger _curPage;
    NSString *_pageSize;
    NSString *_topicLabel;
}

- (instancetype)initWithcurPage:(NSInteger)curPage pageSize:(NSString*)pageSize topicLabel:(NSString *)topicLabel{
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
             @"userId"      :   USERID,
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
