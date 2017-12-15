//
//  CartInfoCouponCell.h
//  OrderInfoTest
//
//  Created by zhaowei on 2017/2/24.
//  Copyright © 2017年 share. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartInfoCouponCell : UITableViewCell

@property (nonatomic,copy) NSString *couponString;

+ (CartInfoCouponCell *)couponCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
