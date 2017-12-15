//
//  CommunityReplyApi.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/18.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CommunityReplyApi.h"

@implementation CommunityReplyApi {
    NSDictionary *_dict;
}

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
    return NO;
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
             @"loginUserId" : USERID,
             
             @"reviewId" : _dict[@"reviewId"] ?: @"",
             @"content" : _dict[@"content"] ?: @"",
             @"replyId" : _dict[@"replyId"] ?: @"",
             @"replyUserId" : _dict[@"replyUserId"] ?: @"0",
             @"isSecondFloorReply" : _dict[@"isSecondFloorReply"] ?: @""
             };
}


- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
