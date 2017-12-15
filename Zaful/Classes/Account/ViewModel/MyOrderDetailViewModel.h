//
// MyOrderDetailViewModel.h
//  Zaful
//
//  Created by DBP on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

typedef void (^ReloadOrderListBlock) (MyOrderDetailOrderModel *statusModel);
@interface MyOrderDetailViewModel : BaseViewModel <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, copy) ReloadOrderListBlock reloadOrderListBlock;
@end
