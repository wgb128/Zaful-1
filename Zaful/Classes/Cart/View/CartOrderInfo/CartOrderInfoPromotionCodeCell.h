//
//  CartOrderInfoPromotionCodeCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartOrderInfoPromotionCodeCell : UITableViewCell

@property (nonatomic, strong) UILabel *saveLabel;

+ (CartOrderInfoPromotionCodeCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@end
