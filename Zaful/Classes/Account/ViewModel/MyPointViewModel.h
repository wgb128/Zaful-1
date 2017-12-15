//
//  MyPointViewModel.h
//  Zaful
//
//  Created by DBP on 17/2/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface MyPointViewModel : BaseViewModel<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,weak) UIViewController *controller;
@property (nonatomic, strong) UILabel *headerLabel;
@end
