//
//  MessagesViewModel.h
//  Zaful
//
//  Created by DBP on 17/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface MessagesViewModel : BaseViewModel<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,weak) UIViewController *controller;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
