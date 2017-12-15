//
//  CartInfoShippingCell.h
//  OrderInfoTest
//
//  Created by zhaowei on 2017/2/24.
//  Copyright © 2017年 share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoManager.h"

@class ShippingListModel;

@interface CartInfoShippingCell : UITableViewCell

@property (nonatomic,strong) NSArray *shippingListAry;

@property (nonatomic,strong) OrderInfoManager *manager;

@property (nonatomic,copy) void (^selectedTouchBlock)(ShippingListModel *listModel);

+ (CartInfoShippingCell *)shippingCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
