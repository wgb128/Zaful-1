//
//  VideoListApi.m
//  Zaful
//
//  Created by zhaowei on 2016/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "VideoListApi.h"

@implementation VideoListApi {
    NSInteger _currentPage;
}

- (instancetype)initWithPage:(NSInteger)currentPage; {
    self = [super init];
    if (self) {
        _currentPage = currentPage;
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
             @"directory" : @"51",
             @"curPage" : @(_currentPage),
             @"pageSize" : @"15",
             @"app_type": @"2"
             };
}


- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
