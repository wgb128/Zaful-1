//
//  CartOrderInfoPayPalCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/16.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PayPalSelectBlock) ();

@interface CartOrderInfoPayPalCell : UITableViewCell


+ (CartOrderInfoPayPalCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) UILabel *payPalLabel;

@property (nonatomic, strong) UIButton *paymentSelectBtn;

@property (nonatomic, copy ) PayPalSelectBlock payPalSelectBlock;

@end
