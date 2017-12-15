//
//  AccountViewModel.h
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "BaseViewModel.h"

#import "AccountViewController.h"

#import "AccountHeaderView.h"

@interface AccountViewModel : BaseViewModel <UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,AccountHeaderViewDelegate>

@property (nonatomic, weak) AccountViewController *controller;

@property (nonatomic, weak) UITableView *tableView;

@end
