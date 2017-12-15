//
//  ZFPayMethodsViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPayMethodsViewModel.h"
#import "ZFPayMethodsSelectApi.h"
#import "ZFPayMethodsSelectDoneApi.h"
#import "ZFPayMethodsListModel.h"
#import "ZFOrderCheckInfoModel.h"

@interface ZFPayMethodsViewModel()
@property (nonatomic, strong) ZFPayMethodsListModel     *listModel;
@end

@implementation ZFPayMethodsViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id))failure {
    ZFPayMethodsSelectApi *payMethodsApi = [[ZFPayMethodsSelectApi alloc] init];
    @weakify(self);
    [payMethodsApi startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self);
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(ZFPayMethodsSelectApi.class)];
        self.listModel = [self dataAnalysisFromJson:requestJSON[@"result"] request:payMethodsApi];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            if (completion) {
                completion(self.listModel);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

- (void)requestDoneNetwork:(id)parmaters completion:(void (^)(NSArray<ZFOrderCheckInfoModel *>* dataArray))completion failure:(void (^)(id))failure {
    [MBProgressHUD showLoadingView:nil];
    NSDictionary *dict = parmaters;
    ZFPayMethodsSelectDoneApi *doneApi = [[ZFPayMethodsSelectDoneApi alloc] initWithPayCoder:[dict ds_stringForKey:@"payCode"] parametersArray:[dict ds_arrayForKey:@"order_info"]];
    [doneApi startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(ZFPayMethodsSelectDoneApi.class)];
        NSArray<ZFOrderCheckInfoModel *> *dataArray = [NSArray yy_modelArrayWithClass:[ZFOrderCheckInfoModel class] json:requestJSON[@"result"]];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            if (completion && dataArray.count > 0) {
                completion(dataArray);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        if (failure) {
            failure(nil);
        }
    }];
}

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    if ([request isKindOfClass:[ZFPayMethodsSelectApi class]]) {
        return [ZFPayMethodsListModel yy_modelWithJSON:json];
    }
    return nil;
}
@end
