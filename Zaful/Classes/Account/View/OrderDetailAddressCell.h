//
//  OrderDetailAddressCell.h
//  Zaful
//
//  Created by DBP on 17/3/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderDetailOrderModel;

@interface OrderDetailAddressCell : UITableViewCell
@property (nonatomic, strong) OrderDetailOrderModel *orderModel;
+ (OrderDetailAddressCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
