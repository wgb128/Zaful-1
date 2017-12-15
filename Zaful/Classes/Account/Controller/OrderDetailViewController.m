//
//  OrderDetailViewController.m
//  Zaful
//
//  Created by DBP on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailOrderModel.h"
#import "OrderDetailViewModel.h"
#import "OrderDetailPaymentView.h"
#import "OrderFinishViewController.h"
#import "OrderFailureViewController.h"
#import "ZFPaymentView.h"
#import "BoletoFinishedViewController.h"
#import "OrderTrackingInfoView.h"
#import "ZFTrackingInfoViewController.h"

@interface OrderDetailViewController ()
@property (nonatomic, strong) OrderDetailViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) OrderDetailPaymentView  *paymentView;
@property (nonatomic, strong) OrderTrackingInfoView   *trackingInfoView;
@property (nonatomic, strong) OrderDetailOrderModel *orderModel;
@property (nonatomic, strong) MASConstraint *paymentConstraint;
@property (nonatomic, strong) MASConstraint *trackingConstraint;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZFLocalizedString(@"OrderDetail_VC_Title",nil);
    self.view.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    self.goodsArray = [NSMutableArray array];
    [self initViews];
    [self requestData];
}


- (void)requestData {
    @weakify(self)
    [self.viewModel requestNetwork:self.orderId completion:^(NSArray *obj) {
        @strongify(self)
        self.orderModel = [obj objectAtIndex:0];
        self.goodsArray = [obj objectAtIndex:1];
        
         NSString *payMethod = self.orderModel.pay_id;
        if ([payMethod isEqualToString:@"boletoBancario"]) {
            [self.paymentView changeName:self.orderModel.pay_status];
        }
        
        if ([self.orderModel.pay_id isEqualToString:@"Cod"]) {
            self.paymentConstraint.mas_equalTo(0);
            if ([self.orderModel.order_status integerValue] == 13) {
                self.trackingConstraint.mas_equalTo(0);
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                }];
            }
        }else{
            // 取消状态
            if ([self.orderModel.order_status integerValue] == 11) {
                self.paymentConstraint.mas_equalTo(0);
                self.trackingConstraint.mas_equalTo(0);
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                }];
            }else if ([self.orderModel.order_status integerValue] == 0) {
                self.trackingConstraint.mas_equalTo(0);
            }else{
                self.paymentConstraint.mas_equalTo(0);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(id obj) {

    }];
}

