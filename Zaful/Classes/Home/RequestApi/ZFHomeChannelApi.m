//
//  ZFHomeChannelApi.m
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomeChannelApi.h"

@interface ZFHomeChannelApi ()

@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *pageNO;
@property (nonatomic, copy) NSString *pageSize;

@end

@implementation ZFHomeChannelApi

- (instancetype)initWithChannelId:(NSString *)channelId pageNO:(NSString *)pageNO pageSize:(NSString *)pageSize {
    if (self = [super init]) {
        self.channelId = channelId;
        self.pageNO    = pageNO;
        self.pageSize  = pageSize;
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

- (BOOL)encryption {
    return NO;
}

- (id)requestParameters {
    return @{
             @"action"    : @"channel/get_channel_data",
             @"channel_id": self.channelId,
             @"page"      : self.pageNO,
             @"page_size" : self.pageSize,
             @"is_enc"    : @"0",
             @"token"     : TOKEN
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
