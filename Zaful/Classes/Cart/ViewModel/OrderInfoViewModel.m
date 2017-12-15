//
//  OrderInfoViewModel.m
//  Zaful
//
//  Created by TsangFa on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "OrderInfoViewModel.h"

#import "CartOrderInfoViewController.h"
#import "ZFAddressViewController.h"
#import "CartInfoGoodsViewController.h"
#import "MyOrdersListViewController.h"
#import "OrderFinishViewController.h"
#import "OrderFailureViewController.h"

#import "CartCreateOrderModel.h"
#import "CartCheckOutModel.h"
#import "ShippingListModel.h"
#import "PaymentListModel.h"
#import "ZFAddressInfoModel.h"
#import "OrderInfoManager.h"
#import "FilterManager.h"
#import "CheckOutGoodListModel.h"

#import "AllCouponsApi.h"
#import "OrderMyCouponApi.h"
#import "CreateOrderApi.h"
#import "CartCheckOutApi.h"
#import "CheckOrderStatusApi.h"
#import "CartBadgeNumApi.h"
#import "SendCodeApi.h"

#import "CartInfoAddressCell.h"
#import "CartInfoShippingCell.h"
#import "CartInfoNoShippingCell.h"
#import "CartInfoInsuranceCell.h"
#import "CartInfoPaymentCell.h"
#import "CartInfoNoPaymentCell.h"
#import "CartInfoRewardsCell.h"
#import "CartInfoCouponCell.h"
#import "CartInfoTotalCell.h"
#import "CartInfoGoodsCell.h"
#import "CartInfoPlaceOrderCell.h"

#import "MyCouponPickerView.h"
#import "ZFPaymentView.h"
#import "VerificationView.h"
#import "OtherAlertView.h"

#import "BoletoFinishedViewController.h"
#import "ZFOrderInfoFooterView.h"
#import "ZFWebViewViewController.h"

@interface OrderInfoViewModel ()
@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) OrderInfoManager *manager;
@property (nonatomic, strong) CartCreateOrderModel *orderModel;
@property (nonatomic, strong) ZFOrderInfoFooterView   *footerView;
@end

@implementation OrderInfoViewModel

#pragma mark - Setter
- (void)setCheckOutModel:(CartCheckOutModel *)checkOutModel {

    if (!_checkOutModel) {
        // 默认勾选物流保险费用
        checkOutModel.ifNeedInsurance = YES;
    } else {
        checkOutModel.ifNeedInsurance = _checkOutModel.ifNeedInsurance;
    }
    
    _checkOutModel = checkOutModel;

    //判断是否支持货到付款，把当前国家对应的货币存储到本地临时变量
    NSString *currency = [FilterManager isSupportCOD:checkOutModel.address_info.country_id];
    if (![NSStringUtils isEmptyString:currency]) {
        [FilterManager saveTempFilter:currency];
    }
    
    //下面的判断是修改之前的一个BUG
    if ([NSArrayUtils isEmptyArray:checkOutModel.payment_list]) {
        [FilterManager saveTempCOD:NO];
    } else {
        [checkOutModel.payment_list enumerateObjectsUsingBlock:^(PaymentListModel *paymentModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([paymentModel.default_select boolValue]) {
                [FilterManager saveTempCOD:[paymentModel.pay_code isEqualToString:@"Cod"] ? YES : NO];
            }
            
            if ([paymentModel.default_select boolValue]) {
                self.manager.paymentCode = paymentModel.pay_code;
                if ([paymentModel.pay_code isEqualToString:@"Cod"]) {
                    self.manager.codFreight = checkOutModel.cod.codFee;
                }else{
                    self.manager.codFreight = @"0.00";
                }
            }
            
        }];
    }
    
    // 配置cell个数
    {
        [self.sectionArray removeAllObjects];

        [self.sectionArray addObject:@[[CartInfoAddressCell class]]];
        
        [self.sectionArray addObject:@[[CartInfoGoodsCell class]]];
        
        if (checkOutModel.shipping_list.count == 0) {
            [self.sectionArray addObject:@[[CartInfoNoShippingCell class],[CartInfoInsuranceCell class]]];
        } else {
            [self.sectionArray addObject:@[[CartInfoShippingCell class],[CartInfoInsuranceCell class]]];
        }
        
        if (checkOutModel.payment_list.count == 0) {
            [self.sectionArray addObject:@[[CartInfoNoPaymentCell class]]];
        } else {
            [self.sectionArray addObject:@[[CartInfoPaymentCell class]]];
        }
        
        if ([checkOutModel.point.avail_point floatValue] >= 50) {
            [self.sectionArray addObject:@[[CartInfoRewardsCell class]]];
        }
       
        [self.sectionArray addObject:@[[CartInfoCouponCell class]]];
        [self.sectionArray addObject:@[[CartInfoTotalCell class]]];
        [self.sectionArray addObject:@[[CartInfoPlaceOrderCell class]]];
    }
    
    // 初始化小mdel
    {
        self.manager.couponCode = checkOutModel.total.coupon_code;
        self.manager.addressId = checkOutModel.address_info.address_id;
        self.manager.need_traking_number = checkOutModel.total.need_traking_number;
        self.manager.insurance = checkOutModel.ifNeedInsurance ? checkOutModel.total.insure_fee : @"0.00";
        self.manager.goods_price = checkOutModel.total.goods_price;
        self.manager.couponAmount = checkOutModel.total.coupon_amount;
        //用于快速支付
        self.manager.payertoken = checkOutModel.payertoken;
        self.manager.payerId = checkOutModel.payerId;
        
        if ([self.checkOutModel.point.avail_point floatValue] >= 50) {
            self.manager.currentPoint = checkOutModel.point.currentPoint;
            self.manager.pointSavePrice = [NSString stringWithFormat:@"%.2f",[self.checkOutModel.point.currentPoint floatValue] * 0.02];
        }
        
        [checkOutModel.shipping_list enumerateObjectsUsingBlock:^(ShippingListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.default_select boolValue]) {
                self.manager.shippingId = model.iD;
                self.manager.shippingPrice = model.ship_price;
            }
        }];
        
        self.manager.countryID = checkOutModel.address_info.country_id;
        
        self.manager.activities_amount = checkOutModel.total.activities_amount;
    }
}