- (void)initViews {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-58);
    }];
    
    self.paymentView = [[OrderDetailPaymentView alloc] initWithPaymentStatus:NO];
    self.paymentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.paymentView];
    
    [self.paymentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.bottomMargin.mas_equalTo(self.view.mas_bottomMargin);
        self.paymentConstraint = make.height.mas_equalTo(58).priority(UILayoutPriorityRequired);
    }];
    
    self.trackingInfoView = [[OrderTrackingInfoView alloc] init];
    self.trackingInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.trackingInfoView];
    
    [self.trackingInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.bottomMargin.mas_equalTo(self.view.mas_bottomMargin);
        self.trackingConstraint = make.height.mas_equalTo(58).priority(UILayoutPriorityRequired);
    }];
    
    @weakify(self)
    self.trackingInfoView .orderTrackingInfoBlock = ^{
        @strongify(self)
        [self.viewModel requestTrackingPackageData:self.orderId completion:^(NSArray<ZFTrackingPackageModel *> *array,NSString *msg,NSString *state) {
            // 3 - 完全发货  4 - 已收到货  20 - 部分发货
            if ([self.orderModel.order_status integerValue] == 3 || [self.orderModel.order_status integerValue] == 4 || [self.orderModel.order_status integerValue] == 20) {
                if ([state integerValue] == 0) {
                    [self showAlertViewWithTitle:nil Message:msg];
                    return;
                }
                // 进入物流
                ZFTrackingInfoViewController *trackingInfoVC = [[ZFTrackingInfoViewController alloc] init];
                trackingInfoVC.packages = array;
                [self.navigationController pushViewController:trackingInfoVC animated:YES];
            }else if ([self.orderModel.order_status integerValue] != 0) {
                // 提示不可点击
                [self showAlertViewWithTitle:nil Message:msg];
            }else if ([self.orderModel.pay_id isEqualToString:@"Cod"] && [self.orderModel.order_status integerValue] == 0) {
                [self showAlertViewWithTitle:nil Message:msg];
            }
        } failure:^(id obj) {
        }];
    };
    
  
    self.paymentView.orderDetailPayStatueBlock = ^(NSInteger tag) {
        @strongify(self)
        NSDictionary *dict;
        // 催付
        if (![NSStringUtils isBlankString:[NSStringUtils getPid]] && ![NSStringUtils isBlankString:[NSStringUtils getC]] && ![NSStringUtils isBlankString:[NSStringUtils getIsRetargeting]] && ![NSStringUtils isBlankString:self.orderModel.order_id]) {
            dict = @{
                     @"order_id"  :   self.orderModel.order_id,
                     @"pid"       :   [NSStringUtils getPid],
                     @"c"         :   [NSStringUtils getC],
                     @"is_retargeting"    :   [NSStringUtils getIsRetargeting]
                     };
            [self.viewModel requestOrderReminders:dict completion:^(id obj) {
                
            }];
        }
        
        switch (tag) {
            case OrderDetailPay:
            {
                ZFPaymentView *ppView = [[ZFPaymentView alloc] initWithFrame:CGRectZero];
                ppView.url = self.orderModel.pay_url;
                ppView.block = ^(PaymentStatus status){
                    [self requestData];
                    switch (status) {
                        case PaymentStatusDone: {
                            

                                [self jumpToOrderFinishViewController]; // 跳转到付款成功页面

                        }
                            break;
                        case PaymentStatusUnknown:
                        case PaymentStatusFail: {
                            [self jumpToOrderFailurViewController]; // 跳转到付款失败页面
                        }
                            break;
                        case PaymentStatusCancel: { // 取消付款
                            
                            if ([self.orderModel.pay_id isEqualToString:@"boletoBancario"]) {
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

            }
                break;
            case OrderDetailCancel:
            {
                UIAlertController *alertController =  [UIAlertController
                                                       alertControllerWithTitle: nil
                                                       message:ZFLocalizedString(@"OrderDetail_Cell_CancelOrder_Message",nil)
                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"OrderDetail_Cell_CancelOrder_No",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                }];
                UIAlertAction * sureAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"OrderDetail_Cell_CancelOrder_Yes",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    @weakify(self)
                    [self.viewModel requestCancelOrder:self.orderModel.order_id completion:^(BOOL isOK) {
                        @strongify(self)
                        if (isOK) {
                            @weakify(self)
                            [self.viewModel requestOrderDetailData:^(id obj) {
                                @strongify(self)
                                self.paymentConstraint.mas_equalTo(0);
                                if (self.reloadOrderListBlock) {
                                    self.reloadOrderListBlock(obj);
                                }
                                [self.tableView reloadData];
                            }];
                        }
                    }];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:sureAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    };
}


#pragma mark - Private Methods
- (void)jumpToBoletoFinishedViewController {
    BoletoFinishedViewController *boletoVC = [[BoletoFinishedViewController alloc] init];
    boletoVC.order_number = self.orderModel.order_id;
    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:boletoVC];
    [self.navigationController presentViewController:nav animated:YES completion:^{
    }];
}

- (void)jumpToOrderFinishViewController {
    OrderFinishViewController *finischVC = [[OrderFinishViewController alloc] init];
    finischVC.orderSn = _orderModel.order_sn;
    @weakify(finischVC)
    finischVC.toAccountOrHomeblock = ^(BOOL gotoAccount){ //跳转到Accont或是Home
        @strongify(finischVC)
        [finischVC dismissViewControllerAnimated:YES completion:nil];
        if (gotoAccount) {
            if (self.reloadOrderListBlock) {
                self.reloadOrderListBlock(_orderModel);
            }
            [ZFAnalytics settleAccountInfoProcedureWithProduct:self.goodsArray step:3 option:nil screenName:@"PaySuccess"];
            [ZFAnalytics trasactionAccountInfoWithProduct:self.goodsArray order:self.orderModel screenName:@"PaySuccess"];
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
    };
   
    [self presentViewController:finischVC animated:YES completion:nil];
}


- (void)jumpToOrderFailurViewController {
    OrderFailureViewController *failureVC = [[OrderFailureViewController alloc] init];
    @weakify(failureVC)
    failureVC.orderFailureBlock = ^{
        @strongify(failureVC)
        [failureVC dismissViewControllerAnimated:YES completion:nil];
        // 谷歌统计
        [ZFAnalytics clickButtonWithCategory:@"Payment Failure" actionName:@"Payment Failure - My Account" label:@"Payment Failure - My Account"];
        
    };
    [self presentViewController:failureVC animated:YES completion:nil];
}


#pragma mark - Lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (OrderDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[OrderDetailViewModel alloc] init];
        _viewModel.controller = self;
    }
    return _viewModel;
}

- (void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:ZFLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
