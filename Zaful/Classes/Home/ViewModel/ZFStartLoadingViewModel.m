
//
//  ZFStartLoadingViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/11/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFStartLoadingViewModel.h"
#import "ZFStartLoadingApi.h"
#import "BannerModel.h"


@implementation ZFStartLoadingViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    ZFStartLoadingApi *api = [[ZFStartLoadingApi alloc] initWithModels:parmaters];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        BannerModel *model = [BannerModel yy_modelWithJSON:requestJSON[@"result"][0]];
        ZFLog(@"%@", model);
        NSArray *startLoad = requestJSON[@"result"];
        if (startLoad.count > 0) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.image]];
            if (data.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:requestJSON forKey:kStartLoadingInfo];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:kStartLoadingImageInfo];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kStartLoadingInfo];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kStartLoadingImageInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if (completion) {
            completion(nil);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        
        if (failure) {
            failure(nil);
        }
    }];
}
@end
