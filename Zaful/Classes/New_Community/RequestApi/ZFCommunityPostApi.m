

//
//  ZFCommunityPostApi.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityPostApi.h"

@interface ZFCommunityPostApi () {
    NSDictionary *_dict;
}

@end

@implementation ZFCommunityPostApi
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _dict = dict;
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
    return @"";
}

- (NSString *)baseURL {
    return CommunityPostURL;
}

- (id)requestParameters {
    
    return @{
             @"site" : @"zafulcommunity" ,
             @"type" : @"1",
             @"userId" : USERID ?: @"0",
             @"goodsId" : _dict[@"goodsId"], // 商品id值
             @"content":_dict[@"content"],
             @"topic" : [_dict[@"topic"] yy_modelToJSONString],
             @"app_add_time":[NSString stringWithFormat:@"%ld",time(NULL)],
             @"app_type":@"2"
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
