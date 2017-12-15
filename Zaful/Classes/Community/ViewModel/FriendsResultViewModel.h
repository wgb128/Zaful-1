//
//  FriendsResultViewModel.h
//  Zaful
//
//  Created by zhaowei on 2017/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface FriendsResultViewModel : BaseViewModel<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,weak) UIViewController *controller;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *friendResultTableView;
@end
