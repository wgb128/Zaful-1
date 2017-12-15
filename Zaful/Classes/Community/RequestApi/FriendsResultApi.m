//
//  FriendsResultApi.m
//  Zaful
//
//  Created by zhaowei on 2017/1/15.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "FriendsResultApi.h"

@implementation FriendsResultApi {
    NSInteger _curPage;
    NSInteger _pageSize;
    NSString *_keyWord;
}

- (instancetype)initWithkeyWord:(NSString *)keyWord andCurPage:(NSInteger)curPage pageSize:(NSInteger)pageSize {
    if (self = [super init]) {
        _curPage = curPage;
        _pageSize = pageSize;
        _keyWord = keyWord;
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
             @"directory"   :   @"57",
             @"loginUserId" :   USERID,
             @"key_word"    :   _keyWord,
             @"page"        :   @(_curPage),
             @"pageSize"    :   @(_pageSize)

             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
