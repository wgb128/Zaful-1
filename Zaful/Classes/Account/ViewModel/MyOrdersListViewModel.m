//
//  MyOrdersListViewModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/6/7.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "MyOrdersListViewModel.h"
#import "ZFPaymentView.h"
#import "MyOrdersListApi.h"
#import "MyOrdersModel.h"

#import "OrderFinishViewController.h"
#import "OrderFailureViewController.h"
#import "OrdersCancelApi.h"

#import "MyOrdersListViewController.h"
#import "MyOrdersListCell.h"
#import "OrderDetailViewController.h"
#import "OrderDetailApi.h"
#import "OrderDetailOrderModel.h"
#import "BoletoFinishedViewController.h"
#import "RemindersApi.h"
#import "ZFTrackingInfoViewController.h"
#import "ZFTrackingPackageModel.h"
#import "ZFTrackingListModel.h"
#import "ZFTrackingPackageApi.h"

@interface MyOrdersListViewModel ()

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) NSInteger orderListCount;

@property (nonatomic, copy) NSString   *trackingMessage;
@property (nonatomic, copy) NSString   *trackingState;


@end

@implementation MyOrdersListViewModel
{
    NSInteger _page;
    NSInteger _pageCount;
    NSInteger _pageSize;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _pageSize = 10;
        _dataArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark Requset
- (void)requestOrderListNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
    if ([parmaters integerValue] == 1) {
        _page = 1;
    }else{
        _page++;
    }
    
    MyOrdersListApi *api = [[MyOrdersListApi alloc] initWithPage:_page];
    
    if (_page == 1) {
        [MBProgressHUD showLoadingView:nil];
    }
    
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        [MBProgressHUD hideHUD];
        
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            
            NSArray *tempArray = [NSArray yy_modelArrayWithClass:[MyOrdersModel class] json:requestJSON[@"result"][@"data"]];
            
            if ([parmaters integerValue] == 1) {
                
                [self.dataArray removeAllObjects];
            }
            
            [self.dataArray addObjectsFromArray:tempArray];
            
            _page = [requestJSON[@"result"][@"page"] integerValue];
            
            _pageCount = [requestJSON[@"result"][@"total_page"] integerValue];

            if (self.dataArray.count == 0) {
                [self showNoDataInView:self.controller.view imageView:@"blank_list" titleLabel:ZFLocalizedString(@"MyOrdersViewModel_NoData_Tip",nil) button:nil buttonBlock:nil];
            }
            NSDictionary *dict = @{
                                   @"state" : @(_page == _pageCount),
                                   @"url"   :  NullFilter(requestJSON[@"result"][@"contact_us"])
                                   };
            if (completion) {
                completion(dict);
            }
            
        }

    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        @weakify(self)
        [self showNoNetworkViewInView:self.controller.view buttonBlock:^{
            @strongify(self)
            [self requestOrderListNetwork:@(_page) completion:^(id obj){
                
            } failure:^(id obj){
                
            }];
        }];
        
    }];
}

- (void)requestCancelOrder:(id)parmaters completion:(void (^)(BOOL isOK))completion{
    
    __block BOOL isSuccess = NO;
    OrdersCancelApi *api = [[OrdersCancelApi alloc] initWithOrderId:parmaters];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                isSuccess = YES;
            }else{
                [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
            }
            
            if (completion) {
                completion(isSuccess);
            }
        }

    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

/**
 *  Cancel后请求这个商品的order status,刷新这个cell
 *
 */
- (void)requestOrderDetailData:(NSString *)orderId completion:(void (^)(id obj))completion{
    
    OrderDetailApi *api = [[OrderDetailApi alloc] initWithOrderId:orderId];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            
            id obj = [OrderDetailOrderModel yy_modelWithJSON:requestJSON[@"result"][@"order"]];
            
            if (completion) {
                completion(obj);
            }
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}


- (void)requestTrackingPackageData:(NSString *)orderID completion:(void (^)(NSArray<ZFTrackingPackageModel *> *array))completion failure:(void (^)(id obj))failure {
    
    ZFTrackingPackageApi *api = [[ZFTrackingPackageApi alloc] initWithOrderID:orderID];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSArray<ZFTrackingPackageModel *> *dataArray = [NSArray yy_modelArrayWithClass:[ZFTrackingPackageModel class] json:requestJSON[@"result"][@"data"]];
            //修改物流时间逆序排序
            [dataArray enumerateObjectsUsingBlock:^(ZFTrackingPackageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *sortArray = [self sortTrackingInfoListWithTrakingArray:obj.track_list];
                obj.track_list = sortArray;
            }];
            self.trackingMessage = requestJSON[@"result"][@"msg"];
            self.trackingState  = requestJSON[@"result"][@"state"];
            if (completion) {
                completion(dataArray);
            }
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        ZFLog(@"\n-------------------------- 错误日志 --------------------------\n接口:%@\n状态码:%ld\n报错信息:%@",NSStringFromClass(api.class),api.responseStatusCode,api.responseString);
    }];
}

