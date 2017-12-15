//
//  SettingViewModel.h
//  Zaful
//
//  Created by DBP on 17/2/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface SettingViewModel : BaseViewModel <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, strong) UITableView *tableView;
@end
