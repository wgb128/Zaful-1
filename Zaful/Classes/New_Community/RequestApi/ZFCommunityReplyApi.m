


//
//  ZFCommunityReplyApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityReplyApi.h"

@interface ZFCommunityReplyApi () {
    NSDictionary *_dict;
}

@end

@implementation ZFCommunityReplyApi
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _dict = dict;
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
             @"site" : @"zafulcommunity",
             @"type" : @"10",
             @"loginUserId" : USERID ?: @"0",
             
             @"reviewId" : _dict[@"reviewId"],
             @"content" : _dict[@"content"],
             @"replyId" : _dict[@"replyId"],
             @"replyUserId" : _dict[@"replyUserId"],
             @"isSecondFloorReply" : _dict[@"isSecondFloorReply"]
             };
}


- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