#pragma mark - Coupon Request
//请求所有Coupon
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

//验证Coupon
- (void)requestApplyMyCouponNetwork:(NSString *)couponCode tableView:(UITableView *)tableView view:(MyCouponPickerView *)pickerView {
    @weakify(tableView)
    @weakify(pickerView)
    NSString *tempCouponCode = [self.manager.couponCode copy];
    self.manager.couponCode = couponCode;
    if ([NSStringUtils isEmptyString:couponCode]) {
        [self requestCartCheckOutNetwork:self.manager completion:^(id obj){
            self.checkOutModel = obj;
            @strongify(tableView)
            [tableView reloadData];
            @strongify(pickerView)
            [pickerView removeFromSuperview];
        } failure:^{
            self.manager.couponCode = tempCouponCode;
            @strongify(pickerView)
            [pickerView removeFromSuperview];
        }];
    } else {
        OrderMyCouponApi *api = [[OrderMyCouponApi alloc] initWithCouponCode:couponCode];
        [MBProgressHUD showLoadingView:nil];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            [MBProgressHUD hideHUD];
            id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
            if ([requestJSON[@"statusCode"] integerValue] == 200){
                if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                    @strongify(tableView)
                    @weakify(tableView)
                    [self requestCartCheckOutNetwork:self.manager completion:^(id obj){
                        self.checkOutModel = obj;
                        @strongify(tableView)
                        [tableView reloadData];
                    } failure:^{
                        self.manager.couponCode = tempCouponCode;
                    }];
                }else{
                    if([NSStringUtils isEmptyString:[NSString stringWithFormat:@"%@",requestJSON[@"result"][@"msg"]]]) {
                        
                        [MBProgressHUD showMessage:ZFLocalizedString(@"OrderInfoViewModel_valid_coupon_tip", nil)];
                    }else{
                        [MBProgressHUD showMessage:[NSString stringWithFormat:@"%@",requestJSON[@"result"][@"msg"]]];
                    }
                    self.manager.couponCode = tempCouponCode;
                }
                @strongify(pickerView)
                [pickerView removeFromSuperview];
            }
            
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
            self.manager.couponCode = tempCouponCode;
        }];
    }
}

//checkout
- (void)requestCartCheckOutNetwork:(OrderInfoManager *)manager completion:(void (^)(id obj))completion failure:(void (^)())failure {
    CartCheckOutApi *api = [[CartCheckOutApi alloc] initWithManager:manager];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            id checkoutModel = [CartCheckOutModel yy_modelWithJSON:requestJSON[@"result"]];
            if (completion) {
                completion(checkoutModel);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        ZFLog(@"\n-------------------------- 错误日志 --------------------------\n接口:%@\n状态码:%ld\n报错信息:%@",NSStringFromClass(request.class),request.responseStatusCode,request.responseString);
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
        if (failure) {
            failure();
        }
    }];
}

