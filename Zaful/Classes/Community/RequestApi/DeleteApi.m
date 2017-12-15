//
//  DeleteApi.m
//  Zaful
//
//  Created by DBP on 17/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "DeleteApi.h"

@implementation DeleteApi
{
    NSString *_deleteId;
    NSString *_userId;
}


- (instancetype)initWithDeleteId:(NSString *)deleteId andUserId:(NSString *)userId
{
    if (self = [super init]) {
        _deleteId = deleteId;
        _userId = userId;
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
             @"type"        : @"9",
             @"site"        : @"zafulcommunity",
             @"directory"   : @"55",
             @"userId"      : _userId,
             @"loginUserId" : USERID,
             @"isDelete"    : @"1",
             @"reviewId"    : _deleteId
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
