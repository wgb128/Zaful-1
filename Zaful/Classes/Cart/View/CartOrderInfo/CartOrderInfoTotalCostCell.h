//
//  CartOrderInfoTotalCostCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartCheckOutTotalModel.h"
#import "CartCreateOrderManager.h"

@interface CartOrderInfoTotalCostCell : UITableViewCell

+ (CartOrderInfoTotalCostCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

- (void)refreshDataWithTotalModel:(CartCheckOutTotalModel *)totalModel manager:(CartCreateOrderManager *)manager;

@end
