//
//  ZFCartViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartViewModel.h"
#import "ZFCartListApi.h"
#import "ZFCartSelectGoodsApi.h"
#import "ZFCartAddCollectionApi.h"
#import "ZFCartCancelCollectionApi.h"
#import "ZFCartDeleteGoodsApi.h"
#import "ZFCartEditGoodsApi.h"
#import "ZFCartListModel.h"
#import "ZFCartListResultModel.h"
#import "ZFCartGoodsListModel.h"
#import "ZFCartGoodsModel.h"
#import "ZFOrderManager.h"
#import "ZFOrderCheckInfoModel.h"
#import "ZFOrderCheckInfoDetailModel.h"
#import "ZFOrderCheckInfoApi.h"
#import <AVOSCloud/AVOSCloud.h>
#import "FastSettleApi.h"
#import "ZFCartPaymentProcessApi.h"

@interface ZFCartViewModel ()
@property (nonatomic, strong) ZFCartListModel       *cartListModel;
@end

@implementation ZFCartViewModel
#pragma mark - request methods
- (void)requestCartListNetwork:(id)parmaters completion:(void (^)(id obj))completion  failure:(void (^)(id obj))failure {
    [MBProgressHUD showLoadingView:nil];
    ZFCartListApi *carListApi = [[ZFCartListApi alloc] init];
    @weakify(self);
    [carListApi startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(carListApi.class)];
        self.cartListModel = [self dataAnalysisFromJson:requestJSON request:carListApi];
        if (self.cartListModel.statusCode == 200){
            if (completion) {
                completion(self.cartListModel.result);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        if (failure) {
            failure(nil);
        }
    }];
}