#pragma maek - tableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([MyOrdersListCell class]) cacheByIndexPath:indexPath configuration:^(MyOrdersListCell *cell) {
        cell.orderModel = self.dataArray[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyOrdersListCell *cell = [MyOrdersListCell ordersListCellWithTableView:tableView indexPath:indexPath];
    
    cell.orderModel = self.dataArray[indexPath.section];
    @weakify(self)
    @weakify(indexPath)
#pragma mark 支付订单 event
    cell.paymentBlock = ^(){
        
        @strongify(self)
        @strongify(indexPath)
        __block MyOrdersModel *orderModel = self.dataArray[indexPath.section];
        
        NSDictionary *dict;
        
        // 催付
        if (![NSStringUtils isBlankString:[NSStringUtils getPid]] && ![NSStringUtils isBlankString:[NSStringUtils getC]] && ![NSStringUtils isBlankString:[NSStringUtils getIsRetargeting]] && ![NSStringUtils isBlankString:orderModel.order_id]) {
            dict = @{
                     @"order_id"  :   orderModel.order_id,
                     @"pid"       :   [NSStringUtils getPid],
                     @"c"         :   [NSStringUtils getC],
                     @"is_retargeting"    :   [NSStringUtils getIsRetargeting]
                     };
            [self requestOrderReminders:dict completion:^(id obj) {
            }];
        }
        
        ZFPaymentView *ppView = [[ZFPaymentView alloc] initWithFrame:CGRectZero];
        ppView.url = orderModel.pay_url;
        ZFLog(@"\n------------>链接:%@",ppView.url);
        @weakify(self)
        ppView.block = ^(PaymentStatus status){
            // 支付页回调
            @strongify(self)
            switch (status) {
                case PaymentStatusDone: {
                         [self jumpToOrderFinishViewController:orderModel]; // 跳转到付款成功页面
                     
                }
                    break;
                case PaymentStatusUnknown:
                case PaymentStatusFail: {
                    [self jumpToOrderFailurViewController]; // 跳转到付款失败页面
                }
                    break;
                case PaymentStatusCancel: { // 取消付款
                    if ([orderModel.pay_id isEqualToString:@"boletoBancario"]) {
                        return;
                    }
                    [self showAlertViewWithTitle:ZFLocalizedString(@"MyOrdersViewModel_PaymentStatusCancel_Title",nil) Message:ZFLocalizedString(@"MyOrdersViewModel_PaymentStatusCancel_Message",nil)];
                }
                    break;
                default:
                    break;
            }
        };

        [ppView show];
    };
    
#pragma mark 进入订单详情 event
    cell.detailBlock = ^(){
        @strongify(indexPath)
        [self goodsDetail:tableView indexPath:indexPath];
    };
    
    cell.trackingBlock = ^(MyOrdersModel *model) {
         @strongify(self)
        [self requestTrackingPackageData:model.order_id completion:^(NSArray<ZFTrackingPackageModel *> *array) {
            // 3 - 完全发货  4 - 已收到货  20 - 部分发货
            if ([model.order_status integerValue] == 3 || [model.order_status integerValue] == 4 || [model.order_status integerValue] == 20) {
                if ([self.trackingState integerValue] == 0) {
                    // 付款了还没有物流信息
                    [self showAlertViewWithTitle:nil Message:self.trackingMessage];
                    return;
                }
                // 进入物流
                ZFTrackingInfoViewController *trackingInfoVC = [[ZFTrackingInfoViewController alloc] init];
                trackingInfoVC.packages = array;
                [self.controller.navigationController pushViewController:trackingInfoVC animated:YES];
            }else if ([model.order_status integerValue] != 0) {
                // 提示不可点击
                [self showAlertViewWithTitle:nil Message:self.trackingMessage];
            }else if ([model.pay_id isEqualToString:@"Cod"] && [model.order_status integerValue] == 0) {
                  [self showAlertViewWithTitle:nil Message:self.trackingMessage];
            }
        } failure:^(id obj) {
        }];
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self goodsDetail:tableView indexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
#pragma mark - Private Methods
- (void)jumpToBoletoFinishedViewController:(MyOrdersModel *)orderModel {
    BoletoFinishedViewController *boletoVC = [[BoletoFinishedViewController alloc] init];
    boletoVC.order_number = orderModel.order_id;
    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:boletoVC];
    [self.controller.navigationController presentViewController:nav animated:YES completion:^{
    }];
}

- (void)jumpToOrderFinishViewController:(MyOrdersModel *)orderModel {
    OrderFinishViewController *finischVC = [[OrderFinishViewController alloc] init];
    finischVC.orderSn = orderModel.order_sn;
    @weakify(finischVC)
    finischVC.toAccountOrHomeblock = ^(BOOL gotoAccount){ //跳转到Accont或是Home
        @strongify(finischVC)
        [finischVC dismissViewControllerAnimated:YES completion:nil];
        if (gotoAccount) {
            if (self.refreshOrderListCompletionHandler) {
                self.refreshOrderListCompletionHandler();
            }
            // 谷歌统计
            [ZFAnalytics clickButtonWithCategory:@"Payment Success" actionName:@"Payment Success - My Account" label:@"Payment Success - My Account"];
        }else{
            ZFTabBarController *tabBarVC = APPDELEGATE.tabBarVC;
            UINavigationController *navVC = tabBarVC.selectedViewController;
            [navVC popToRootViewControllerAnimated:YES];
            tabBarVC.selectedIndex = TabBarIndexHome;
            // 谷歌统计
            [ZFAnalytics clickButtonWithCategory:@"Payment Success" actionName:@"Payment Success - Return to Home" label:@"Payment Success - Return to Home"];
        }
        /*谷歌统计*/
        [ZFAnalytics settleAccountProcedureWithProduct:orderModel.goods step:3 option:nil screenName:@"PaySuccess"];
        [ZFAnalytics trasactionAccountWithProduct:orderModel screenName:@"PaySuccess"];
    };
    
    [self.controller presentViewController:finischVC animated:YES completion:nil];
}

- (void)jumpToOrderFailurViewController {
    OrderFailureViewController *failureVC = [[OrderFailureViewController alloc] init];
    @weakify(failureVC)
    failureVC.orderFailureBlock = ^{
        @strongify(failureVC)
        [failureVC dismissViewControllerAnimated:YES completion:nil];
        if (self.refreshOrderListCompletionHandler) {
            self.refreshOrderListCompletionHandler();
        }
        // 谷歌统计
        [ZFAnalytics clickButtonWithCategory:@"Payment Failure" actionName:@"Payment Failure - My Account" label:@"Payment Failure - My Account"];
        
    };
    [self.controller presentViewController:failureVC animated:YES completion:nil];
}

- (NSArray *)sortTrackingInfoListWithTrakingArray:(NSArray <ZFTrackingListModel *>*)array {
    //先扫描数组处理一遍时间
    [array enumerateObjectsUsingBlock:^(ZFTrackingListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm MMM.dd yyyy";
        NSDate *createDate = [formatter dateFromString:obj.ondate];
        obj.trackTime = [createDate timeIntervalSince1970];
    }];
    
    NSArray *sortArray = [array sortedArrayUsingComparator:^NSComparisonResult(ZFTrackingListModel *  _Nonnull obj1, ZFTrackingListModel *  _Nonnull obj2) {
        if(obj1.trackTime < obj2.trackTime) {
            return NSOrderedDescending;
        }
        if(obj1.trackTime > obj2.trackTime){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return sortArray;
}
#pragma mark - 催付
- (void)requestOrderReminders:(id)parmaters completion:(void (^)(id obj))completion {
    RemindersApi *api = [[RemindersApi alloc] initWithDict:parmaters];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            if (completion) {
                completion(nil);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        
    }];
}

#pragma mark - 跳转商品详情

- (void)goodsDetail:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] init];
    
    MyOrdersModel *orderModel = self.dataArray[indexPath.section];
    
    orderDetailVC.orderId = orderModel.order_id;
    
    @weakify(orderModel)
    orderDetailVC.reloadOrderListBlock = ^(OrderDetailOrderModel *statusModel){
        
        @strongify(orderModel)
        
        orderModel.order_status = statusModel.order_status;
        
        orderModel.order_status_str = statusModel.order_status_str;
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    [self.controller.navigationController pushViewController:orderDetailVC animated:YES];
}

- (void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:ZFLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self.controller presentViewController:alertController animated:YES completion:nil];
}



@end