#warning delete order status 此处把订单支付完成后请求后台请求状态的接口消释，直接根据支付状态显示成功或者失败
//创建订单
- (void)createOrderSuccess:(void (^)())success failure:(void (^)())failure {
    
    NSString *str;
    if ( ([FilterManager isSupportCOD:_manager.countryID] && [_manager.paymentCode isEqualToString:@"Cod"])) {
        if ([NSStringUtils isEmptyString:[FilterManager isSupportCOD:_manager.countryID]]) {
            str = [ExchangeManager localCurrencyName];
        }else{
            str = [FilterManager isSupportCOD:_manager.countryID];
        }
    } else {
        str = [ExchangeManager localCurrencyName];
    }
    self.manager.bizhong = str;
    
    CreateOrderApi *api = [[CreateOrderApi alloc] initWithDict:self.manager];
    [api.accessoryArray addObject:[RequestAccessory showLoadingView:nil]];
    @weakify(self)
    [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kStartLoadingCreateOrder];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        @strongify(self)
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingCreateOrder];
        [[NSNotificationCenter defaultCenter] postNotificationName:kCartNotification object:nil];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                self.orderModel = [CartCreateOrderModel yy_modelWithJSON:requestJSON[@"result"]];
                NSString *payMethod = self.orderModel.pay_method;
                
                // 统计字段
                NSMutableString *goodsStr = [NSMutableString string];
                for (int i = 0; i < self.checkOutModel.cart_goods.goods_list.count; i++) {
                    CheckOutGoodListModel *goodsModel = self.checkOutModel.cart_goods.goods_list[i];
                    [goodsStr appendString:goodsModel.goods_sn];
                    if (self.checkOutModel.cart_goods.goods_list.count != 1 && i != self.checkOutModel.cart_goods.goods_list.count - 1) {
                        [goodsStr appendString:@","];
                    }
                }
                
                dispatch_async(dispatch_queue_create([[[NSDate date] description] UTF8String], NULL), ^{
                    //增加支付方式统计
                    if (![NSStringUtils isEmptyString:payMethod]) {
                        if([requestJSON[@"result"][@"flag"] integerValue] == FastPaypalOrderTypeSuccess ||  [requestJSON[@"result"][@"flag"] integerValue] == FastPaypalOrderTypeFail) {
                            [ZFAnalytics clickButtonWithCategory:@"Payment Method" actionName:@"FastPayment" label:@"FastPayment"];
                        } else {
                            [ZFAnalytics clickButtonWithCategory:@"Payment Method" actionName:payMethod label:payMethod];
                        }
                    }
                });
                
                switch ([requestJSON[@"result"][@"flag"] integerValue]) {
                        //快速付款成功
                    case FastPaypalOrderTypeSuccess: {
                        // 触发Appsfyer广告追踪的收入统计事件
                        [ZFAnalytics appsFlyerTrackFinishOrderSn:self.orderModel.order_sn orderRealPay:self.orderModel.order_amount goodsIds:goodsStr payMethod:payMethod];
                        
                        OrderFinishViewController *finischVC = [[OrderFinishViewController alloc] init];
                        finischVC.orderSn = self.orderModel.order_sn;
                        @weakify(finischVC)
                        finischVC.toAccountOrHomeblock = ^(BOOL gotoAccount){ //跳转到Accont或是Home
                            @strongify(finischVC)
                            [finischVC dismissViewControllerAnimated:YES completion:nil];
                            if (gotoAccount) {
                                [self jumpToAccountOrderListWithOrderStatus:PaymentStatusDone];
                                [ZFAnalytics clickButtonWithCategory:@"Payment Success" actionName:@"Payment Success - My Account" label:@"Payment Success - My Account"];
                            }else{
                                ZFTabBarController *tabBarVC = APPDELEGATE.tabBarVC;
                                UINavigationController *navVC = tabBarVC.selectedViewController;
                                [navVC popToRootViewControllerAnimated:YES];
                                tabBarVC.selectedIndex = TabBarIndexHome;
                                [ZFAnalytics clickButtonWithCategory:@"Payment Success" actionName:@"Payment Success - Return to Home" label:@"Payment Success - Return to Home"];
                            }
                            [ZFAnalytics settleInfoProcedureWithProduct:self.checkOutModel.cart_goods.goods_list step:3 option:nil screenName:@"PaySuccess"];
                            [ZFAnalytics trasactionInfoWithProduct:self.checkOutModel.cart_goods.goods_list order:self.orderModel screenName:@"PaySuccess"];
                        };
                        [self.controller presentViewController:finischVC animated:YES completion:nil];
                    }
                        break;
                        //快速付款失败
                    case FastPaypalOrderTypeFail: {
                        OrderFailureViewController *failureVC = [[OrderFailureViewController alloc] init];
                        @weakify(failureVC)
                        failureVC.toAccountOrHomeblock = ^(BOOL gotoAccount){ //跳转到Accont或是Home
                            @strongify(failureVC)
                            if (gotoAccount) {
                                [failureVC dismissViewControllerAnimated:YES completion:nil];
                                [self jumpToAccountOrderListWithOrderStatus:PaymentStatusFail];
                                [ZFAnalytics clickButtonWithCategory:@"Payment Failure" actionName:@"Payment Failure - My Account" label:@"Payment Failure - My Account"];
                            }
                            [ZFAnalytics settleInfoProcedureWithProduct:self.checkOutModel.cart_goods.goods_list step:3 option:nil screenName:@"PayFailure"];
                            [ZFAnalytics trasactionInfoWithProduct:self.checkOutModel.cart_goods.goods_list order:self.orderModel screenName:@"PayFailure"];
                        };
                        [self.controller presentViewController:failureVC animated:YES completion:nil];
                    }
                        break;
                        //普通付款
                    case FastPaypalOrderTypeCommon: {
                        // 统计
                        NSMutableString *goodsStr = [NSMutableString string];
                        for (CheckOutGoodListModel *goodsModel in self.checkOutModel.cart_goods.goods_list) {
                            [goodsStr appendString:goodsModel.goods_sn];
                        }
                        [ZFAnalytics appsFlyerTrackEvent:@"af_create_order_success" withValues:@{
                                                                                                 @"content_ids" : goodsStr,
                                                                                                 @"content_type" : payMethod,
                                                                                                 @"order_ids" : self.orderModel.order_sn
                                                                                                 }];
                        
                        if ([payMethod isEqualToString:@"PayPal"] || [payMethod isEqualToString:@"WorldPay"] || [payMethod isEqualToString:@"CheckoutCredit"]  || [payMethod isEqualToString:@"boletoBancario"] ) {
                            ZFPaymentView *ppView = [[ZFPaymentView alloc] initWithFrame:CGRectZero];
                            ppView.url = self.orderModel.pay_url;
                            @weakify(self);
                            ppView.block = ^(PaymentStatus status){
                                @strongify(self)
                                switch (status) {
                                    case PaymentStatusCancel:
                                    {
                                        [self jumpToAccountOrderListWithOrderStatus:PaymentStatusCancel];
                                        break;
                                    }
                                    case PaymentStatusDone:
                                    {
                                        // 触发Appsfyer广告追踪的收入统计事件
                                        [ZFAnalytics appsFlyerTrackFinishOrderSn:self.orderModel.order_sn orderRealPay:self.orderModel.order_amount goodsIds:goodsStr payMethod:payMethod];
                                        
//                                        if ([payMethod isEqualToString:@"boletoBancario"]) {
//                                            [self jumpToBoletoFinishedViewController];
//                                        }else{
                                            OrderFinishViewController *finischVC = [[OrderFinishViewController alloc] init];
                                            finischVC.orderSn = self.orderModel.order_sn;
                                            @weakify(finischVC)
                                            finischVC.toAccountOrHomeblock = ^(BOOL gotoAccount){ //跳转到Accont或是Home
                                                @strongify(finischVC)
                                                [finischVC dismissViewControllerAnimated:YES completion:nil];
                                                if (gotoAccount) {
                                                    [self jumpToAccountOrderListWithOrderStatus:PaymentStatusDone];
                                                    [ZFAnalytics clickButtonWithCategory:@"Payment Success" actionName:@"Payment Success - My Account" label:@"Payment Success - My Account"];
                                                }else{
                                                    ZFTabBarController *tabBarVC = APPDELEGATE.tabBarVC;
                                                    UINavigationController *navVC = tabBarVC.selectedViewController;
                                                    [navVC popToRootViewControllerAnimated:YES];
                                                    tabBarVC.selectedIndex = TabBarIndexHome;
                                                    [ZFAnalytics clickButtonWithCategory:@"Payment Success" actionName:@"Payment Success - Return to Home" label:@"Payment Success - Return to Home"];
                                                }
                                                [ZFAnalytics settleInfoProcedureWithProduct:self.checkOutModel.cart_goods.goods_list step:3 option:nil screenName:@"PaySuccess"];
                                                [ZFAnalytics trasactionInfoWithProduct:self.checkOutModel.cart_goods.goods_list order:self.orderModel screenName:@"PaySuccess"];
                                            };
                                            [self.controller presentViewController:finischVC animated:YES completion:nil];
//                                        }
                                        break;
                                    }
                                    case PaymentStatusUnknown:
                                    case PaymentStatusFail:
                                    {
                                        OrderFailureViewController *failureVC = [[OrderFailureViewController alloc] init];
                                        @weakify(failureVC)
                                        failureVC.toAccountOrHomeblock = ^(BOOL gotoAccount){ //跳转到Accont或是Home
                                            @strongify(failureVC)
                                            if (gotoAccount) {
                                                [failureVC dismissViewControllerAnimated:YES completion:nil];
                                                [self jumpToAccountOrderListWithOrderStatus:PaymentStatusFail];
                                                [ZFAnalytics clickButtonWithCategory:@"Payment Failure" actionName:@"Payment Failure - My Account" label:@"Payment Failure - My Account"];
                                            }
                                            [ZFAnalytics settleInfoProcedureWithProduct:self.checkOutModel.cart_goods.goods_list step:3 option:nil screenName:@"PayFailure"];
                                            [ZFAnalytics trasactionInfoWithProduct:self.checkOutModel.cart_goods.goods_list order:self.orderModel screenName:@"PayFailure"];
                                        };
                                        [self.controller presentViewController:failureVC animated:YES completion:nil];
                                        
                                        break;
                                    }
                                }
                            };
                            [ppView show];
                            return;
                        }else if ([payMethod isEqualToString:@"Cod"]) {// 货到付款
                            if (success) {
                                //移除手机验证码弹出窗口
                                success();
                            }
                            
                            // 触发Appsfyer广告追踪的收入统计事件
                            [ZFAnalytics appsFlyerTrackFinishOrderSn:self.orderModel.order_sn orderRealPay:self.orderModel.order_amount goodsIds:goodsStr payMethod:payMethod];
                            
                            NSString *paymentAccount;
                            
                            
                            switch ([self.orderModel.cod_orientation integerValue]) {
                                case CashOnDeliveryTruncTypeDefault:
                                {
                                    paymentAccount = [NSString stringWithFormat:@"%@%@",_orderModel.multi_order_amount,[ExchangeManager symbolOfCurrency:[FilterManager tempCurrency]]];
                                }
                                    break;
                                case CashOnDeliveryTruncTypeUp:
                                case CashOnDeliveryTruncTypeDown:
                                {
                                    paymentAccount = [self codIntegerWith:_orderModel.multi_order_amount];
                                    
                                }
                                    break;
                            }
                            
                            OrderFinishViewController *finischVC = [[OrderFinishViewController alloc] init];
                            finischVC.isVerifcation = YES;
                            finischVC.orderSn = self.orderModel.order_sn;
                            finischVC.paymentAccount = paymentAccount;
                            @weakify(finischVC)
                            finischVC.toAccountOrHomeblock = ^(BOOL gotoAccount){ //跳转到Accont或是Home
                                //清空临时存储的货币
                                [FilterManager removeCurrency];
                                [FilterManager removeCOD];
                                
                                @strongify(finischVC)
                                
                                [finischVC dismissViewControllerAnimated:YES completion:nil];
                                if (gotoAccount) {
                                    [self jumpToAccountOrderListWithOrderStatus:PaymentStatusDone];
                                    [ZFAnalytics clickButtonWithCategory:@"Payment Success" actionName:@"Payment Success - My Account" label:@"Payment Success - My Account"];
                                }else{
                                    ZFTabBarController *tabBarVC = APPDELEGATE.tabBarVC;
                                    UINavigationController *navVC = tabBarVC.selectedViewController;
                                    [navVC popToRootViewControllerAnimated:YES];
                                    tabBarVC.selectedIndex = TabBarIndexHome;
                                    [ZFAnalytics clickButtonWithCategory:@"Payment Success" actionName:@"Payment Success - Return to Home" label:@"Payment Success - Return to Home"];
                                }
                            };
                            [self.controller.navigationController presentViewController:finischVC animated:YES completion:nil];
                        }
                        [ZFAnalytics settleInfoProcedureWithProduct:self.checkOutModel.cart_goods.goods_list step:2 option:nil screenName:@"Pay"];
                    }
                        break;
                    default:
                        break;
                }
                //更新购物车数据
                [self requestCartBadgeNum];
                
            }else{
                if (failure) { //回调显示手机验证码错误
                    failure();
                } else {
                    [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
                }
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        ZFLog(@"\n-------------------------- 错误日志 --------------------------\n接口:%@\n状态码:%ld\n报错信息:%@",NSStringFromClass(request.class),request.responseStatusCode,request.responseString);
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingCreateOrder];
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

#pragma mark - TableView DataSource and Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.sectionArray.count-1) {
        self.footerView.model = self.checkOutModel.footer;
        return self.footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section != self.sectionArray.count - 1 ? CGFLOAT_MIN : 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.sectionArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Class class = self.sectionArray[indexPath.section][indexPath.row];
    @weakify(self)
    @weakify(tableView)
    if (class == [CartInfoAddressCell class]) {
        CartInfoAddressCell *addressCell = [CartInfoAddressCell addressCellWithTableView:tableView indexPath:indexPath];
        addressCell.addressModel = self.checkOutModel.address_info;
        return addressCell;
    }
    
    if (class == [CartInfoGoodsCell class]) {
        CartInfoGoodsCell *addressCell = [CartInfoGoodsCell goodsCellWithTableView:tableView indexPath:indexPath];
        addressCell.goodsList = self.checkOutModel.cart_goods.goods_list;
        return addressCell;
    }
    
    if (class == [CartInfoNoShippingCell class]) {
        CartInfoNoShippingCell *noShippingCell = [CartInfoNoShippingCell noShippingCellWithTableView:tableView indexPath:indexPath];
        return noShippingCell;
    }
    
    if (class == [CartInfoShippingCell class]) {
        CartInfoShippingCell *shippingCell = [CartInfoShippingCell shippingCellWithTableView:tableView indexPath:indexPath];
        shippingCell.shippingListAry = self.checkOutModel.shipping_list;
        shippingCell.selectedTouchBlock = ^(ShippingListModel *listModel){
            @strongify(self)
            self.manager.shippingId = listModel.iD;
            self.manager.shippingPrice = listModel.ship_price;
            @strongify(tableView)
            [tableView reloadData];
        };
        return shippingCell;
    }
    
    if (class == [CartInfoInsuranceCell class]) {
        CartInfoInsuranceCell *insuranceCell = [CartInfoInsuranceCell insuranceCellWithTableView:tableView indexPath:indexPath];
        insuranceCell.insuranceValue = @[self.checkOutModel.total.insure_fee,@(self.checkOutModel.ifNeedInsurance)];
        @weakify(insuranceCell)
        insuranceCell.checkTouchBlock = ^(BOOL isSelected){
            @strongify(self)
            @strongify(insuranceCell)
            self.checkOutModel.ifNeedInsurance = isSelected;
            insuranceCell.insuranceValue = @[self.checkOutModel.total.insure_fee,@(self.checkOutModel.ifNeedInsurance)];
            self.manager.insurance = !isSelected ? @"0.00" : self.checkOutModel.total.insure_fee;
            @strongify(tableView)
            [tableView reloadData];
        };
        return insuranceCell;
    }
    
    if (class == [CartInfoNoPaymentCell class]) {
        CartInfoNoPaymentCell *noPaymentCell = [CartInfoNoPaymentCell noPaymentCellWithTableView:tableView indexPath:indexPath];
        return noPaymentCell;
    }
    
    if (class == [CartInfoPaymentCell class]) {
        CartInfoPaymentCell *paymentCell = [CartInfoPaymentCell paymentCellWithTableView:tableView indexPath:indexPath];
        paymentCell.paymentListAry = self.checkOutModel.payment_list;
        paymentCell.selectedTouchBlock = ^(PaymentListModel *listModel){
            
            //如果商品总额小于50 或 大于400 要做提示
            @strongify(self)
            @weakify(self)
            @strongify(tableView)
            @weakify(tableView)
            if ([listModel.pay_code isEqualToString:@"Cod"] &&
                ([self.manager.goods_price floatValue] < [self.checkOutModel.cod.totalMin floatValue]
                 || [self.manager.goods_price floatValue] > [self.checkOutModel.cod.totalMax floatValue]))
            {
                [self showCODLimitAlert];
                @strongify(tableView)
                [tableView reloadData];
                return;
            } else {
                //上次选中与这次是否是同一类型
                BOOL isChange = !([FilterManager tempCOD] == ([listModel.pay_code isEqualToString:@"Cod"] ? YES : NO));
                
                [FilterManager saveTempCOD:[listModel.pay_code isEqualToString:@"Cod"] ? YES : NO];
                [self.checkOutModel.shipping_list enumerateObjectsUsingBlock:^(ShippingListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    @strongify(self)
                    @weakify(self)
                    if ([obj.is_cod_ship boolValue] == [FilterManager tempCOD] && isChange) {
                        // 刷新物流方式默认选中
                        @strongify(self)
                        [self.checkOutModel.shipping_list setValue:@(NO) forKeyPath:@"default_select"];
                        obj.default_select = @"1";
                        self.manager.shippingId = obj.iD;
                        self.manager.shippingPrice = obj.ship_price;
                        *stop = YES;
                    }
                }];
                
                // 刷新付款方式
                [self.checkOutModel.payment_list setValue:@(NO) forKeyPath:@"default_select"];
                listModel.default_select = @"1";
                self.manager.paymentCode = listModel.pay_code;
                self.manager.codFreight = [listModel.pay_code isEqualToString:@"Cod"] ? self.checkOutModel.cod.codFee : @"0.00";
                @strongify(tableView)
                [tableView reloadData];
            }
        };
        return paymentCell;
    }
    
    if (class == [CartInfoRewardsCell class]) {
        CartInfoRewardsCell *rewardsCell = [CartInfoRewardsCell rewardsCellWithTableView:tableView indexPath:indexPath];
        rewardsCell.model = self.checkOutModel.point;
        rewardsCell.inputRewardBlock = ^(NSString *savePrice, NSString *inputReward){
            @strongify(self)
            self.checkOutModel.point.currentPoint = inputReward;
            self.manager.pointSavePrice = savePrice;
            self.manager.currentPoint = inputReward;
            @strongify(tableView)
            [tableView reloadData];
        };
        return rewardsCell;
    }
    
    if (class == [CartInfoCouponCell class]) {
        CartInfoCouponCell *couponCell = [CartInfoCouponCell couponCellWithTableView:tableView indexPath:indexPath];
        couponCell.couponString = self.manager.couponAmount;
        return couponCell;
    }
    
    if (class == [CartInfoTotalCell class]) {
        CartInfoTotalCell *totalCell = [CartInfoTotalCell totalCellWithTableView:tableView indexPath:indexPath];
        totalCell.manager = self.manager;
        return totalCell;
    }
    
    if (class == [CartInfoPlaceOrderCell class]) {
        CartInfoPlaceOrderCell *placeOrderCell = [CartInfoPlaceOrderCell placeOrderCellWithTableView:tableView indexPath:indexPath];
        placeOrderCell.placeOrderBlock = ^{
            [ZFAnalytics clickButtonWithCategory:@"Order" actionName:@"Order - Place Order" label:@"Order - Place Order"];
            [self jumpToPayment];
        };
        return placeOrderCell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class class = self.sectionArray[indexPath.section][indexPath.row];
    
    @weakify(self);
    
    if (class == [CartInfoAddressCell class]) {
        ZFAddressViewController *enterVC = [[ZFAddressViewController alloc] init];
        enterVC.showType = AddressInfoShowTypeCart;
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:enterVC];
        enterVC.addressChooseCompletionHandler  = ^(ZFAddressInfoModel *model){
            @strongify(self);
            NSString *tempAddressId = [self.manager.addressId copy];
            
            if ([NSStringUtils isEmptyString:[FilterManager isSupportCOD:self.manager.countryID]] != [NSStringUtils isEmptyString:[FilterManager isSupportCOD:model.country_id]]) {
                self.manager.paymentCode = @"";
                self.manager.shippingId = @"";
            }
            
            self.manager.addressId = model.address_id;
            self.manager.countryID = model.country_id;
            //  切换地址完成后,重新请求对应地址的Check out信息,刷新界面
            [self requestCartCheckOutNetwork:self.manager completion:^(id obj){
                @strongify(self);
                self.checkOutModel = obj;
                [tableView reloadData];
            } failure:^{
                @strongify(self);
                self.manager.addressId = tempAddressId;
            }];
            
        };
        [self.controller presentViewController:nav animated:YES completion:nil];
        [ZFAnalytics clickButtonWithCategory:@"Order" actionName:@"Order - Address" label:@"Order - Address"];
        return;
    }
    
    if (class == [CartInfoGoodsCell class]) {
        CartInfoGoodsViewController *goodsVC = [[CartInfoGoodsViewController alloc] init];
        goodsVC.goodsList = self.checkOutModel.cart_goods.goods_list;
        [self.controller.navigationController pushViewController:goodsVC animated:YES];
        return;
    }
    
    if (class == [CartInfoCouponCell class]) {
        [self requestAllCouponsNetworkCompletion:^(NSArray *couponsArray) {
            @strongify(self)
            MyCouponPickerView *pickerView = [[MyCouponPickerView alloc] init];
            pickerView.backgroundColor = [UIColor clearColor];
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow addSubview:pickerView];
            [pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
            pickerView.titleLabel.text = [NSString stringWithFormat:@"%@(%d)",ZFLocalizedString(@"CartOrderInfo_MyCouponPickerView_Title",nil),(int)couponsArray.count];
            pickerView.dataSource = couponsArray;
            @weakify(pickerView)
            pickerView.selectedFinishBlock = ^(NSString *codeString){
                @strongify(pickerView)
                [self requestApplyMyCouponNetwork:codeString tableView:tableView view:pickerView];
            };
            [pickerView layoutSubviews];
            [ZFAnalytics clickButtonWithCategory:@"Order" actionName:@"Order - Coupon" label:@"Order - Coupon"];
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

#pragma mark - Payment
- (void)jumpToPayment {
    
    if (self.checkOutModel.shipping_list.count == 0) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"CartOrderInfoViewModel_PlaceOrder_NoShipping",nil)];
        return ;
    }
    
    if (self.checkOutModel.payment_list.count == 0) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"CartOrderInfoViewModel_PlaceOrder_NoPayment",nil)];
        return ;
    }
    
    // 支持货到付款
    NSString *currency = [FilterManager tempCurrency];
    if (![NSStringUtils isEmptyString:currency] && [self.manager.paymentCode isEqualToString:@"Cod"]) {
        CGFloat num = [self.manager.goods_price floatValue]    +
        [self.manager.shippingPrice floatValue]  +
        [self.manager.codFreight floatValue]     +
        [self.manager.insurance floatValue]      -
        [self.manager.couponAmount floatValue]   -
        [self.manager.pointSavePrice floatValue] -
        [self.manager.activities_amount floatValue];
        
        NSString *title;
        switch ([FilterManager cashOnDeliveryTruncType:self.manager.countryID]) {
            case CashOnDeliveryTruncTypeUp:
            {
                title = [NSString stringWithFormat:@"%@",[ExchangeManager transforCeilPrice:[NSString stringWithFormat:@"%lf",num] currency:[FilterManager tempCurrency]]];
            }
                break;
            case CashOnDeliveryTruncTypeDefault:
            {
                  title = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:[NSString stringWithFormat:@"%lf",num] currency:[FilterManager tempCurrency]]];
            }
                break;
            case CashOnDeliveryTruncTypeDown:
            {
                  title = [NSString stringWithFormat:@"%@",[ExchangeManager transforFloorPrice:[NSString stringWithFormat:@"%lf",num] currency:[FilterManager tempCurrency]]];
            }
                break;
            default:
                break;
        }
        
        VerificationView *verifView = [[VerificationView alloc]initWithTitle:title andCode:self.checkOutModel.address_info.code andphoneNum:[NSString stringWithFormat:@"%@%@",[NSStringUtils isEmptyString:self.checkOutModel.address_info.supplier_number withReplaceString:@""],self.checkOutModel.address_info.tel]];
        @weakify(verifView)
        // 发送验证码到手机
        verifView.sendCodeBlock = ^{
            SendCodeApi *api = [[SendCodeApi alloc] initWithAddressID:self.manager.addressId];
            [MBProgressHUD showLoadingView:nil];
            [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
                [MBProgressHUD hideHUD];
                id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
                if ([requestJSON[@"statusCode"] integerValue] == 200){
                    if ([requestJSON[@"result"][@"error"] integerValue] == 0) { // 成功收到验证码
                        @strongify(verifView)
                        @weakify(verifView)
                        verifView.codeBlock = ^(NSString *codeStr) { // 验证手机码
                            self.manager.verifyCode = codeStr;
                            [self createOrderSuccess:^{
                                @strongify(verifView)
                                [verifView dismiss];
                            } failure:^{
                                @strongify(verifView)
                                verifView.isCodeSuccess = NO;
                            }];
                        };
                        return;
                    }
                    // 显示错误信息
                    [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
                }
            } failure:^(__kindof SYBaseRequest *request, NSError *error) {
                [MBProgressHUD hideHUD];
            }];
        };
        
         [verifView show];
        return;
    }
    
    // 正常pp支付、worldpay支付
    [self createOrderSuccess:nil failure:nil];
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

