//
//  ZFTrackingPackageApi.m
//  Zaful
//
//  Created by TsangFa on 4/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFTrackingPackageApi.h"

@implementation ZFTrackingPackageApi{
    NSString *_orderID;
}

- (instancetype)initWithOrderID:(NSString *)orderID {
    self = [super init];
    if (self) {
        _orderID = orderID;
    }
    return self;
}

-(BOOL)encryption {
    return NO;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)requestPath {
    return ENCPATH;
}

- (id)requestParameters {
    return @{
             @"action"      :  @"order/get_tracking",
             @"order_id"    :  NullFilter(_orderID),
             @"token"       :  TOKEN,
             @"is_enc"      :  @"0"
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
