//
//  OrderInfoViewModel.h
//  Zaful
//
//  Created by TsangFa on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@class CartOrderInfoViewController;
@class CartCheckOutModel;

typedef void (^RefreshBlock) ();

@interface OrderInfoViewModel : BaseViewModel<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) CartOrderInfoViewController *controller;

@property (nonatomic, strong) CartCheckOutModel *checkOutModel;

@property (nonatomic, copy) RefreshBlock   refreshBlock;

/**
 1. 有货到付款   place order ==>如果没有完善国家运营号,先去完善 ===>再跳转手机号验证 ==> 付款页面
 2. 无货到付款   place order ==> 付款页面
 */
- (void)jumpToPayment;

@end
