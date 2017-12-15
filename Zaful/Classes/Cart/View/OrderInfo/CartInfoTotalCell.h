//
//  CartInfoTotalCell.h
//  OrderInfoTest
//
//  Created by zhaowei on 2017/2/24.
//  Copyright © 2017年 share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoManager.h"

@interface CartInfoTotalCell : UITableViewCell

@property (nonatomic,strong) OrderInfoManager *manager;

+ (CartInfoTotalCell *)totalCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
 
