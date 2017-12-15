//
//  MyOrdersListCell.h
//  Yoshop
//
//  Created by huangxieyue on 16/7/8.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrdersModel.h"

@interface MyOrdersListCell : UITableViewCell

+ (MyOrdersListCell *)ordersListCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong) MyOrdersModel *orderModel;

@property (nonatomic,copy) void (^paymentBlock)();

@property (nonatomic, copy) void (^detailBlock)();

@property (nonatomic, copy) void (^trackingBlock)(MyOrdersModel *model);

@end
