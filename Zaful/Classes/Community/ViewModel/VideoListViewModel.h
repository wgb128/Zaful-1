//
//  VideoListViewModel.h
//  Zaful
//
//  Created by zhaowei on 2016/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface VideoListViewModel : BaseViewModel<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,weak) UIViewController *controller;

@end
