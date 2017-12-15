//
//  ZFGoodsReviewsApi.m
//  Zaful
//
//  Created by liuxi on 2017/11/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsReviewsApi.h"

@implementation ZFGoodsReviewsApi {
    NSString *_goodsID;
    NSString *_goodsSn;
    NSString *_page;
}

- (instancetype)initWithGoodsID : (NSString *)goodsID goodsSn:(NSString *)goodsSn page:(NSString *)page{
    if (self = [super init]) {
        _goodsID  = goodsID;
        _goodsSn = goodsSn;
        _page = page;
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

- (NSString *)baseURL {
    return CommentURL;
}

- (NSString *)requestPath {
    return @"";
}

- (id)requestParameters {
    return @{
             @"site"        : @"zaful",
             @"type"        : @"9",
             @"directory"   : @"99",
             @"goods_id"    : _goodsID,
             @"sku"         : _goodsSn,
             @"num"         : @"20",
             @"page"        : _page,
             @"app_type"    :@"1"
             };
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
