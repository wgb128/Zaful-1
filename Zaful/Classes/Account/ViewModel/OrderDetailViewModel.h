//
// OrderDetailViewModel.h
//  Zaful
//
//  Created by DBP on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"
#import "OrderDetailViewController.h"

@class ZFTrackingPackageModel;

typedef void (^ReloadOrderListBlock) (OrderDetailOrderModel *statusModel);
@interface OrderDetailViewModel : BaseViewModel <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) OrderDetailViewController *controller;

- (void)requestCancelOrder:(id)parmaters completion:(void (^)(BOOL isOK))completion;
- (void)requestOrderDetailData:(void (^)(id obj))completion;
- (void)requestOrderReminders:(id)parmaters completion:(void (^)(id obj))completion;
- (void)requestTrackingPackageData:(NSString *)orderID completion:(void (^)(NSArray<ZFTrackingPackageModel *> *array,NSString *msg,NSString *state))completion failure:(void (^)(id obj))failure;

@end
