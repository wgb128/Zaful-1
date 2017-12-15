//
//  ZFOrderInformationViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderInformationViewModel.h"
#import "ZFOrderManager.h"
#import "ZFOrderCheckDoneModel.h"
#import "ZFOrderCheckDoneDetailModel.h"
#import "ZFOrderCheckInfoModel.h"
#import "ZFOrderCheckInfoDetailModel.h"
#import "UserCouponModel.h"
#import "ZFAddressInfoModel.h"
#import "ZFOrderCheckDoneApi.h"
#import "SendCodeApi.h"
#import "CartBadgeNumApi.h"
#import "ZFOrderCheckInfoApi.h"
#import "ZFPayMethodsSelectDoneApi.h"
#import "ZFCartPaymentProcessApi.h"
#import "AllCouponsApi.h"
#import "OrderMyCouponApi.h"

@implementation ZFOrderInformationViewModel

- (NSDictionary *)queryCheckoutInfoPublicParmas:(ZFOrderManager *)manager {
    return @{
             @"coupon"                  :   [NSStringUtils emptyStringReplaceNSNull:manager.couponCode],
             @"address_id"              :   [NSStringUtils emptyStringReplaceNSNull:manager.addressId],
             @"shipping"                :   [NSStringUtils emptyStringReplaceNSNull:manager.shippingId],
             @"insurance"               :   [NSStringUtils emptyStringReplaceNSNull:manager.insurance],
             @"currentPoint"            :   [NSStringUtils emptyStringReplaceNSNull:manager.currentPoint],
             @"payment"                 :   [NSStringUtils emptyStringReplaceNSNull:manager.paymentCode],
             //用于快速支付
             @"payertoken"              :   [NSStringUtils emptyStringReplaceNSNull:manager.payertoken],
             @"payerId"                 :   [NSStringUtils emptyStringReplaceNSNull:manager.payerId],
             @"node"                    :   NullFilter(manager.node),
             };
}

- (NSDictionary *)queryCheckDonePublicParmas:(ZFOrderManager *)manager {
    return @{
             @"coupon"                  :   [NSStringUtils emptyStringReplaceNSNull:manager.couponCode],
             @"address_id"              :   [NSStringUtils emptyStringReplaceNSNull:manager.addressId],
             @"shipping"                :   [NSStringUtils emptyStringReplaceNSNull:manager.shippingId],
             @"need_traking_number"     :   [NSStringUtils emptyStringReplaceNSNull:manager.need_traking_number],
             @"insurance"               :   [NSStringUtils emptyStringReplaceNSNull:manager.insurance],
             @"point"                   :   [NSStringUtils emptyStringReplaceNSNull:manager.currentPoint],
             @"payment"                 :   [NSStringUtils emptyStringReplaceNSNull:manager.paymentCode],
             @"verifyCode"              :   [NSStringUtils emptyStringReplaceNSNull:manager.verifyCode],
             @"bizhong"                 :   [NSStringUtils emptyStringReplaceNSNull:manager.bizhong],
             @"node"                    :   NullFilter(manager.node),
             @"order_id"                :   NullFilter(manager.orderID),
             //用于快速支付
             @"payertoken"              :   [NSStringUtils emptyStringReplaceNSNull:manager.payertoken],
             @"payerId"                 :   [NSStringUtils emptyStringReplaceNSNull:manager.payerId],
             //appflyer
             @"media_source"            :   [NSStringUtils getMediaSource],
             @"campaign"                :   [NSStringUtils getCampaign],
             @"wj_linkid"               :   [NSStringUtils getLkid],
             @"ad_id"                   :   [NSStringUtils getAdId], // 增加从appsflyer获取归因参数 并储存至网站后台
             //用于催付
             @"pid"                     : [NSStringUtils getPid],
             @"c"                       : [NSStringUtils getC],
             @"is_retargeting"          : [NSStringUtils getIsRetargeting],
             @"appsflyer_params"        : [self appflyerParamsString]
             };
}

