//
//  NoShippingOrPaymentCell.h
//  Zaful
//
//  Created by 7FD75 on 16/9/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoShippingOrPaymentCell : UITableViewCell

@property (nonatomic, assign) BOOL isNoShippingCell;

+ (NoShippingOrPaymentCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@end
