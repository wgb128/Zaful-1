//
//  FriendsCommendViewModel.h
//  Zaful
//
//  Created by zhaowei on 2017/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface FriendsCommendViewModel : BaseViewModel<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,weak) UIViewController *controller;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end
