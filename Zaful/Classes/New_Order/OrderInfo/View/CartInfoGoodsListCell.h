//
//  CartInfoGoodsListCell.h
//  Zaful
//
//  Created by zhaowei on 2017/4/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckOutGoodListModel;
@interface CartInfoGoodsListCell : UITableViewCell
+ (CartInfoGoodsListCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) CheckOutGoodListModel *goodsModel;
@end