- (NSArray *)queryCheckInfoRequestParmasWithPayCode:(NSInteger)paycode managerArray:(NSArray *)managerArray {
    NSMutableArray *array = [NSMutableArray array];
    if (paycode == 3) {
        ZFOrderManager *codOrderManager = managerArray.firstObject;
        NSMutableDictionary *codDict = [NSMutableDictionary dictionaryWithDictionary:[self queryCheckoutInfoPublicParmas:codOrderManager]];
        [codDict setObject:@"1" forKey:@"node"];
        
        ZFOrderManager *onlineOrderManager = managerArray.lastObject;
        NSMutableDictionary *onlineDict = [NSMutableDictionary dictionaryWithDictionary:[self queryCheckoutInfoPublicParmas:onlineOrderManager]];
        [onlineDict setObject:@"2" forKey:@"node"];
        
        [array addObject:codDict];
        [array addObject:onlineDict];
    }else{
        ZFOrderManager *manager = managerArray.firstObject;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self queryCheckoutInfoPublicParmas:manager]];
        [dict setObject: @(paycode) forKey:@"node"];
        [array addObject:dict];
    }
    return array;
}

- (NSArray *)queryCheckDoneRequestParmasWithPayCode:(NSInteger)paycode managerArray:(NSArray *)managerArray {
    NSMutableArray *array = [NSMutableArray array];
    if (paycode == 3) {
        ZFOrderManager *codOrderManager = managerArray.firstObject;
        NSMutableDictionary *codDict = [NSMutableDictionary dictionaryWithDictionary:[self queryCheckDonePublicParmas:codOrderManager]];
        [codDict setObject:@"1" forKey:@"node"];
        [codDict setObject:codOrderManager.isCod forKey:@"isCod"];

        ZFOrderManager *onlineOrderManager = managerArray.lastObject;
        NSMutableDictionary *onlineDict = [NSMutableDictionary dictionaryWithDictionary:[self queryCheckDonePublicParmas:onlineOrderManager]];
        [onlineDict setObject:@"2" forKey:@"node"];
        [onlineDict setObject:onlineOrderManager.isCod forKey:@"isCod"];
        
        [array addObject:codDict];
        [array addObject:onlineDict];
    }else{
        ZFOrderManager *manager = managerArray.firstObject;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self queryCheckDonePublicParmas:manager]];
        [dict setObject: @(paycode) forKey:@"node"];
        BOOL is_cod = [manager.paymentCode isEqualToString:@"Cod"] ? 1 : 0;
        [dict setObject:@(is_cod) forKey:@"isCod"];
        [array addObject:dict];
    }
    return array;
}

- (void)requestCheckDoneOrder:(id)parmaters completion:(void (^)(NSArray<ZFOrderCheckDoneModel *> *dataArray))completion failure:(void (^)(id))failure {
    [MBProgressHUD showLoadingView:nil];
    NSDictionary *dict = parmaters;
    ZFOrderCheckDoneApi *checkDoneApi = [[ZFOrderCheckDoneApi alloc] initWithPayCoder:[dict ds_stringForKey:@"payCode"] parametersArray:[dict ds_arrayForKey:@"order_info"]];
    [checkDoneApi startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(checkDoneApi.class)];
        if ([requestJSON[@"result"] isKindOfClass:[NSArray class]]) {
            NSArray<ZFOrderCheckDoneModel *> *dataArray = [NSArray yy_modelArrayWithClass:[ZFOrderCheckDoneModel class] json:requestJSON[@"result"]];
    
            if ([requestJSON[@"statusCode"] integerValue] == 200) {
                if (completion && dataArray.count > 0) {
                    completion(dataArray);
                }
            }
        }else{
            ZFOrderCheckDoneModel *doneModel = [[ZFOrderCheckDoneModel alloc] init];
            doneModel.order_info = [ZFOrderCheckDoneDetailModel yy_modelWithJSON:requestJSON[@"result"]];
            if ([requestJSON[@"statusCode"] integerValue] == 200) {
                if (completion && doneModel) {
                    completion(@[doneModel]);
                }
            }
 
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        ZFLog(@"\n-------------------------- 错误日志 --------------------------\n接口:%@\n状态码:%ld\n报错信息:%@",NSStringFromClass(request.class),request.responseStatusCode,request.responseString);
        if (failure) {
            failure(nil);
        }
    }];
}