- (void)requestCartSelectGoodsNetwork:(ZFCartGoodsModel *)model completion:(void (^)(BOOL isOK))completion {
    ZFCartSelectGoodsApi *api = [[ZFCartSelectGoodsApi alloc] initWithGoodsId:model.goods_id selectStatus:!model.is_selected];
    [MBProgressHUD showLoadingView:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    __block BOOL _isOK = NO;
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                _isOK = YES;
            }else{
                [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
            }
            if (completion) {
                completion(_isOK);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        if (completion) {
            completion(_isOK);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
    
}

- (void)requestCartSelectAllGoodsNetwork:(NSArray *)goods completion:(void (^)(BOOL isOK))completion {
    ZFCartSelectGoodsApi *api = [[ZFCartSelectGoodsApi alloc] initWithGoodsArray:goods];
    [MBProgressHUD showLoadingView:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    __block BOOL _isOK = NO;
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                _isOK = YES;
            }else{
                [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
            }
            if (completion) {
                completion(_isOK);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        if (completion) {
            completion(_isOK);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
    
}

- (void)requestCartDelNetwork:(NSString *)goodsId completion:(void (^)(BOOL isOK))completion {
    ZFCartDeleteGoodsApi *api = [[ZFCartDeleteGoodsApi alloc] initWithGoodsId:[NSArray arrayWithObject:goodsId]];
    [MBProgressHUD showLoadingView:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    __block BOOL _isOK = NO;
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                _isOK = YES;
            }else{
                [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
            }
        }
        if (completion) {
            completion(_isOK);
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        if (completion) {
            completion(_isOK);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
    
}

- (void)requestCartUnavailableClearAllNetwork:(NSArray *)array completion:(void (^)(BOOL isOK))completion {
    ZFCartDeleteGoodsApi *api = [[ZFCartDeleteGoodsApi alloc] initWithGoodsId:array];
    [MBProgressHUD showLoadingView:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    __block BOOL _isOK = NO;
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                _isOK = YES;
            }else{
                [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
            }
        }
        if (completion) {
            completion(_isOK);
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        if (completion) {
            completion(_isOK);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

- (void)requestAddGoodCollectionNetwork:(NSString *)goodId completion:(void (^)(BOOL isOK))completion failure:(void (^)())failure {
    ZFCartAddCollectionApi *api = [[ZFCartAddCollectionApi alloc] initWithGoodsId:goodId];
    [MBProgressHUD showLoadingView:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    __block BOOL _isOK = NO;
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                _isOK = YES;
                [MBProgressHUD showMessage:ZFLocalizedString(@"CartAddToFavoritesSuccessfully", nil)];
            }
            if (completion) {
                completion(_isOK);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        if (failure) {
            failure(_isOK);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

- (void)requestCancelGoodCollectionNetwork:(NSString *)goodId completion:(void (^)(BOOL isOK))completion failure:(void (^)())failure {
    ZFCartCancelCollectionApi *api = [[ZFCartCancelCollectionApi alloc] initWithGoodsId:goodId];
    [MBProgressHUD showLoadingView:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    __block BOOL _isOK = NO;
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                _isOK = YES;
                [MBProgressHUD showMessage:ZFLocalizedString(@"CartCancelFavoritesSuccessfully", nil)];
            }else{
                [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
            }
            
            if (completion) {
                completion(_isOK);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (failure) {
            failure(_isOK);
        }
    }];
}

- (void)requestUpdateCartNumNetworkWithNum:(NSInteger)goodNum goodId:(NSString *)goodId completion:(void (^)(BOOL isOK))completion {
    ZFCartEditGoodsApi *api = [[ZFCartEditGoodsApi alloc] initWithGoodNum:goodNum GoodId:goodId];
    [MBProgressHUD showLoadingView:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    __block BOOL _isOK = NO;
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                _isOK = YES;
            }else{
                [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
            }
            if (completion) {
                completion(_isOK);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (completion) {
            completion(_isOK);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

- (void)requestCartCheckOutNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    NSDictionary *dict = parmaters;
    ZFOrderCheckInfoApi *api = [[ZFOrderCheckInfoApi alloc] initWithPayCoder:[dict ds_stringForKey:@"payCode"] parametersArray:[dict ds_arrayForKey:@"order_info"]];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        NSArray<ZFOrderCheckInfoModel *> *dataArray = [NSArray yy_modelArrayWithClass:[ZFOrderCheckInfoModel class] json:requestJSON[@"result"]];
        // 谷歌统计
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingOrderDetail];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            if (completion && dataArray.count > 0) {
                completion(dataArray);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
        // 谷歌统计
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingOrderDetail];
    }];
    
}

- (void)requestCartFastPayNetworkWithPayertoken:(NSString *)payertoken payerId:(NSString *)payerId completion:(void (^)(BOOL hasAddress, id obj))completion failure:(void (^)(id obj))failure {
    FastSettleApi *api = [[FastSettleApi alloc] initWithPayertoken:payertoken payerId:payerId];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                switch ([requestJSON[@"result"][@"data"][@"flag"] integerValue]) {
                    case FastPaypalCheckTypeNoLoginAndNoRegiste:
                    case FastPaypalCheckTypeNoLoginAndRegistedAndNoAddress: {
                        //自动登录
                        AccountModel *userModel = [AccountModel yy_modelWithJSON:requestJSON[@"result"][@"data"][@"user"]];
                        [self fastCheckOutAutoLogin:userModel];
                        if (completion) {
                            completion(NO, [ZFAddressInfoModel yy_modelWithJSON:requestJSON[@"result"][@"data"][@"address"]]);
                        }
                    }
                        break;
                    case FastPaypalCheckTypeNoLoginAndRegistedAndHasAddress: {
                        //自动登录
                        AccountModel *userModel = [AccountModel yy_modelWithJSON:requestJSON[@"result"][@"data"][@"user"]];
                        [self fastCheckOutAutoLogin:userModel];
                        if (completion) {
                            completion(YES, [ZFOrderCheckInfoDetailModel yy_modelWithJSON:requestJSON[@"result"][@"data"][@"check"]]);
                        }
                    }
                        break;
                    case FastPaypalCheckTypeLoginAndNoAddress: {
                        if (completion) {
                            completion(NO, [ZFAddressInfoModel yy_modelWithJSON:requestJSON[@"result"][@"data"][@"address"]]);
                        }
                    }
                        break;
                    case FastPaypalCheckTypeLoginAndHasAddress: {
                        //根据返回的状态来确定
                        if (completion) {
                            completion(YES, [ZFOrderCheckInfoDetailModel yy_modelWithJSON:requestJSON[@"result"][@"data"][@"check"]]);
                        }
                    }
                        break;
                }
            }else{
                [MBProgressHUD showMessage:requestJSON[@"msg"]];
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

- (void)requestPaymentProcessCompletion:(void (^)(NSInteger state))completion failure:(void (^)(id obj))failure {
    [MBProgressHUD showLoadingView:nil];
    ZFCartPaymentProcessApi *api = [[ZFCartPaymentProcessApi alloc] init];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            NSDictionary *stateDict = [requestJSON ds_dictionaryForKey:@"result"];
            NSInteger state = [stateDict ds_integerForKey:@"checkout_flow"];
            if (completion) {
                completion(state);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - private methods
//自动登录
- (void)fastCheckOutAutoLogin:(AccountModel *)userModel {
    [[AccountManager sharedManager] updateUserInfo:userModel];
    [[NSUserDefaults standardUserDefaults] setValue:userModel.email forKey:kUserEmail];
#ifdef LeandCloudEnabled
    NSInteger user = [[[AccountManager sharedManager] userId] integerValue];
    AVInstallation *currentInstallationLeandcloud = [AVInstallation currentInstallation];
    [currentInstallationLeandcloud setObject:@(user) forKey:@"userId"];
    [currentInstallationLeandcloud setObject:@"YES" forKey:@"promotions"];
    [currentInstallationLeandcloud setObject:@"YES" forKey:@"orderMessages"];
    [currentInstallationLeandcloud setObject:[AppsFlyerTracker sharedTracker].getAppsFlyerUID forKey:@"appsFlyerId"];
    [currentInstallationLeandcloud setObject:[ZFLocalizationString shareLocalizable].nomarLocalizable forKey:@"language"];
    [currentInstallationLeandcloud saveInBackground];
#endif
    //登录通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:nil];
}

#pragma mark - deal with datas
- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[ZFCartListApi class]]) {
        return [ZFCartListModel yy_modelWithJSON:json];
    }
    return nil;
}

@end