- (void)jumpToAccountOrderListWithOrderStatus:(NSInteger )status {

    [self.controller.navigationController popToRootViewControllerAnimated:NO];
    
    ZFTabBarController *tabBarVC = APPDELEGATE.tabBarVC;
    tabBarVC.selectedIndex       = TabBarIndexAccount;
    ZFNavigationController  *accountNavVC = (ZFNavigationController *)tabBarVC.selectedViewController;
    MyOrdersListViewController *orderVc = [[MyOrdersListViewController alloc] init];

    if (accountNavVC) {
        [accountNavVC popToRootViewControllerAnimated:NO];
        [accountNavVC pushViewController:orderVc animated:NO]; //设为NO,TabBar不显示，需设为YES
    }
    
    if(status == PaymentStatusDone){
        NSString *message = ZFLocalizedString(@"CartOrderInfoModel_PaymentStatusDone_Alert_Message",nil);
        NSString *title = ZFLocalizedString(@"CartOrderInfoModel_PaymentStatusDone_Alert_Title",nil);
        [self showAlertMessage:message title:title vc:orderVc];
    }else if(status == PaymentStatusCancel){
        NSString *message = ZFLocalizedString(@"CartOrderInfoModel_PaymentStatusCancel_Alert_Message",nil);
        NSString *title = ZFLocalizedString(@"CartOrderInfoModel_PaymentStatusCancel_Alert_Title",nil);
        [self showAlertMessage:message title:title vc:orderVc];
    }else if(status == PaymentStatusFail){
        NSString *message = ZFLocalizedString(@"CartOrderInfoModel_PaymentStatusFail_Alert_Message",nil);
        NSString *title = ZFLocalizedString(@"CartOrderInfoModel_PaymentStatusFail_Alert_Title",nil);
        [self showAlertMessage:message title:title vc:orderVc];
    }
}

