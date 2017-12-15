//
//  MyOrderDetailViewModel.m
//  Zaful
//
//  Created by DBP on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "MyOrderDetailViewModel.h"
#import "MyOrderDetailOrderCell.h"
#import "MyOrderDetailDeliveryCell.h"
#import "OrderDetailGoodsCell.h"
#import "MyOrderDetailApi.h"
#import "MyOrderDetailGoodModel.h"
#import "MyOrderDetailOrderModel.h"
#import "OrderDetailTotalCell.h"
#import "OrderListPayPalView.h"
#import "AccountCancelMyOrdersApi.h"
#import "WriteReviewViewController.h"
//我的评论界面
#import "CheckReviewViewController.h"
#import "MyOrderDetailAddressCell.h"
#import "GoodsDetailViewController.h"

@interface MyOrderDetailViewModel ()
/**
 *  支付方式，未支付状态，可以更换支付方式再支付，暂时不用
 */
@property (nonatomic, strong) NSArray *payment_list;

@property (nonatomic, strong) NSMutableArray *goodsArray;

@property (nonatomic, strong) MyOrderDetailOrderModel *orderModel;
@end

@implementation MyOrderDetailViewModel

- (void)requestNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
    MyOrderDetailApi *api = [[MyOrderDetailApi alloc] initWithOrderId:parmaters];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        id requestJSON = [NSStringUtils desEncrypt:request];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[MyOrderDetailGoodModel class] json:requestJSON[@"result"][@"goods_list"]];
            self.goodsArray = [NSMutableArray arrayWithArray:array];
            self.orderModel = [MyOrderDetailOrderModel yy_modelWithJSON:requestJSON[@"result"][@"order"]];
        }else{
            [self alertMessage:requestJSON[@"statusCode"]];
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

- (void)requestOrderDetailData:(void (^)(id obj))completion{
    MyOrderDetailApi *api = [[MyOrderDetailApi alloc] initWithOrderId:self.orderModel.order_id];
    [api.accessoryArray addObject:[[RequestAccessory alloc] initWithApperOnView:self.controller.view]];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        id requestJSON = [NSStringUtils desEncrypt:request];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[MyOrderDetailGoodModel class] json:requestJSON[@"result"][@"goods_list"]];
            self.goodsArray = [NSMutableArray arrayWithArray:array];
            self.orderModel = [MyOrderDetailOrderModel yy_modelWithJSON:requestJSON[@"result"][@"order"]];
            [self.tableView reloadData];
            if (completion) {
                completion(self.orderModel);
            }
        }else{
            [self alertMessage:requestJSON[@"statusCode"]];
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [self alertMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}


/**
 *  Cancel后请求这个商品的order status,刷新这个cell
 *
 */
- (void)requestCancelOrder:(id)parmaters completion:(void (^)(BOOL isOK))completion{
    
    __block BOOL isSuccess = NO;
    AccountCancelMyOrdersApi *api = [[AccountCancelMyOrdersApi alloc] initWithOrderId:parmaters];
    [api.accessoryArray addObject:[[RequestAccessory alloc] initWithApperOnView:self.controller.view]];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        id requestJSON = [NSStringUtils desEncrypt:request];
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                isSuccess = YES;
            }
            [self alertMessage:requestJSON[@"result"][@"msg"]];
        }else{
            [self alertMessage:requestJSON[@"statusCode"]];
        }
        
        if (completion) {
            completion(isSuccess);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [self alertMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

- (void)requestData {
    
    MyOrderDetailApi *api = [[MyOrderDetailApi alloc] initWithOrderId:self.orderModel.order_id];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        id requestJSON = [NSStringUtils desEncrypt:request];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[MyOrderDetailGoodModel class] json:requestJSON[@"result"][@"goods_list"]];
            self.goodsArray = [NSMutableArray arrayWithArray:array];
            self.orderModel = [MyOrderDetailOrderModel yy_modelWithJSON:requestJSON[@"result"][@"order"]];
            [self.tableView reloadData];
        }else{
            [self alertMessage:requestJSON[@"statusCode"]];
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [self showNoNetworkViewInView:self.controller.view buttonBlock:^{
            
            [self requestData];
            
        }];
    }];
}


