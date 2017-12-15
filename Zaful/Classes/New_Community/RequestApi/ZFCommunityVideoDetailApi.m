
//
//  ZFCommunityVideoDetailApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityVideoDetailApi.h"

@interface ZFCommunityVideoDetailApi ()  {
    NSString *_videoId;
}

@end

@implementation ZFCommunityVideoDetailApi
- (instancetype)initWithVideoId:(NSString *)videoId {
    self = [super init];
    if (self) {
        _videoId = videoId;
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
             @"directory" : @"52",
             @"loginUserId" : USERID ?: @"0",
             @"id" : _videoId
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
