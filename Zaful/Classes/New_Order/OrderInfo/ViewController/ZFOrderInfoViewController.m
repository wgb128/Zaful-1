
//
//  ZFOrderInfoViewController.m
//  Zaful
//
//  Created by TsangFa on 13/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderInfoViewController.h"
#import "ZFOrderCell.h"

#import "ZFWebViewViewController.h"
#import "CartInfoGoodsViewController.h"
#import "ZFOrderContentViewController.h"
#import "ZFOrderPageViewController.h"
#import "ZFPaymentStatusViewController.h"
#import "ZFPayMethodsViewController.h"
#import "ZFAddressViewController.h"
#import "OrderFinishViewController.h"
#import "OrderFailureViewController.h"
#import "BoletoFinishedViewController.h"
#import "MyOrdersListViewController.h"
#import "ZFCartViewController.h"
#import "ZFMyCouponViewController.h"

#import "ZFOrderManager.h"
#import "FilterManager.h"
#import "ZFOrderInformationViewModel.h"
#import "ZFOrderCheckInfoModel.h"
#import "ZFOrderCheckInfoDetailModel.h"
#import "ZFOrderCheckDoneModel.h"
#import "ZFOrderCheckDoneDetailModel.h"

@interface ZFOrderInfoViewController ()<ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView                    *tableView;
@property (nonatomic,strong) NSMutableArray                 *sectionArray;
@property (nonatomic,strong) NSMutableArray                 *amountDetailModelArray;
@property (nonatomic,strong) ZFOrderInformationViewModel    *viewModel;
@property (nonatomic,strong) ZFOrderInfoFooterView          *footerView;
@property (nonatomic,strong) NSIndexPath                    *currentPaymentselectedIndexPath;
@property (nonatomic,strong) NSIndexPath                    *currentShippingselectedIndexPath;
@property (nonatomic, assign) BOOL                          isBackToCart;
@end

@implementation ZFOrderInfoViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.firstEnter) {
        NSString *orderTypeName = [self orderTypeName];
        
        /*谷歌统计*/
        [ZFAnalytics screenViewQuantityWithScreenName:orderTypeName];
        [ZFAnalytics settleInfoProcedureWithProduct:self.checkOutModel.cart_goods.goods_list step:1 option:nil screenName:[NSString stringWithFormat:@"%@ Detail", orderTypeName]];
        
        [ZFFireBaseAnalytics checkoutProgressWithStep:1 checkInfoModel:self.checkOutModel];
    }
    self.firstEnter = YES;
}

