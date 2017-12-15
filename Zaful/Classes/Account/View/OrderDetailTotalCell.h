//
//  OrderDetailTotalCell.h
//  Zaful
//
//  Created by DBP on 17/3/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailOrderModel.h"

@interface OrderDetailTotalCell : UITableViewCell
@property (nonatomic, copy) void(^orderDetailPayStatueBlock)(NSInteger tag);
@property (nonatomic, strong) OrderDetailOrderModel *orderModel;
+ (OrderDetailTotalCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
