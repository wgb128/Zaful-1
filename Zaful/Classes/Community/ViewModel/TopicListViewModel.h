//
//  TopicListViewModel.h
//  Zaful
//
//  Created by zhaowei on 2016/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface TopicListViewModel : BaseViewModel<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UIViewController *controller;

@end
