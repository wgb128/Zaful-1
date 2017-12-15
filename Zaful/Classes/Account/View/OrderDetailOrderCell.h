//
//  OrderDetailOrderCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/20.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailOrderModel;

@interface OrderDetailOrderCell : UITableViewCell

@property (nonatomic, strong) OrderDetailOrderModel *orderModel;

+ (OrderDetailOrderCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
