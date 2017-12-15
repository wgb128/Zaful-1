//
//  CreateOrderApi.m
//  Zaful
//
//  Created by TsangFa on 17/3/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CreateOrderApi.h"
#import "FilterManager.h"

@implementation CreateOrderApi {
    OrderInfoManager *_manager;
}

- (instancetype)initWithDict:(OrderInfoManager *)manager {
    if (self = [super init]) {
        _manager = manager;
    }
    return self;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)requestPath {
    return ENCPATH;
}

- (id)requestParameters {
    return @{
             @"action"                  :   @"cart/done",
             @"token"                   :   TOKEN,
             @"coupon"                  :   [NSStringUtils emptyStringReplaceNSNull:_manager.couponCode],
             @"address_id"              :   [NSStringUtils emptyStringReplaceNSNull:_manager.addressId],
             @"shipping"                :   [NSStringUtils emptyStringReplaceNSNull:_manager.shippingId],
             @"need_traking_number"     :   [NSStringUtils emptyStringReplaceNSNull:_manager.need_traking_number],
             @"insurance"               :   [NSStringUtils emptyStringReplaceNSNull:_manager.insurance],
             @"point"                   :   [NSStringUtils emptyStringReplaceNSNull:_manager.currentPoint],
             @"payment"                 :   [NSStringUtils emptyStringReplaceNSNull:_manager.paymentCode],
             @"verifyCode"              :   [NSStringUtils emptyStringReplaceNSNull:_manager.verifyCode],
             @"isCod"                   :   [_manager.paymentCode isEqualToString:@"Cod"] ? @"1" : @"0",
             @"bizhong"                 :   [NSStringUtils emptyStringReplaceNSNull:_manager.bizhong],
             
             //用于快速支付
             @"payertoken"              :   [NSStringUtils emptyStringReplaceNSNull:_manager.payertoken],
             @"payerId"                 :   [NSStringUtils emptyStringReplaceNSNull:_manager.payerId],
             
             //appflyer
             @"media_source"            :   [NSStringUtils getMediaSource],
             @"campaign"                :   [NSStringUtils getCampaign],
             @"wj_linkid"               :   [NSStringUtils getLkid],
             @"ad_id"                   :   [NSStringUtils getAdId], // 增加从appsflyer获取归因参数 并储存至网站后台
             
             //用于催付
             @"pid"                     : [NSStringUtils getPid],
             @"c"                       : [NSStringUtils getC],
             @"is_retargeting"          : [NSStringUtils getIsRetargeting]

             };
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}



@end