- (void)requestCheckInfoNetwork:(id)parmaters completion:(void (^)(NSArray<ZFOrderCheckInfoModel *>* dataArray))completion failure:(void (^)(id))failure {
    [MBProgressHUD showLoadingView:nil];
    NSDictionary *dict = parmaters;
    ZFOrderCheckInfoApi *doneApi = [[ZFOrderCheckInfoApi alloc] initWithPayCoder:[dict ds_stringForKey:@"payCode"] parametersArray:[dict ds_arrayForKey:@"order_info"]];
    [doneApi startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(ZFOrderCheckInfoApi.class)];
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

- (void)requestPaymentProcessCompletion:(void (^)(NSInteger state))completion failure:(void (^)(id obj))failure {
    ZFCartPaymentProcessApi *api = [[ZFCartPaymentProcessApi alloc] init];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            NSDictionary *stateDict = [requestJSON ds_dictionaryForKey:@"result"];
            NSInteger state = [stateDict ds_integerForKey:@"checkout_flow"];
            if (completion) {
                completion(state);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        
    }];
}

- (void)sendPhoneCod:(NSString *)addressID completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    SendCodeApi *api = [[SendCodeApi alloc] initWithAddressID:addressID];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
         [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) { // 成功收到验证码
                if (completion) {
                    completion(nil);
                }
            }else{
                // 显示错误信息
                [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        
    }];
}

- (void)requestAllCouponsNetworkCompletion:(void (^)(NSArray *couponsArray))completion {
    AllCouponsApi *api = [[AllCouponsApi alloc] init];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            NSArray *array = [NSArray yy_modelArrayWithClass:[UserCouponModel class] json:requestJSON[@"result"]];
            if (completion) {
                completion(array);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

- (void)checkEffectiveCoupon:(NSString *)couponCode parmas:(NSDictionary *)parmas completion:(void (^)(id obj))completion failure:(void (^)())failure {
    OrderMyCouponApi *api = [[OrderMyCouponApi alloc] initWithCouponCode:couponCode];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                [self requestCheckInfoNetwork:parmas completion:^(NSArray<ZFOrderCheckInfoModel *> *dataArray) {
                    if ([requestJSON[@"statusCode"] integerValue] == 200) {
                        if (completion && dataArray.count > 0) {
                            completion(dataArray);
                        }
                    }
                } failure:^(id obj) {
                    if (failure) {
                        failure();
                    }
                }];
            }else{
                if([NSStringUtils isEmptyString:[NSString stringWithFormat:@"%@",requestJSON[@"result"][@"msg"]]]) {
                    [MBProgressHUD showMessage:ZFLocalizedString(@"OrderInfoViewModel_valid_coupon_tip", nil)];
                } else {
                    [MBProgressHUD showMessage:[NSString stringWithFormat:@"%@",requestJSON[@"result"][@"msg"]] icon:@"coupon_ico_face"];
//                    [MBProgressHUD showMessage:[NSString stringWithFormat:@"%@",requestJSON[@"result"][@"msg"]]];
                }
                if (failure) {
                    failure();
                }
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
        if (failure) {
            failure();
        }
    }];
}

- (void)requestCartBadgeNum {
    CartBadgeNumApi *api = [[CartBadgeNumApi alloc] init];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            [[NSUserDefaults standardUserDefaults] setValue:@([requestJSON[@"result"] integerValue]) forKey:kCollectionBadgeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        
    }];
}

- (NSString *)appflyerParamsString {
    NSMutableString *params = [NSMutableString new];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appflyerDict   = [userDefaults objectForKey:APPFLYER_ALL_PARAMS];
    for (NSString *key in appflyerDict.allKeys) {
        NSString *value = [appflyerDict ds_stringForKey:key];
        [params appendFormat:@"%@=%@", key, value];
        if (![key isEqualToString:appflyerDict.allKeys.lastObject]) {
            [params appendString:@"##"];
        }
    }
    return params;
}

@end