#pragma mark - Setter
-(void)setCheckOutModel:(ZFOrderCheckInfoDetailModel *)checkOutModel {
    
    if (!_checkOutModel) {
        // 默认勾选物流保险费用
        checkOutModel.ifNeedInsurance = YES;
    } else {
        checkOutModel.ifNeedInsurance = _checkOutModel.ifNeedInsurance;
    }
    
    _checkOutModel = checkOutModel;
    // 适配上传参数模型
    [self.manager adapterManagerWithModel:checkOutModel];
    // 配置cell个数
    [self configureTableViewCell];
    // 配置(支付/物流)默认选择方式
    [self adapterDefaultSelected];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Private Method
- (void)configureTableViewCell {
    [self.sectionArray removeAllObjects];
    [self.sectionArray addObject:@[[ZFOrderAddressCell class]]];
    [self adpaterPaymentOrShippingCell:self.checkOutModel.payment_list class:[ZFOrderPaymentListCell class]];
    [self adpaterPaymentOrShippingCell:self.manager.shippingListArray class:[ZFOrderShippingListCell class]];
    [self.sectionArray addObject:@[[ZFOrderInsuranceCell class]]];
    if ([self.checkOutModel.point.avail_point floatValue] >= 50) {
        [self.sectionArray addObject:@[[ZFOrderPointsCell class]]];
    }
    [self.sectionArray addObject:@[[ZFOrderCouponCell class]]];
    [self.sectionArray addObject:@[[ZFOrderGoodsCell class]]];
    
    // 这里需要优化
     [self.amountDetailModelArray removeAllObjects];
    self.amountDetailModelArray = [self.manager queryAmountDetailArray];
    NSMutableArray *cellArray = [NSMutableArray arrayWithCapacity:self.amountDetailModelArray.count];
    for (int i = 0; i < self.amountDetailModelArray.count; i++) {
        [cellArray addObject:[ZFOrderAmountDetailCell class]];
    }
    [self.sectionArray addObject:cellArray];
    [self.sectionArray addObject:@[[ZFOrderPlaceOrderCell class]]];
}

- (void)adpaterPaymentOrShippingCell:(NSArray *)dataArray class:(Class)class {
    NSMutableArray  *cellArray = [NSMutableArray arrayWithCapacity:dataArray.count];
    if (dataArray.count > 0) {
        for (int i = 0; i < dataArray.count; i++) {
            [cellArray addObject:class];
        }
         [self.sectionArray addObject:[cellArray copy]];
    }else{
        [self.sectionArray addObject:class == [ZFOrderPaymentListCell class] ? @[[ZFOrderNoPaymentCell class]] : @[[ZFOrderNoShippingCell class]]];
    }
}

- (void)adapterDefaultSelected {
    for (int i = 0; i < self.checkOutModel.payment_list.count; i++) {
        PaymentListModel *model = self.checkOutModel.payment_list[i];
        if ([model.default_select boolValue]) {
            NSInteger sectionIndex = [self querySectionIndex:[ZFOrderPaymentListCell class]];
            self.currentPaymentselectedIndexPath = [NSIndexPath indexPathForRow:i inSection:sectionIndex];
        }
    }
    
    for (int i = 0; i < self.manager.shippingListArray.count; i++) {
        ShippingListModel *model = self.manager.shippingListArray[i];
        if ([model.default_select boolValue]) {
            NSInteger sectionIndex = [self querySectionIndex:[ZFOrderShippingListCell class]];
            self.currentShippingselectedIndexPath = [NSIndexPath indexPathForRow:i inSection:sectionIndex];
        }
    }
}

- (NSInteger)querySectionIndex:(Class)class {
    NSInteger index = 0;
    for (NSArray *dataArray in self.sectionArray) {
        if ([dataArray containsObject:class]) {
           index = [self.sectionArray indexOfObject:dataArray];
        }
    }
    return index;
}

- (void)reloadAmountDetailData {
    [self.amountDetailModelArray removeAllObjects];
    self.amountDetailModelArray = [self.manager queryAmountDetailArray];
    for (NSArray *dataArray in self.sectionArray) {
        if ([dataArray containsObject:[ZFOrderAmountDetailCell class]]) {
            NSUInteger index = [self.sectionArray indexOfObject:dataArray];
            [self.tableView beginUpdates];
            [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }
}

- (void)reloadPaymethodAndShippingMethod:(PaymentListModel *)model {
    //上次选中与这次是否是同一类型
    BOOL isChange = !([FilterManager tempCOD:self.manager.currentPaymentType == CurrentPaymentTypeCOD] == ([model.pay_code isEqualToString:@"Cod"] ? YES : NO));
    [FilterManager saveTempCOD:[model.pay_code isEqualToString:@"Cod"] ? YES : NO];
    self.manager.currentPaymentType = [model.pay_code isEqualToString:@"Cod"] ? CurrentPaymentTypeCOD : CurrentPaymentTypeOnline;
    [self.checkOutModel.shipping_list enumerateObjectsUsingBlock:^(ShippingListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.is_cod_ship boolValue] == [FilterManager tempCOD:self.manager.currentPaymentType == CurrentPaymentTypeCOD] && isChange) {
            // 刷新物流方式默认选中
            [self.manager.shippingListArray setValue:@(NO) forKeyPath:@"default_select"];
            obj.default_select = @"1";
            self.manager.shippingId = obj.iD;
            self.manager.shippingPrice = obj.ship_price;
            [self.manager.shippingListArray removeAllObjects];
            [self.manager.shippingListArray addObject:obj];
            *stop = YES;
        }
    }];
    
    // 刷新付款方式
    [self.checkOutModel.payment_list setValue:@(NO) forKeyPath:@"default_select"];
    model.default_select = @"1";
    self.manager.paymentCode = model.pay_code;
    self.manager.codFreight = [model.pay_code isEqualToString:@"Cod"] ? self.checkOutModel.cod.codFee : @"0.00";
}


- (void)showAlert:(NSString *)message actionTitle:(NSString *)string {
    UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                              message:message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction  = [UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)jumpToPaymentStateViewController {
    NSMutableArray *managerArray = [NSMutableArray array];
    ZFOrderPageViewController *pageVC = (ZFOrderPageViewController *)self.parentViewController;
    for (ZFOrderInfoViewController *vc in pageVC.childViewControllers) {
        [vc.manager queryCurrentOrderCurrency];
        vc.manager.isCod = @"0";
        [managerArray addObject:vc.manager];
    }
    [managerArray copy];
    NSDictionary *dict = @{
                           @"payCode"     : @(self.payCode),
                           @"order_info"  : [self.viewModel queryCheckDoneRequestParmasWithPayCode:self.payCode managerArray:managerArray]
                           };
    [self.viewModel requestCheckDoneOrder:dict completion:^(id obj) {
        ZFPaymentStatusViewController *payStateVC = [[ZFPaymentStatusViewController alloc] init];
        payStateVC.dataArray = obj;
        payStateVC.managerArray = managerArray;
        @weakify(payStateVC)
        payStateVC.payStatesBlock = ^{
            @strongify(payStateVC)
            [payStateVC dismissViewControllerAnimated:YES completion:nil];
            ZFNavigationController  *accountNavVC = [self queryTargetNavigationController:TabBarIndexAccount];
            MyOrdersListViewController *orderListVC = [[MyOrdersListViewController alloc] init];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [accountNavVC pushViewController:orderListVC animated:NO];
        };
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:payStateVC];
        [self presentViewController:nav animated:YES completion:nil];
    } failure:^(id obj) {}];
}

- (void)jumpToPayment {
    if (self.checkOutModel.shipping_list.count == 0) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"CartOrderInfoViewModel_PlaceOrder_NoShipping",nil)];
        return ;
    }
    
    if (self.checkOutModel.payment_list.count == 0) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"CartOrderInfoViewModel_PlaceOrder_NoPayment",nil)];
        return ;
    }
    
    if (![NSStringUtils isEmptyString:[FilterManager tempCurrency]] && [self.manager.paymentCode isEqualToString:@"Cod"]) {
        [self showCODPay];
    }else{
        [self showOnlinePay];
    }
}

- (void)showCODPay {
    VerificationView *verifView = [[VerificationView alloc]initWithTitle:[self.manager queryCashOnDelivery] andCode:self.manager.addressCode andphoneNum:[NSString stringWithFormat:@"%@%@",NullFilter(self.manager.supplierNumber),self.manager.tel]];
    @weakify(verifView)
    // 发送验证码到手机
    verifView.sendCodeBlock = ^{
        @strongify(verifView)
        [self.viewModel sendPhoneCod:self.manager.addressId completion:^(id obj) {
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
        } failure:^(id obj) {}];
    };
    [verifView show];
}

- (void)showOnlinePay {
    [self createOrderSuccess:nil failure:nil];
}

- (ZFNavigationController *)queryTargetNavigationController:(NSInteger)index {
    ZFTabBarController *tabBarVC = APPDELEGATE.tabBarVC;
    if (tabBarVC.selectedIndex != index) {
        ZFNavigationController  *currentNavVC = (ZFNavigationController *)tabBarVC.selectedViewController;
        [currentNavVC popToRootViewControllerAnimated:NO];
        tabBarVC.selectedIndex       = index;
    }
    ZFNavigationController  *targetNavVC = (ZFNavigationController *)tabBarVC.selectedViewController;
    return targetNavVC;
}

