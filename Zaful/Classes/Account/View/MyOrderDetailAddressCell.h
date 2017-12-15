//
//  MyOrderDetailAddressCell.h
//  Zaful
//
//  Created by DBP on 17/3/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderDetailOrderModel.h"

@interface MyOrderDetailAddressCell : UITableViewCell
@property (nonatomic, strong) MyOrderDetailOrderModel *orderModel;
+ (MyOrderDetailAddressCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
@end
