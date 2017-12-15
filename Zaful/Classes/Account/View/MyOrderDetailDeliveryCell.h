//
//  MyOrderDetailDeliveryCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/12.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyOrderDetailOrderModel.h"

@interface MyOrderDetailDeliveryCell : UITableViewCell

@property (nonatomic, strong) MyOrderDetailOrderModel *orderModel;

+ (MyOrderDetailDeliveryCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@end
