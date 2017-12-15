//
//  CartInfoGoodsCell.h
//  Zaful
//
//  Created by zhaowei on 2017/4/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartInfoGoodsCell : UITableViewCell
@property (nonatomic, strong) NSArray *goodsList;

+ (CartInfoGoodsCell *)goodsCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
