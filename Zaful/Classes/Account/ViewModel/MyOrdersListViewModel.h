//
//  MyOrdersListViewModel.h
//  Yoshop
//
//  Created by huangxieyue on 16/6/7.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "BaseViewModel.h"
#import "MyOrdersListViewController.h"

@interface MyOrdersListViewModel : BaseViewModel<UITableViewDataSource, UITableViewDelegate>

typedef void(^RefreshOrderListCompletionHandler)();

@property (nonatomic,weak) MyOrdersListViewController *controller;

@property (nonatomic, copy) RefreshOrderListCompletionHandler   refreshOrderListCompletionHandler;

- (void)requestOrderListNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

@end
