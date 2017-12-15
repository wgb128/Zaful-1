//
//  WriteReviewApi.m
//  Zaful
//
//  Created by zhaowei on 2016/12/31.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "WriteReviewApi.h"

@implementation WriteReviewApi{
    NSDictionary *_dict;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _dict = dict;
    }
    return self;
}

- (BOOL)enableCache {
    return YES;
}

- (BOOL)encryption {
    return NO;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)requestPath {
    return ENCPATH;
}

- (id)requestParameters {
    
    NSDictionary *dict = @{
                           @"site"            : @"zaful",
                           @"type"            : @"1",
                           @"directory"       : @"99",
                           @"title"           : _dict[@"title"],
                           @"content"         : _dict[@"content"],
                           @"rate_overall"    : _dict[@"rate_overall"],
                           @"site_version"    : @"3",
                           @"order_id"        : _dict[@"order_id"],
                           @"goods_id"        : _dict[@"goods_id"]
                           };
    
    NSString *jsonStr = [dict yy_modelToJSONString];
    
    return @{
             @"action"          : @"Community/review",
             @"is_enc"          : @"0",
             @"data"            : [jsonStr stringByReplacingOccurrencesOfString:@"\"" withString:@""],
             @"site"            : @"zaful",
             @"type"            : @"1",
             @"directory"       : @"99",
             @"title"           : _dict[@"title"],
             @"content"         : _dict[@"content"],
             @"rate_overall"    : _dict[@"rate_overall"],
             @"site_version"    : @"3",
             @"order_id"        : _dict[@"order_id"],
             @"goods_id"        : _dict[@"goods_id"],
             @"user_id"          : USERID
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeader {
    
    NSDictionary *dict = @{
                           @"site"            : @"zaful",
                           @"type"            : @"1",
                           @"directory"       : @"99",
                           @"title"           : _dict[@"title"],
                           @"content"         : _dict[@"content"],
                           @"rate_overall"    : _dict[@"rate_overall"],
                           @"site_version"    : @"3",
                           @"order_id"        : _dict[@"order_id"],
                           @"goods_id"        : _dict[@"goods_id"]
                           };
    
    NSString *jsonStr = [[dict yy_modelToJSONString] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *key = PrivateKey;
    NSString *headerKey = [NSStringUtils ZFNSStringMD5:[jsonStr stringByAppendingString:key]];
    NSString *headerValue = [NSStringUtils ZFNSStringMD5:[[jsonStr stringByAppendingString:headerKey] stringByAppendingString:key]];
    return @{
             headerKey:headerValue
             };
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSArray *images = _dict[@"images"];
        [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *data = UIImageJPEGRepresentation(obj, 0.99);
            
            NSArray *typeArray = [self typeForImageData:data];
            
            NSString *name = [NSString stringWithFormat:@"pic_%lu.%@",(unsigned long)idx,typeArray[1]];
            NSString *formKey = [NSString stringWithFormat:@"pic_%lu",(unsigned long)idx];
            NSString *type = typeArray[0];
            
            NSLog(@"%@---%@---%@",formKey,name,type);
            
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }];
    };
}

- (NSArray *)typeForImageData:(NSData *)data {
    
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @[@"image/jpeg",@"jpg"];
            
        case 0x89:
            
            return @[@"image/png",@"png"];
            
        case 0x47:
            
            return @[@"image/gif",@"gif"];
            
        case 0x49:
        case 0x4D:
            
            return @[@"image/tiff",@"tiff"];
            
    }
    
    return nil;
    
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
