//
//  CartInfoPaymentCell.h
//  OrderInfoTest
//
//  Created by zhaowei on 2017/2/24.
//  Copyright © 2017年 share. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaymentListModel;

@interface CartInfoPaymentCell : UITableViewCell

@property (nonatomic,strong) NSArray *paymentListAry;

@property (nonatomic,copy) void (^selectedTouchBlock)(PaymentListModel *listModel);

+ (CartInfoPaymentCell *)paymentCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;



@end
