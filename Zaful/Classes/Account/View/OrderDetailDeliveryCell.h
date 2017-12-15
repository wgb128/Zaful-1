//
//  OrderDetailDeliveryCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/12.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailOrderModel;

@interface OrderDetailDeliveryCell : UITableViewCell

@property (nonatomic, strong) OrderDetailOrderModel *orderModel;

+ (OrderDetailDeliveryCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
