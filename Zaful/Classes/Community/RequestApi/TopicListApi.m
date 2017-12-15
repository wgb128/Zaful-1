//
//  TopicListApi.m
//  Zaful
//
//  Created by DBP on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "TopicListApi.h"

@implementation TopicListApi {
    NSInteger _curPage;
    NSString *_pageSize;
}

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
