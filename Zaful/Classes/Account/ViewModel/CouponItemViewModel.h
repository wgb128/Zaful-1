//
//  CouponItemViewModel.h
//  Zaful
//
//  Created by zhaowei on 2017/6/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface CouponItemViewModel : BaseViewModel<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, copy) NSString *kind;
@end
