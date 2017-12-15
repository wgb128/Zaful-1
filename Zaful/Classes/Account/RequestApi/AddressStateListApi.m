//
//  AddressStateListApi.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/12.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "AddressStateListApi.h"

@implementation AddressStateListApi
{
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
