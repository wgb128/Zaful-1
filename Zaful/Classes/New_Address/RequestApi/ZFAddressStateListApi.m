
//
//  ZFAddressStateListApi.m
//  Zaful
//
//  Created by liuxi on 2017/9/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressStateListApi.h"

@implementation ZFAddressStateListApi {
    NSString *_regionId;
}

-(instancetype)initWithRegionId:(NSString *)regionId {
    
    self = [super init];
    if (self) {
        _regionId = regionId;
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

- (id)requestParameters {
    return @{
             @"action"     :   @"common/get_city_list",
             @"token"      :   TOKEN,
             @"region_id"  :   _regionId
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