- (void)showTipsWithPayState:(NSInteger )states vc:(UIViewController *)vc {
    NSString *title;
    NSString *message;
    switch (states) {
        case PaymentStatusDone:
        {
            message = ZFLocalizedString(@"CartOrderInfoModel_PaymentStatusDone_Alert_Message",nil);
            title = ZFLocalizedString(@"CartOrderInfoModel_PaymentStatusDone_Alert_Title",nil);
        }
            break;
        case PaymentStatusCancel:
        {
            message = ZFLocalizedString(@"CartOrderInfoModel_PaymentStatusCancel_Alert_Message",nil);
            title = ZFLocalizedString(@"CartOrderInfoModel_PaymentStatusCancel_Alert_Title",nil);
        }
            break;
        case PaymentStatusFail:
        {
            message = ZFLocalizedString(@"CartOrderInfoModel_PaymentStatusFail_Alert_Message",nil);
            title = ZFLocalizedString(@"CartOrderInfoModel_PaymentStatusFail_Alert_Title",nil);
        }
            break;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:ZFLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
    [vc presentViewController:alertController animated:YES completion:nil];
}

- (void)jumpToMyOrderListViewController:(NSInteger)state {
    ZFNavigationController  *accountNavVC = [self queryTargetNavigationController:TabBarIndexAccount];
    MyOrdersListViewController *orderListVC = [[MyOrdersListViewController alloc] init];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [accountNavVC pushViewController:orderListVC animated:NO];
    [self showTipsWithPayState:state vc:orderListVC];
}

- (void)showPaySuccessViewController:(ZFOrderCheckDoneDetailModel *)model {
    NSString *goodsStr = [self.manager appendGoodsSN:self.checkOutModel];
    [ZFFireBaseAnalytics finishedPurchaseWithOrderModel:model];
    
    OrderFinishViewController *finischVC = [[OrderFinishViewController alloc] init];
    finischVC.orderSn = model.order_sn;
    if ([model.pay_method isEqualToString:@"Cod"]) {
        finischVC.isVerifcation = YES;
        finischVC.paymentAccount = [FilterManager changeCodCurrencyToFront:model.multi_order_amount];
        [FilterManager removeCurrency];
        [FilterManager removeCOD];
    } else {
        [ZFAnalytics appsFlyerTrackFinishOrderSn:model.order_sn orderRealPay:model.order_amount goodsIds:goodsStr payMethod:model.pay_method];
    }
    finischVC.toAccountOrHomeblock = ^(BOOL gotoOrderList){
        [self dismissViewControllerAnimated:YES completion:nil];
        NSString *orderTypeName = [self orderTypeName];
        if (gotoOrderList) {
            [self jumpToMyOrderListViewController:PaymentStatusDone];
            
            [ZFAnalytics clickButtonWithCategory:[NSString stringWithFormat:@"%@ Payment Success", orderTypeName] actionName:[NSString stringWithFormat:@"%@ Payment Success - My Account", orderTypeName] label:[NSString stringWithFormat:@"%@ Payment Success - My Account", orderTypeName]];
            
            [ZFFireBaseAnalytics selectContentWithItemId:@"Payment_Success_ToOrderList" itemName:@"" ContentType:@"Payment Success" itemCategory:@""];
        }else{
            ZFNavigationController  *homeNavVC = [self queryTargetNavigationController:TabBarIndexHome];
            [homeNavVC popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kHomeHideNavbarNotice object:nil];
            [ZFAnalytics clickButtonWithCategory:[NSString stringWithFormat:@"%@ Payment Success", orderTypeName] actionName:[NSString stringWithFormat:@"%@ Payment Success - Return to Home", orderTypeName] label:[NSString stringWithFormat:@"%@ Payment Success - Return to Home", orderTypeName]];
            
            [ZFFireBaseAnalytics selectContentWithItemId:@"Payment_Success_ToHome" itemName:@"" ContentType:@"Payment Success" itemCategory:@""];
        }
        [ZFAnalytics settleInfoProcedureWithProduct:self.checkOutModel.cart_goods.goods_list step:3 option:nil screenName:[NSString stringWithFormat:@"%@ PaySuccess", orderTypeName]];
        [ZFAnalytics trasactionInfoWithProduct:self.checkOutModel.cart_goods.goods_list order:model screenName:[NSString stringWithFormat:@"%@ PaySuccess", orderTypeName]];
        
        [ZFFireBaseAnalytics checkoutProgressWithStep:3 checkInfoModel:self.checkOutModel];
        [ZFFireBaseAnalytics selectContentWithItemId:@"Payment_Result_Success" itemName:@"" ContentType:@"Payment Result" itemCategory:@""];
    };
    [self presentViewController:finischVC animated:YES completion:nil];
}

- (void)showPayFailureViewController:(ZFOrderCheckDoneDetailModel *)model {
    OrderFailureViewController *failureVC = [[OrderFailureViewController alloc] init];
    failureVC.orderFailureBlock = ^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self jumpToMyOrderListViewController:PaymentStatusFail];
        
        NSString *orderTypeName = [self orderTypeName];
        [ZFAnalytics clickButtonWithCategory:[NSString stringWithFormat:@"%@ Payment Failure", orderTypeName] actionName:[NSString stringWithFormat:@"%@ Payment Failure - My Account", orderTypeName] label:[NSString stringWithFormat:@"%@ Payment Failure - My Account", orderTypeName]];
        [ZFAnalytics settleInfoProcedureWithProduct:self.checkOutModel.cart_goods.goods_list step:3 option:nil screenName:[NSString stringWithFormat:@"%@ PayFailure", orderTypeName]];
        [ZFAnalytics trasactionInfoWithProduct:self.checkOutModel.cart_goods.goods_list order:model screenName:[NSString stringWithFormat:@"%@ PayFailure", orderTypeName]];
        
        [ZFFireBaseAnalytics checkoutProgressWithStep:3 checkInfoModel:self.checkOutModel];
    };
    [self.navigationController presentViewController:failureVC animated:YES completion:nil];
    [ZFFireBaseAnalytics selectContentWithItemId:@"Payment_Result_Fail" itemName:@"" ContentType:@"Payment Result" itemCategory:@""];
}

- (void)jumpToBoletoFinishedViewController:(ZFOrderCheckDoneDetailModel *)model goodsStr:(NSString *)goodsStr {
    
    [ZFAnalytics appsFlyerTrackFinishOrderSn:model.order_sn orderRealPay:model.order_amount goodsIds:goodsStr payMethod:model.pay_method];
    [ZFFireBaseAnalytics finishedPurchaseWithOrderModel:model];
    
    BoletoFinishedViewController *boletoVC = [[BoletoFinishedViewController alloc] init];
    boletoVC.order_number = model.order_sn;
    boletoVC.order_id = model.order_id;
    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:boletoVC];
    [self.navigationController presentViewController:nav animated:YES completion:^{
    }];
}

