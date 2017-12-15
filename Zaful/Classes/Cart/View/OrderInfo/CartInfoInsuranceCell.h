//
//  CartInfoInsuranceCell.h
//  OrderInfoTest
//
//  Created by zhaowei on 2017/3/1.
//  Copyright © 2017年 share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartCheckOutModel.h"

@interface CartInfoInsuranceCell : UITableViewCell

+ (CartInfoInsuranceCell *)insuranceCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, copy) void (^checkTouchBlock)(BOOL isSelected);

@property (nonatomic,strong) NSArray *insuranceValue;

@end
