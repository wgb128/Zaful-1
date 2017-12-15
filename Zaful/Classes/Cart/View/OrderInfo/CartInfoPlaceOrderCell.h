//
//  CartInfoPlaceOrderCell.h
//  Zaful
//
//  Created by zhaowei on 2017/6/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartInfoPlaceOrderCell : UITableViewCell
+ (CartInfoPlaceOrderCell *)placeOrderCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@property (nonatomic,copy) void (^placeOrderBlock)();
@end
