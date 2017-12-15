//
//  AccountCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *nameLabel;

+ (AccountCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@end
