//
//  CartOrderInfoWorldPayCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/16.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartOrderInfoWorldPayCell : UITableViewCell

typedef void (^WorldPaySelectBlock)();

+ (CartOrderInfoWorldPayCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) UILabel *worldPayLabel;

@property (nonatomic, strong) UIButton *worldPaySelectBtn;

@property (nonatomic, copy) WorldPaySelectBlock worldPaySelectBlock;

@end
