//
//  CartInfoAddressCell.h
//  OrderInfoTest
//
//  Created by zhaowei on 2017/2/24.
//  Copyright © 2017年 share. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFAddressInfoModel;

@interface CartInfoAddressCell : UITableViewCell

@property (nonatomic, strong) ZFAddressInfoModel *addressModel;

+ (CartInfoAddressCell *)addressCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