#pragma mark - tableviewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 4){
        return 20;
    }
    return 0.001;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
            MyOrderDetailOrderCell *orderCell = [MyOrderDetailOrderCell cellWithTableView:tableView andIndexPath:indexPath];
            orderCell.orderModel = self.orderModel;
            cell = orderCell;
            break;
        }
        case 1:
        {
            MyOrderDetailDeliveryCell *deliveryCell = [MyOrderDetailDeliveryCell cellWithTableView:tableView andIndexPath:indexPath];
            deliveryCell.orderModel = self.orderModel;
            cell = deliveryCell;
            break;
        }
        case 2:  // address
        {
            MyOrderDetailAddressCell *addressCell = [MyOrderDetailAddressCell cellWithTableView:tableView andIndexPath:indexPath];
            addressCell.orderModel = self.orderModel;
            cell = addressCell;
            break;
        }
        case 3: // order SN,tracking number ,pay status , good image, subTotal...
        {
            OrderDetailGoodsCell *goodCell = [OrderDetailGoodsCell cellWithTableView:tableView andIndexPath:indexPath];
            [goodCell setArray:self.goodsArray andOrderStatue:self.orderModel.order_status];
            @weakify(self)
            goodCell.reviewBlock = ^(NSInteger row){
                @strongify(self)
                MyOrderDetailGoodModel *goodsModel = self.goodsArray[row];
                if (!goodsModel.is_review) {
                    WriteReviewViewController *writeReviewVC = [WriteReviewViewController new];
                    writeReviewVC.goodsModel = goodsModel;
                    writeReviewVC.orderid = self.orderModel.order_id;
                    @weakify(self)
                    writeReviewVC.blockSuccess = ^{
                        @strongify(self)
                        // 评论成功回调
                        [self requestData];
                    };
                    [self.controller.navigationController pushViewController:writeReviewVC animated:YES];
                }else{
                    CheckReviewViewController *reviewView = [[CheckReviewViewController alloc]init];
                    reviewView.goodsModel = goodsModel;
                    reviewView.orderid = self.orderModel.order_id;
                    [self.controller.navigationController pushViewController:reviewView animated:YES];
                }
                
            };
            
            //进入商品详情
            goodCell.goosDetailBlock = ^(NSInteger row) {
                MyOrderDetailGoodModel *goodsModel = self.goodsArray[row];
                GoodsDetailViewController *goodDetailVC = [[GoodsDetailViewController alloc] init];
                goodDetailVC.goodsId = goodsModel.goods_id;
                [self.controller.navigationController pushViewController:goodDetailVC animated:YES];
            };
            
            cell = goodCell;
            break;
        }
        case 4: // 总价格 ,支付按钮,取消按钮
        {
            OrderDetailTotalCell *priceCell = [OrderDetailTotalCell cellWithTableView:tableView andIndexPath:indexPath];
            priceCell.orderModel = self.orderModel;
            @weakify(self)
            priceCell.orderDetailPayStatueBlock = ^(NSInteger tag){
                @strongify(self)
                switch (tag) {
                    case OrderDetailPay:
                    {
                        if ([self.orderModel.pay_name  isEqualToString:@"PayPal"] || [self.orderModel.pay_name  isEqualToString:@"WorldPay"])
                        {
                            OrderListPayPalView *ppView = [[OrderListPayPalView alloc] initWithFrame:CGRectZero];
                            ppView.url = self.orderModel.pay_url;
                            ppView.block = ^(PaymentStatus status){
                                // 支付页回调
                                switch (status) {
                                    case PaymentStatusUnknown:
                                    case PaymentStatusCancel:
                                    case PaymentStatusDone:
                                    case PaymentStatusFail:
                                    {
                                        @weakify(self)
                                        [self requestOrderDetailData:^(id obj) {
                                            @strongify(self)
                                            self.orderModel = obj;
                                            
                                            if ([self.orderModel.order_status integerValue] == 1) {
                                                
                                                if (self.reloadOrderListBlock) {
                                                    self.reloadOrderListBlock(obj);
                                                    
                                                    [ZFAnalytics settleAccountInfoProcedureWithProduct:self.goodsArray step:3 option:nil screenName:@"PaySuccess"];
                                                    [ZFAnalytics trasactionAccountInfoWithProduct:self.goodsArray order:self.orderModel screenName:@"PaySuccess"];
                                                    // 谷歌统计
                                                    [ZFAnalytics clickButtonWithCategory:@"Payment Success" actionName:@"Payment Success - My Account" label:@"Payment Success - My Account"];
                                                }
                                            }else{
                                                if (status == PaymentStatusCancel) {
                                                    [self showAlertViewWithTitle:ZFLocalizedString(@"OrderDetail_Cell_PaymentStatusCancel_Title",nil) Message:ZFLocalizedString(@"OrderDetail_Cell_PaymentStatusCancel_Message",nil)];
                                                }else{
                                                    [self showAlertViewWithTitle:ZFLocalizedString(@"OrderDetail_Cell_PaymentStatusFail_Title",nil) Message:ZFLocalizedString(@"OrderDetail_Cell_PaymentStatusFail_Message",nil)];
                                                    // 谷歌统计
                                                    [ZFAnalytics clickButtonWithCategory:@"Payment Failure" actionName:@"Payment Failure - My Account" label:@"Payment Failure - My Account"];
                                                }
                                            }
                                            
                                        }];
                                        
                                        break;
                                    }
                                }
                            };
                            [ppView show];
                        }
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
                            [self requestCancelOrder:self.orderModel.order_id completion:^(BOOL isOK) {
                                @strongify(self)
                                
                                if (isOK) {
                                    @weakify(self)
                                    [self requestOrderDetailData:^(id obj) {
                                        @strongify(self)
                                        if (self.reloadOrderListBlock) {
                                            self.reloadOrderListBlock(obj);
                                        }
                                    }];
                                }
                            }];
                        }];
                        [alertController addAction:cancelAction];
                        [alertController addAction:sureAction];
                        [self.controller presentViewController:alertController animated:YES completion:nil];
                    }
                        break;
                    default:
                        break;
                }
            };
            cell = priceCell;
            break;
        }
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:ZFLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self.controller presentViewController:alertController animated:YES completion:nil];
}
@end
