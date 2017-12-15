//
//  MyCouponViewModel.h
//  Zaful
//
//  Created by DBP on 17/2/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface MyCouponViewModel : BaseViewModel<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSNumber *currentTime;
@end
