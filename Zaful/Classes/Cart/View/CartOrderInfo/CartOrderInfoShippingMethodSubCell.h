//
//  CartOrderInfoShippingMethodSubView.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/8.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartOrderInfoShippingMethodSubCell;

typedef void (^ChangeSelectedStatusBlock) (NSIndexPath *indexPath);

#import "ShippingListModel.h"

@interface CartOrderInfoShippingMethodSubCell : UITableViewCell

+ (CartOrderInfoShippingMethodSubCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) ShippingListModel *model;

@property (nonatomic, strong) UIButton *standardSelectBtn;

@property (nonatomic, copy) ChangeSelectedStatusBlock changeSeletedStatusBlock;

@end
