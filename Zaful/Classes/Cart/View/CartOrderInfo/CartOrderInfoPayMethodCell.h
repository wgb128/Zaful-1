//
//  CartOrderInfoPayMethodCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartCheckOutModel.h"

@interface CartOrderInfoPayMethodCell : UITableViewCell

+ (CartOrderInfoPayMethodCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

-(void)refreshDataWithCheckOutModel:(CartCheckOutModel *)cartCheckOutModel;

@property (nonatomic, strong) UIButton *paymentSelectBtn;

@end
