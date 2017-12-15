//
//  MyOrderDetailOrderCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/20.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyOrderDetailOrderModel.h"

@interface MyOrderDetailOrderCell : UITableViewCell

@property (nonatomic, strong) MyOrderDetailOrderModel *orderModel;

+ (MyOrderDetailOrderCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@end
