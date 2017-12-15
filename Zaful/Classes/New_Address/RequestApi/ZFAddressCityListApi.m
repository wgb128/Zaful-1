//
//  ZFAddressCityListApi.m
//  Zaful
//
//  Created by liuxi on 2017/9/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressCityListApi.h"

@implementation ZFAddressCityListApi {
    NSString *_provinceId;
    NSString *_countryId;
}

-(instancetype)initWithProvinceId:(NSString *)provinceId countryId:(NSString *)countryId {
    
    self = [super init];
    if (self) {
        _provinceId = provinceId;
        _countryId = countryId;
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
             @"action"     :   @"common/get_city_list_by_province",
             @"token"      :   TOKEN,
             @"province_id"  :   _provinceId,
             @"country_id" :     _countryId
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}

@end
