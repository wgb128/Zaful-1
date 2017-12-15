//
//  GoodsSortViewController.h
//  Dezzal
//
//  Created by Y001 on 16/7/28.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "ZFBaseViewController.h"

@interface GoodsSortViewController : UIViewController  <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataArray;//显示的数据
@property (nonatomic, strong) NSMutableArray * statusArray;//是否选择的标识
@property (nonatomic, assign) NSInteger        selectIndex;//选择的是数组的哪一个。。
@property (nonatomic, copy) void (^sortBlock)(NSInteger selectType,NSString * oederby);

@end