- (void)showAlertMessage:(NSString *)message title:(NSString *)title vc:(UIViewController *)vc {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:ZFLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
    [vc presentViewController:alertController animated:YES completion:nil];
}

- (void)showCODLimitAlert {
    UIAlertController *alertController =  [UIAlertController
                                           alertControllerWithTitle:nil
                                           message:[NSString stringWithFormat:ZFLocalizedString(@"OrderInfoViewModel_alertMsg_COD",nil),self.checkOutModel.cod.totalMin,self.checkOutModel.cod.totalMax]
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction  = [UIAlertAction actionWithTitle:ZFLocalizedString(@"SettingViewModel_Version_Latest_Alert_OK",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:okAction];
    [self.controller presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)codIntegerWith:(NSString *)price {
    NSString *symbol = [ExchangeManager symbolOfCurrency:[FilterManager tempCurrency]];
    NSString *result;
    if ([symbol isEqualToString:@"TL"] || [symbol isEqualToString:@"JD"]) {
        result = [NSString stringWithFormat:@"%@%@",[ExchangeManager symbolOfCurrency:[FilterManager tempCurrency]],price];
    }else{
        result = [NSString stringWithFormat:@"%@%@",price,[ExchangeManager symbolOfCurrency:[FilterManager tempCurrency]]];
    }
    return result;
}

- (void)jumpToBoletoFinishedViewController{
    BoletoFinishedViewController *boletoVC = [[BoletoFinishedViewController alloc] init];
    boletoVC.order_number = self.orderModel.order_sn;
     @weakify(self)
    boletoVC.boOrderListBlock = ^{
         @strongify(self)
        [self.controller dismissViewControllerAnimated:YES completion:nil];
        MyOrdersListViewController *orderVc = [[MyOrdersListViewController alloc] init];
        [self.controller.navigationController pushViewController:orderVc animated:YES];
    };
    
    boletoVC.boContiueBlock = ^{
        ZFPaymentView *ppView = [[ZFPaymentView alloc] initWithFrame:CGRectZero];
        ppView.url = self.orderModel.pay_url;
        ppView.block = ^(PaymentStatus status){
        };
        [ppView show];
    };
    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:boletoVC];
    [self.controller.navigationController presentViewController:nav animated:YES completion:^{
    }];
}

#pragma mark - Getter
- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

- (OrderInfoManager *)manager {
    if (!_manager) {
        _manager = [[OrderInfoManager alloc] init];
    }
    return _manager;
}

- (ZFOrderInfoFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[ZFOrderInfoFooterView alloc] init];
        @weakify(self)
        _footerView.orderInfoH5Block = ^(NSString *url) {
            @strongify(self)
            ZFWebViewViewController *webView = [[ZFWebViewViewController alloc] init];
            webView.link_url = url;
            [self.controller.navigationController pushViewController:webView animated:YES];
        };
    }
    return _footerView;
}

@end
