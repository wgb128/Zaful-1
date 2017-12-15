//
//  AccountListViewModel.h
//  Zaful
//
//  Created by DBP on 17/3/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"
#import "AccountHeaderView.h"

@interface AccountListViewModel : BaseViewModel <AccountHeaderViewDelegate>
@property (nonatomic, weak) UIViewController *controller;
@end
