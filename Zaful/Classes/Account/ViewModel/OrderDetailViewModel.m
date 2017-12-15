//
//  OrderDetailViewModel.m
//  Zaful
//
//  Created by DBP on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "OrderDetailViewModel.h"
#import "OrderDetailOrderCell.h"
#import "OrderDetailDeliveryCell.h"
#import "OrderDetailGoodsCell.h"
#import "OrderDetailApi.h"
#import "OrderDetailGoodModel.h"
#import "OrderDetailOrderModel.h"
#import "OrderDetailTotalCell.h"
#import "ZFPaymentView.h"
#import "OrdersCancelApi.h"
#import "WriteReviewViewController.h"
//我的评论界面
#import "CheckReviewViewController.h"
#import "OrderDetailAddressCell.h"
#import "ZFGoodsDetailViewController.h"

#import "RemindersApi.h"
#import "ZFTrackingPackageModel.h"
#import "ZFTrackingListModel.h"
#import "ZFTrackingPackageApi.h"

@interface OrderDetailViewModel ()
/**
 *  支付方式，未支付状态，可以更换支付方式再支付，暂时不用
 */
@property (nonatomic, strong) NSArray *payment_list;

@property (nonatomic, strong) NSMutableArray *goodsArray;

@property (nonatomic, strong) OrderDetailOrderModel *orderModel;

@property (nonatomic, strong) NSArray *sectionArray;
@end

@implementation OrderDetailViewModel

- (NSArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = @[ 
                          [OrderDetailOrderCell class],
                          [OrderDetailDeliveryCell class],
                          [OrderDetailAddressCell class],
                          [OrderDetailGoodsCell class],
                          [OrderDetailTotalCell class],
                          
                          ];
    }
    return _sectionArray;
}

- (void)requestNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    OrderDetailApi *api = [[OrderDetailApi alloc] initWithOrderId:parmaters];
    @weakify(self)
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        @strongify(self)
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[OrderDetailGoodModel class] json:requestJSON[@"result"][@"goods_list"]];
            self.goodsArray = [NSMutableArray arrayWithArray:array];
            self.orderModel = [OrderDetailOrderModel yy_modelWithJSON:requestJSON[@"result"][@"order"]];
            if (self.orderModel == nil) {
                self.orderModel = [OrderDetailOrderModel new];
            }
            
            if (completion) {
                completion(@[self.orderModel,self.goodsArray]);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
        
    }];
}

- (void)requestOrderDetailData:(void (^)(id obj))completion {
    OrderDetailApi *api = [[OrderDetailApi alloc] initWithOrderId:self.orderModel.order_id];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[OrderDetailGoodModel class] json:requestJSON[@"result"][@"goods_list"]];
            self.goodsArray = [NSMutableArray arrayWithArray:array];
            self.orderModel = [OrderDetailOrderModel yy_modelWithJSON:requestJSON[@"result"][@"order"]];
            if (completion) {
                completion(self.orderModel);
            }
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

- (void)requestData:(void (^)(id obj))completion{
    OrderDetailApi *api = [[OrderDetailApi alloc] initWithOrderId:self.orderModel.order_id];
    @weakify(self)
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        @strongify(self)
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[OrderDetailGoodModel class] json:requestJSON[@"result"][@"goods_list"]];
            self.goodsArray = [NSMutableArray arrayWithArray:array];
            self.orderModel = [OrderDetailOrderModel yy_modelWithJSON:requestJSON[@"result"][@"order"]];
            if (completion) {
                completion(nil);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        [self showNoNetworkViewInView:self.controller.view buttonBlock:^{
            [self requestData:nil];
            
        }];
    }];
}

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

- (void)requestTrackingPackageData:(NSString *)orderID completion:(void (^)(NSArray<ZFTrackingPackageModel *> *array,NSString *msg,NSString *state))completion failure:(void (^)(id obj))failure {
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

            if (completion) {
                completion(dataArray,requestJSON[@"result"][@"msg"],requestJSON[@"result"][@"state"]);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        ZFLog(@"\n-------------------------- 错误日志 --------------------------\n接口:%@\n状态码:%ld\n报错信息:%@",NSStringFromClass(api.class),api.responseStatusCode,api.responseString);
    }];
}

/**
 *  Cancel后请求这个商品的order status,刷新这个cell
 *
 */
- (void)requestCancelOrder:(id)parmaters completion:(void (^)(BOOL isOK))completion {
    
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
        [MBProgressHUD hideHUD];
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

#pragma mark - tableviewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class class = self.sectionArray[indexPath.section];
    @weakify(self)
    @weakify(tableView)
    if (class == [OrderDetailOrderCell class]) {
        OrderDetailOrderCell *orderCell = [OrderDetailOrderCell cellWithTableView:tableView indexPath:indexPath];
        orderCell.orderModel = self.orderModel;
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return orderCell;
    } else if (class == [OrderDetailDeliveryCell class]) {
        OrderDetailDeliveryCell *deliveryCell = [OrderDetailDeliveryCell cellWithTableView:tableView indexPath:indexPath];
        deliveryCell.orderModel = self.orderModel;
        deliveryCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return deliveryCell;
    } else if (class == [OrderDetailAddressCell class]) {
        OrderDetailAddressCell *addressCell = [OrderDetailAddressCell cellWithTableView:tableView indexPath:indexPath];
        addressCell.orderModel = self.orderModel;
        addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return addressCell;
    } else if (class == [OrderDetailGoodsCell class]) {
        OrderDetailGoodsCell *goodCell = [OrderDetailGoodsCell cellWithTableView:tableView indexPath:indexPath];
        [goodCell setArray:self.goodsArray andOrderStatue:self.orderModel.order_status];
        
        goodCell.reviewBlock = ^(NSInteger row){
            @strongify(self)
            @strongify(tableView)
            OrderDetailGoodModel *goodsModel = self.goodsArray[row];
            if (!goodsModel.is_review) {
                WriteReviewViewController *writeReviewVC = [WriteReviewViewController new];
                writeReviewVC.goodsModel = goodsModel;
                writeReviewVC.orderid = self.orderModel.order_id;
                @weakify(self)
                @weakify(tableView)
                writeReviewVC.blockSuccess = ^{
                    @strongify(self)
                    @strongify(tableView)
                    @weakify(tableView)
                    // 评论成功回调
                    [self requestData:^(id obj) {
                        @strongify(tableView)
                        [tableView reloadData];
                    }];
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
            OrderDetailGoodModel *goodsModel = self.goodsArray[row];
            ZFGoodsDetailViewController *goodDetailVC = [[ZFGoodsDetailViewController alloc] init];
            goodDetailVC.goodsId = goodsModel.goods_id;
            [self.controller.navigationController pushViewController:goodDetailVC animated:YES];
        };
        goodCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return goodCell;
        
    } else if (class == [OrderDetailTotalCell class]) {
        OrderDetailTotalCell *priceCell = [OrderDetailTotalCell cellWithTableView:tableView indexPath:indexPath];
        priceCell.orderModel = self.orderModel;
        priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return priceCell;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark - private methods
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
@end