- (void)showPaymentView:(ZFOrderCheckDoneDetailModel *)checkDoneDetailModel goodsStr:(NSString *)goodsStr{
    ZFPaymentView *ppView = [[ZFPaymentView alloc] initWithFrame:CGRectZero];
    ppView.url = checkDoneDetailModel.pay_url;
    @weakify(self);
    ppView.block = ^(PaymentStatus status){
        @strongify(self)
        switch (status) {
            case PaymentStatusCancel:
            {
                [self jumpToMyOrderListViewController:PaymentStatusCancel];
            }
                break;
            case PaymentStatusDone:
            {
                if ([checkDoneDetailModel.pay_method isEqualToString:@"boletoBancario"]) {
                    [self jumpToBoletoFinishedViewController:checkDoneDetailModel goodsStr:goodsStr];
                }else{
                    [self showPaySuccessViewController:checkDoneDetailModel];
                }
            }
                break;
            case PaymentStatusUnknown:
            case PaymentStatusFail:
            {
                [self showPayFailureViewController:checkDoneDetailModel];
            }
                break;
        }
    };
    [ppView show];
}

- (void)createOrderSuccess:(void (^)())success failure:(void (^)())failure {
    [self.manager queryCurrentOrderCurrency];
    NSDictionary *dict = @{
                           @"payCode"     : @(self.payCode),
                           @"order_info"  : [self.viewModel queryCheckDoneRequestParmasWithPayCode:self.payCode managerArray:@[self.manager]]
                           };
    [self.viewModel requestCheckDoneOrder:dict completion:^(NSArray<ZFOrderCheckDoneModel *> *dataArray) {
        
        [ZFFireBaseAnalytics addPaymentInfo];
        
        ZFOrderCheckDoneModel *checkDoneModel = (ZFOrderCheckDoneModel *)dataArray.firstObject;
        ZFOrderCheckDoneDetailModel *checkDoneDetailModel = checkDoneModel.order_info;
        NSString *payMethod = checkDoneDetailModel.pay_method;
        NSInteger state = checkDoneDetailModel.flag;
        
        if (checkDoneDetailModel.error == 0) {
            NSString *goodsStr = [self.manager appendGoodsSN:self.checkOutModel];
            [self.manager analyticsClickButton:payMethod state:state];
            
            switch (state) {
                    //快速付款成功
                case FastPaypalOrderTypeSuccess:
                {
                    [self showPaySuccessViewController:checkDoneDetailModel];
                }
                    break;
                    //快速付款失败
                case FastPaypalOrderTypeFail:
                {
                    [self showPayFailureViewController:checkDoneDetailModel];
                }
                    break;
                    //普通付款
                case FastPaypalOrderTypeCommon:
                {
                    if (![payMethod isEqualToString:@"Cod"]) {
                        [self showPaymentView:checkDoneDetailModel goodsStr:goodsStr];
                    }else{
                        if (success) success();
                        [self showPaySuccessViewController:checkDoneDetailModel];
                    }
                    
                    [ZFAnalytics appsFlyerTrackEvent:@"af_create_order_success" withValues:@{
                                                                                             @"af_contentid" : goodsStr,
                                                                                             @"af_content_type" : payMethod,
                                                                                             @"order_ids" : checkDoneDetailModel.order_sn
                                                                                             }];
                    [ZFAnalytics settleInfoProcedureWithProduct:self.checkOutModel.cart_goods.goods_list step:2 option:nil screenName:@"Pay"];
                    
                    [ZFFireBaseAnalytics checkoutProgressWithStep:2 checkInfoModel:self.checkOutModel];
                }
                    break;
            }
            //更新购物车数据
            [self.viewModel requestCartBadgeNum];
        }else{
            [MBProgressHUD showMessage:checkDoneDetailModel.msg];
            if (failure) { //回调显示手机验证码错误
                failure();
            }
        }
    } failure:^(id obj) {
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingCreateOrder];
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

- (void)exchangeSubViewController:(NSArray *)childsVCArray contentVC:(UIViewController *)contentVC completion:(void (^)())completion{
    UIViewController *oldVC = childsVCArray.count == 3 ? [childsVCArray objectAtIndex:1] : [childsVCArray objectAtIndex:0];
    UIViewController *newVC = childsVCArray.count == 3 ? [childsVCArray objectAtIndex:2] : [childsVCArray objectAtIndex:1];
    [oldVC willMoveToParentViewController:nil];
    [contentVC transitionFromViewController:oldVC
                           toViewController:newVC
                                   duration:0.25
                                    options:UIViewAnimationOptionTransitionCrossDissolve
                                 animations:^{}
                                 completion:^(BOOL finished) {
                                     if (finished && completion) {
                                         completion();
                                     }
                                 }];
    [oldVC didMoveToParentViewController:self];
}

- (NSDictionary *)configureRequestCheckInfoParmas {
    NSMutableArray *managerArray = [NSMutableArray array];
    if (self.payCode != PayCodeTypeCombine) {
        [managerArray addObject:self.manager];
    }else{
        ZFOrderPageViewController *pageVC = (ZFOrderPageViewController *)self.parentViewController;
        for (ZFOrderInfoViewController *vc in pageVC.childViewControllers) {
            [managerArray addObject:vc.manager];
        }
    }
    [managerArray copy];
    NSDictionary *dict = @{
                           @"payCode"     : @(self.payCode),
                           @"order_info"  : [self.viewModel queryCheckInfoRequestParmasWithPayCode:self.payCode managerArray:managerArray]
                           };
    return dict;
}

- (void)refreshTableViewDataWithArray:(NSArray *)dataArray {
    switch (dataArray.count) {
        case 1:
        {
            if (self.paymentUIType != PaymentUITypeSingle) {
                return;
            }
            ZFOrderCheckInfoModel *model = dataArray.firstObject;
            self.paymentUIType = PaymentUITypeSingle;
            self.payCode = model.node;
            self.checkOutModel = model.order_info;
            [self.tableView reloadData];
        }
            break;
        case 2:
        {
            ZFOrderPageViewController *pageVC = (ZFOrderPageViewController *)self.parentViewController;
            for (int i = 0; i < pageVC.childViewControllers.count; i++) {
                ZFOrderInfoViewController *vc = pageVC.childViewControllers[i];
                 ZFOrderCheckInfoModel *model = dataArray[i];
                vc.checkOutModel = model.order_info;
            }
        }
            break;
    }
}

- (void)reloadDataWhenChangeNewAddressCompletion:(void (^)(id obj))completion failure:(void (^)())failure {
    NSDictionary *dict = [self configureRequestCheckInfoParmas];
    @weakify(self)
    [self.viewModel requestCheckInfoNetwork:dict completion:^(NSArray<ZFOrderCheckInfoModel *> *dataArray) {
        @strongify(self)
        [self refreshTableViewDataWithArray:dataArray];
        if (completion) {
            completion(dataArray);
        }
    } failure:^(id obj) {
        if (failure) {
            failure();
        }
    }];
}

- (void)removePayMethodVC {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
    [array removeObjectAtIndex:2];
    [self.navigationController setViewControllers:array];
}

- (NSString *)orderTypeName {
    NSString *screenName = @"Generate Order";
    switch (self.payCode) {
        case PayCodeTypeCOD: {
            screenName = @"COD Order";
            break;
        }
        case PayCodeTypeOnline: {
            screenName = @"Online Order";
            break;
        }
        case PayCodeTypeCombine: {
            if (self.manager.currentPaymentType == CurrentPaymentTypeCOD) {
                screenName = @"Combine Order - COD";
            } else {
                screenName = @"Combine Order - Online";
            }
            break;
        }
        default: {
            if (self.manager.currentPaymentType == CurrentPaymentTypeCOD) {
                screenName = @"Generate Order - COD";
            } else {
                screenName = @"Generate Order - Online";
            }
            break;
        }
    }
    return screenName;
}

- (void)checkoutCouponWithCouponModel:(NSString *)couponCode myCouponViewController:(UIViewController *)viewController {
    if (self.paymentUIType == PaymentUITypeCombine) {
        ZFOrderPageViewController *pageVC = (ZFOrderPageViewController *)self.parentViewController;
        for (ZFOrderInfoViewController *vc in pageVC.childViewControllers) {
            if ([vc.manager.couponCode isEqualToString:couponCode] && ![NSStringUtils isEmptyString:couponCode]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showAlert:ZFLocalizedString(@"ZFOrderUsedCoupon", nil) actionTitle:ZFLocalizedString(@"SettingViewModel_Version_Latest_Alert_OK",nil)];
                });
                return;
            }
        }
    }
    
    self.manager.couponCode = couponCode;
    NSString *currentCouponCode = [self.manager.couponCode copy];
    NSDictionary *dict = [self configureRequestCheckInfoParmas];
    if ([couponCode length] > 0) {
        [self.viewModel checkEffectiveCoupon:couponCode parmas:dict completion:^(id obj) {
            [viewController.navigationController popViewControllerAnimated:YES];
            NSArray<ZFOrderCheckInfoModel *> *modelArray = obj;
            [self refreshTableViewDataWithArray:modelArray];
        } failure:^{
            self.manager.couponCode = currentCouponCode;
        }];
    } else {
        [self.viewModel requestCheckInfoNetwork:dict completion:^(NSArray<ZFOrderCheckInfoModel *> *dataArray) {
            [viewController.navigationController popViewControllerAnimated:YES];
            [self refreshTableViewDataWithArray:dataArray];
        } failure:^(id obj) {
            self.manager.couponCode = currentCouponCode;
        }];
    }
    // 统计
    [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Select_Coupon_%@", self.manager.couponCode] itemName:@"Coupon" ContentType:@"Order - Information" itemCategory:@"Coupon Item"];
}

