//
//  CartOrderInfoAddressCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/7/26.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookModel.h"

@interface CartOrderInfoAddressCell : UITableViewCell
@property (nonatomic, strong) AddressBookModel *addressModel;
+ (CartOrderInfoAddressCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
@end
