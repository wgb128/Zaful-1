//
//  SendCodeApi.m
//  Zaful
//
//  Created by TsangFa on 17/3/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SendCodeApi.h"

@implementation SendCodeApi {
    NSString *_addressID;
}

- (instancetype)initWithAddressID:(NSString *)addressID {
    
    if (self = [super init]) {
        _addressID = addressID;
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
             @"action"                  :   @"cart/checkout_verify",
             @"token"                   :   TOKEN,
             @"address_id"              :   [NSStringUtils emptyStringReplaceNSNull:_addressID],
             @"is_enc"                  :  @"0"
             };
    
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}







@end