#pragma mark - TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section != self.sectionArray.count - 1 ? CGFLOAT_MIN : 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.sectionArray.count - 1) {
        self.footerView.model = self.checkOutModel.footer;
        return self.footerView;
    }
    return nil;
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
    
    if (class == [ZFOrderAddressCell class]) {
        ZFOrderAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:[ZFOrderAddressCell queryReuseIdentifier]];
        addressCell.addressModel = self.checkOutModel.address_info;
        return addressCell;
    }
    
    if (class == [ZFOrderPaymentListCell class]) {
        ZFOrderPaymentListCell *paymentListCell = [tableView dequeueReusableCellWithIdentifier:[ZFOrderPaymentListCell queryReuseIdentifier]];
        paymentListCell.paymentListmodel = self.checkOutModel.payment_list[indexPath.row];
        paymentListCell.isChoose = self.currentPaymentselectedIndexPath && self.currentPaymentselectedIndexPath == indexPath ? YES : NO;
        return paymentListCell;
    }
    
    if (class == [ZFOrderShippingListCell class]) {
        ZFOrderShippingListCell *shippingListCell = [tableView dequeueReusableCellWithIdentifier:[ZFOrderShippingListCell queryReuseIdentifier]];
        shippingListCell.shippingListModel = self.manager.shippingListArray[indexPath.row];
        shippingListCell.isChoose = self.currentShippingselectedIndexPath && self.currentShippingselectedIndexPath == indexPath ? YES : NO;
        shippingListCell.isCod = self.manager.currentPaymentType == CurrentPaymentTypeCOD ? YES : NO;
        return shippingListCell;
    }
    
    if (class == [ZFOrderInsuranceCell class]) {
        ZFOrderInsuranceCell *insuranceCell = [tableView dequeueReusableCellWithIdentifier:[ZFOrderInsuranceCell queryReuseIdentifier]];
        insuranceCell.insuranceFee = self.checkOutModel.total.insure_fee;
        insuranceCell.isChoose = self.checkOutModel.ifNeedInsurance;
        insuranceCell.isCod = self.manager.currentPaymentType == CurrentPaymentTypeCOD ? YES : NO;
        return insuranceCell;
    }
    
    if (class == [ZFOrderPointsCell class]) {
        ZFOrderPointsCell *pointsCell = [tableView dequeueReusableCellWithIdentifier:[ZFOrderPointsCell queryReuseIdentifier]];
        if ([NSStringUtils isEmptyString:self.manager.currentInputPoint]) {
            self.checkOutModel.point.currentPoint = self.manager.currentPoint;
        }else{
            self.checkOutModel.point.currentPoint = self.manager.currentInputPoint;
        }
        pointsCell.pointModel = self.checkOutModel.point;
        pointsCell.isCod = self.manager.currentPaymentType == CurrentPaymentTypeCOD ? YES : NO;

        @weakify(self)
        pointsCell.pointsInputBlock = ^(NSString *amount, NSString *inputPoint) {
            @strongify(self);
            self.checkOutModel.point.currentPoint = inputPoint;
            self.manager.pointSavePrice = amount;
            self.manager.currentPoint = inputPoint;
            self.manager.currentInputPoint = inputPoint;
            
            [self reloadAmountDetailData];
        };
        pointsCell.pointsShowHelpBlock = ^(NSString *tips) {
            @strongify(self);
            [self showAlert:tips actionTitle:ZFLocalizedString(@"SettingViewModel_Version_Latest_Alert_OK",nil)];
        };
        return pointsCell;
    }
    
    if (class == [ZFOrderCouponCell class]) {
        ZFOrderCouponCell *couponCell = [tableView dequeueReusableCellWithIdentifier:[ZFOrderCouponCell queryReuseIdentifier]];
        couponCell.isCod = self.manager.currentPaymentType == CurrentPaymentTypeCOD ? YES : NO;
        if ([self.manager.couponCode length] == 0) {
            NSString *couponAmount =self.checkOutModel.coupon_list.available.count > 0 ? [NSString stringWithFormat:ZFLocalizedString(@"MyCoupon_Coupon_Available", nil), self.checkOutModel.coupon_list.available.count] : ZFLocalizedString(@"MyCoupon_Coupon_No_Available", nil);
            [couponCell initCouponAmount:couponAmount];
        } else {
            couponCell.couponAmount = self.manager.couponAmount;
        }
        return couponCell;
    }
    
    if (class == [ZFOrderGoodsCell class]) {
        ZFOrderGoodsCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:[ZFOrderGoodsCell queryReuseIdentifier]];
        goodsCell.goodsList = self.checkOutModel.cart_goods.goods_list;
        return goodsCell;
    }
    
    if (class == [ZFOrderAmountDetailCell class]) {
        ZFOrderAmountDetailCell *amountDetailCell = [tableView dequeueReusableCellWithIdentifier:[ZFOrderAmountDetailCell queryReuseIdentifier]];
        amountDetailCell.model = self.amountDetailModelArray[indexPath.row];
        return amountDetailCell;
    }
    
    if (class == [ZFOrderPlaceOrderCell class]) {
        ZFOrderPlaceOrderCell *placeOrderCell = [tableView dequeueReusableCellWithIdentifier:[ZFOrderPlaceOrderCell queryReuseIdentifier]];
        return placeOrderCell;
    }
    
    if (class == [ZFOrderNoPaymentCell class]) {
        ZFOrderNoPaymentCell *noPaymentCell = [tableView dequeueReusableCellWithIdentifier:[ZFOrderNoPaymentCell queryReuseIdentifier]];
        return noPaymentCell;
    }
    
    if (class == [ZFOrderNoShippingCell class]) {
        ZFOrderNoShippingCell *noShippingCell = [tableView dequeueReusableCellWithIdentifier:[ZFOrderNoShippingCell queryReuseIdentifier]];
        return noShippingCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class class = self.sectionArray[indexPath.section][indexPath.row];
    // 统计
    NSString *orderTypeName = [self orderTypeName];
    
    if (class == [ZFOrderAddressCell class]) {
        ZFAddressViewController *addressVC = [[ZFAddressViewController alloc] init];
        addressVC.showType = AddressInfoShowTypeCart;
        @weakify(self);
        addressVC.addressChooseCompletionHandler  = ^(ZFAddressInfoModel *model){
            NSString *tempAddressId = [self.manager.addressId copy];
            if ([NSStringUtils isEmptyString:[FilterManager isSupportCOD:self.manager.countryID]] != [NSStringUtils isEmptyString:[FilterManager isSupportCOD:model.country_id]]) {
                self.manager.paymentCode = @"";
                self.manager.shippingId = @"";
            }
            self.manager.addressId = model.address_id;
            self.manager.countryID = model.country_id;
            
            if (self.paymentUIType == PaymentUITypeCombine) {
                ZFOrderPageViewController *pageVC = (ZFOrderPageViewController *)self.parentViewController;
                for (ZFOrderInfoViewController *vc in pageVC.childViewControllers) {
                   vc.manager.addressId =  model.address_id;
                   vc.manager.countryID = model.country_id;
                }
            }
            
            @strongify(self);
            @weakify(self);
            [self.viewModel requestPaymentProcessCompletion:^(NSInteger state) {
                @strongify(self);
                if (self.paymentUIType != state) {
                    switch (self.payCode) {
                        case PayCodeTypeOld: // 购物车 ==> 1老流程 ==> 界面1 ==>  切换地址 ==> 2新流程 ==> 切换为选择支付页面
                        {
                            [FilterManager saveIsComb:YES];
                            
                            if (self.isBackToCart) {
                                NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
                                ZFPayMethodsViewController *paymethodVC = [[ZFPayMethodsViewController alloc] init];
                                [array insertObject:paymethodVC atIndex:2];
                                [self.navigationController setViewControllers:array];
                                [self.navigationController popViewControllerAnimated:YES];
                                return;
                            }

                            ZFOrderContentViewController *contentVC = (ZFOrderContentViewController *)self.parentViewController;
                            NSArray  *childsVCArray = contentVC.childViewControllers;
                            [self exchangeSubViewController:childsVCArray contentVC:contentVC completion:^{
                                ZFPayMethodsViewController *payMethodVC = childsVCArray.lastObject;
                                [payMethodVC.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBARHEIGHT - STATUSHEIGHT)];
                            }];
                        }
                            break;
                        case PayCodeTypeCOD:  // 购物车 ==> 2新流程 ==> 界面2 ==>  切换地址 ==> 2新流程 ==> 刷新本页面
                        case PayCodeTypeOnline:
                        {
                            [self reloadDataWhenChangeNewAddressCompletion:nil failure:^{
                                @strongify(self);
                                self.manager.addressId = tempAddressId;
                            }];
                        }
                            break;
                        case PayCodeTypeCombine: // 购物车 ==> 2新流程 ==> 界面2 ==>  切换地址 ==> 1老流程 ==> 切换为界面1
                        {
                            [FilterManager saveIsComb:NO];
                            self.paymentUIType = PaymentUITypeSingle;
                            self.payCode = PayCodeTypeOld;
                            
                            // 先刷新接口数据
                             @weakify(self);
                            [self reloadDataWhenChangeNewAddressCompletion:^(id obj) {
                                @strongify(self);
                                // 切换页面
                                NSArray *dataArray = obj;
                                ZFOrderPageViewController *pageVC = (ZFOrderPageViewController *)self.parentViewController;
                                ZFOrderContentViewController *parentVC = (ZFOrderContentViewController *)pageVC.parentViewController;
                                NSArray  *childsVCArray = parentVC.childViewControllers;
                                [self exchangeSubViewController:parentVC.childViewControllers contentVC:parentVC completion:^{
                                    [self removePayMethodVC];
                                    ZFOrderInfoViewController *orderInfoVC = childsVCArray.lastObject;
                                    ZFOrderCheckInfoModel *model = dataArray.firstObject;
                                    orderInfoVC.paymentUIType = PaymentUITypeSingle;
                                    orderInfoVC.payCode = model.node;
                                    orderInfoVC.checkOutModel = model.order_info;
                                    [orderInfoVC.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBARHEIGHT - STATUSHEIGHT)];
                                    
                                    ZFPayMethodsViewController *paymethodVC = [[ZFPayMethodsViewController alloc] init];
                                    [parentVC addChildViewController:paymethodVC];
                                }];
                            } failure:^{
                                @strongify(self);
                                self.manager.addressId = tempAddressId;
                            }];
                        }
                            break;
                    }
                    return;
                }
                
                if (self.paymentUIType == state) {
                     // 购物车 ==> 2新流程 ==> 界面1 ==>  切换地址 ==> 1老流程 ==> 刷新本页面数据
                    if (self.payCode != PayCodeTypeOld && state == PaymentProcessTypeOld) {
                        [FilterManager saveIsComb:NO];
                        self.paymentUIType = PaymentUITypeSingle;
                        self.payCode = PayCodeTypeOld;
                         [self removePayMethodVC];
                        self.isBackToCart = YES;
                    }
                     // 购物车 ==> 1老流程 ==> 界面1 ==>  切换地址 ==> 1老流程 ==> 刷新本页面数据
                    [self reloadDataWhenChangeNewAddressCompletion:nil failure:^{
                        @strongify(self);
                        self.manager.addressId = tempAddressId;
                    }];
                }
            } failure:^(id obj) {
                @strongify(self);
                self.manager.addressId = tempAddressId;
            }];
        };
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:addressVC];
        [self presentViewController:nav animated:YES completion:nil];
        // 统计
        [ZFAnalytics clickButtonWithCategory:[NSString stringWithFormat:@"%@ Order", orderTypeName] actionName:[NSString stringWithFormat:@"%@ Order - Address", orderTypeName] label:[NSString stringWithFormat:@"%@ Order - Address", orderTypeName]];
        [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Address" itemName:[NSString stringWithFormat:@"%@ Address", orderTypeName] ContentType:@"Order - Information" itemCategory:[NSString stringWithFormat:@"%@ Address", orderTypeName]];
        
        return;
    }
    
    if (class == [ZFOrderPaymentListCell class]) {
        
        ZFOrderPaymentListCell *paymentListCell = [tableView cellForRowAtIndexPath:indexPath];
        PaymentListModel *model = paymentListCell.paymentListmodel;
        
        [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_PayMethod_%@", model.pay_code] itemName:[NSString stringWithFormat:@"%@ PayMethod", orderTypeName] ContentType:@"Order - Information" itemCategory:[NSString stringWithFormat:@"%@ PayMethod", orderTypeName]];
        
        BOOL isShow = [self.manager isShowCODGoodsAmountLimit:model.pay_code checkoutModel:self.checkOutModel];
        if (isShow) {
            [self showAlert:[NSString stringWithFormat:ZFLocalizedString(@"OrderInfoViewModel_alertMsg_COD",nil),self.checkOutModel.cod.totalMin,self.checkOutModel.cod.totalMax] actionTitle:ZFLocalizedString(@"SettingViewModel_Version_Latest_Alert_OK",nil)];
            return;
        }
        if (self.currentPaymentselectedIndexPath == indexPath) {
            return;
        }
        
        if (self.currentPaymentselectedIndexPath) {
            ZFOrderPaymentListCell *lastSelectCell = [tableView cellForRowAtIndexPath:self.currentPaymentselectedIndexPath];
            lastSelectCell.isChoose = NO;
        }
        
        paymentListCell.isChoose =  YES;
        self.currentPaymentselectedIndexPath = indexPath;

        [self reloadPaymethodAndShippingMethod:model];
        [self configureTableViewCell];
        [self.tableView reloadData];
        return;
    }
    
    if (class == [ZFOrderShippingListCell class]) {
        
        if (self.currentShippingselectedIndexPath == indexPath) {
            return;
        }
        
        if (self.currentShippingselectedIndexPath) {
            ZFOrderPaymentListCell *lastSelectCell = [tableView cellForRowAtIndexPath:self.currentShippingselectedIndexPath];
            lastSelectCell.isChoose = NO;
        }
        ZFOrderShippingListCell *shippingListCell = [tableView cellForRowAtIndexPath:indexPath];
        shippingListCell.isChoose =  YES;
        self.currentShippingselectedIndexPath = indexPath;
        ShippingListModel *model = shippingListCell.shippingListModel;
        NSInteger sectionIndex = [self querySectionIndex:[ZFOrderShippingListCell class]];
        [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
        self.manager.shippingId = model.iD;
        self.manager.shippingPrice = model.ship_price;
        [self reloadAmountDetailData];
        
        [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_ShippingMethod_%@", model.ship_name] itemName:[NSString stringWithFormat:@"%@ ShippingMethod", orderTypeName] ContentType:@"Order - Information" itemCategory:[NSString stringWithFormat:@"%@ ShippingMethod", orderTypeName]];
        return;
    }
    
    if (class == [ZFOrderInsuranceCell class]) {
        ZFOrderInsuranceCell *insuranceCell = [tableView cellForRowAtIndexPath:indexPath];
        self.checkOutModel.ifNeedInsurance = !self.checkOutModel.ifNeedInsurance;
        insuranceCell.isChoose = self.checkOutModel.ifNeedInsurance;
        self.manager.insurance = self.checkOutModel.ifNeedInsurance ? self.checkOutModel.total.insure_fee : @"0.00";
        [self reloadAmountDetailData];
        
        // 统计
        [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_Shipping_Insurance_%d", insuranceCell.isChoose] itemName:[NSString stringWithFormat:@"%@ Shipping_Insurance", orderTypeName] ContentType:@"Order - Information" itemCategory:[NSString stringWithFormat:@"%@ Shipping_Insurance", orderTypeName]];
        return;
    }
    
    if (class == [ZFOrderCouponCell class]) {
        [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Coupon" itemName:@"Coupon" ContentType:@"Order - Information" itemCategory:@"Coupon Item"];
        
        ZFMyCouponViewController *myCouponViewController = [[ZFMyCouponViewController alloc] init];
        myCouponViewController.availableArray = self.checkOutModel.coupon_list.available;
        myCouponViewController.disabledArray  = self.checkOutModel.coupon_list.disabled;
        myCouponViewController.couponCode     = self.manager.couponCode;
        myCouponViewController.couponAmount   = self.manager.couponAmount;
        [self.navigationController pushViewController:myCouponViewController animated:YES];
        
        @weakify(myCouponViewController)
        myCouponViewController.applyCouponHandle = ^(NSString *couponCode) {
            @strongify(myCouponViewController);
            [self checkoutCouponWithCouponModel:couponCode myCouponViewController:myCouponViewController];
        };
        return;
    }
    
    if (class == [ZFOrderGoodsCell class]) {
        CartInfoGoodsViewController *goodsVC = [[CartInfoGoodsViewController alloc] init];
        goodsVC.goodsList = self.checkOutModel.cart_goods.goods_list;
        [self.navigationController pushViewController:goodsVC animated:YES];
        
        [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Item" itemName:@"Item" ContentType:@"Order - Information" itemCategory:@"Item"];
        return;
    }
    
    if (class == [ZFOrderPlaceOrderCell class]) {
        NSString *orderTypeName = [self orderTypeName];
        [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Place Order" itemName:@"Place Order" ContentType:@"Order - Information" itemCategory:@"Button"];
        
        [ZFAnalytics clickButtonWithCategory:orderTypeName actionName:[NSString stringWithFormat:@"%@ - Place Order", orderTypeName] label:[NSString stringWithFormat:@"%@ - Place Order", orderTypeName]];
        switch (self.paymentUIType) {
            case PaymentUITypeSingle:
            {
                [self jumpToPayment];
            }
                break;
            case PaymentUITypeCombine:
            {
                [self jumpToPaymentStateViewController];
            }
                break;
        }
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.title = ZFLocalizedString(@"CartOrderInfo_VC_Title",nil);
    self.view.backgroundColor = ZFCOLOR_WHITE;
    [self.view addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 112;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView registerClass:[ZFOrderAddressCell class] forCellReuseIdentifier:[ZFOrderAddressCell queryReuseIdentifier]];
        [_tableView registerClass:[ZFOrderCurrentPaymentCell class] forCellReuseIdentifier:[ZFOrderCurrentPaymentCell queryReuseIdentifier]];
        [_tableView registerClass:[ZFOrderPaymentListCell class] forCellReuseIdentifier:[ZFOrderPaymentListCell queryReuseIdentifier]];
        [_tableView registerClass:[ZFOrderNoPaymentCell class] forCellReuseIdentifier:[ZFOrderNoPaymentCell queryReuseIdentifier]];
        [_tableView registerClass:[ZFOrderShippingListCell class] forCellReuseIdentifier:[ZFOrderShippingListCell queryReuseIdentifier]];
        [_tableView registerClass:[ZFOrderNoShippingCell class] forCellReuseIdentifier:[ZFOrderNoShippingCell queryReuseIdentifier]];
        [_tableView registerClass:[ZFOrderInsuranceCell class] forCellReuseIdentifier:[ZFOrderInsuranceCell queryReuseIdentifier]];
        [_tableView registerClass:[ZFOrderPointsCell class] forCellReuseIdentifier:[ZFOrderPointsCell queryReuseIdentifier]];
        [_tableView registerClass:[ZFOrderCouponCell class] forCellReuseIdentifier:[ZFOrderCouponCell queryReuseIdentifier]];
        [_tableView registerClass:[ZFOrderGoodsCell class] forCellReuseIdentifier:[ZFOrderGoodsCell queryReuseIdentifier]];
        [_tableView registerClass:[ZFOrderAmountDetailCell class] forCellReuseIdentifier:[ZFOrderAmountDetailCell queryReuseIdentifier]];
        [_tableView registerClass:[ZFOrderPlaceOrderCell class] forCellReuseIdentifier:[ZFOrderPlaceOrderCell queryReuseIdentifier]];
    }
    return _tableView;
}

- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

- (NSMutableArray *)amountDetailModelArray {
    if (!_amountDetailModelArray) {
        _amountDetailModelArray = [NSMutableArray array];
    }
    return _amountDetailModelArray;
}

- (ZFOrderManager *)manager {
    if (!_manager) {
        _manager = [[ZFOrderManager alloc] init];
    }
    return _manager;
}

- (ZFOrderInformationViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFOrderInformationViewModel alloc] init];
    }
    return _viewModel;
}

- (ZFOrderInfoFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[ZFOrderInfoFooterView alloc] init];
        @weakify(self)
        _footerView.orderInfoH5Block = ^(NSString *url) {
            @strongify(self)
            ZFWebViewViewController *webView = [[ZFWebViewViewController alloc] init];
            webView.link_url = url;
            [self.navigationController pushViewController:webView animated:YES];
        };
    }
    return _footerView;
}

@end
