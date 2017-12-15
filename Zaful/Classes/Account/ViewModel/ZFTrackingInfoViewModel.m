//
//  ZFTrackingInfoViewModel.m
//  Zaful
//
//  Created by Tsang_Fa on 2017/9/5.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFTrackingInfoViewModel.h"
#import "ZFTrackingPackageApi.h"
#import "ZFTrackingPackageModel.h"

@implementation ZFTrackingInfoViewModel

- (void)requestTrackingPackageData:(NSString *)orderID completion:(void (^)(NSArray<ZFTrackingPackageModel *> *array))completion failure:(void (^)(id obj))failure {
    
    ZFTrackingPackageApi *api = [[ZFTrackingPackageApi alloc] initWithOrderID:orderID];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        NSArray<ZFTrackingPackageModel *> *dataArray = [NSArray yy_modelArrayWithClass:[ZFTrackingPackageModel class] json:requestJSON[@"result"][@"data"]];
        
        if (completion && dataArray.count > 0) {
            completion(dataArray);
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        ZFLog(@"\n-------------------------- 错误日志 --------------------------\n接口:%@\n状态码:%ld\n报错信息:%@",NSStringFromClass(api.class),api.responseStatusCode,api.responseString);
    }];
}




@end
