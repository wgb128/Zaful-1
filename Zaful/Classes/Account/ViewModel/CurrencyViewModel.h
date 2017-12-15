//
//  CurrencyViewModel.h
//  Zaful
//
//  Created by DBP on 17/2/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface CurrencyViewModel : BaseViewModel <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, copy) void (^selectCurrencyBlock)(NSString *currency);

- (void)requestData;

@end
