//
//  FastSettleApi.m
//  Zaful
//
//  Created by zhaowei on 2017/4/18.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "FastSettleApi.h"

@implementation FastSettleApi {
    NSString *_payertoken;
    NSString *_payerId;
}

-(instancetype)initWithPayertoken:(NSString *)payertoken payerId:(NSString *)payerId {
    if (self = [super init]) {
        _payertoken = payertoken;
        _payerId = payerId;
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
    return [NSStringUtils buildRequestPath:@""];
}


- (id)requestParameters {
    return @{
             @"action"     : @"cart/quick_checkout",
             @"sess_id"    : SESSIONID,
             @"token"      : TOKEN,
             @"payertoken" : _payertoken,
             @"payerId"    : _payerId
             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}



- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
