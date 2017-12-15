//
//  OrderDetailGoodsCell.h
//  Zaful
//
//  Created by DBP on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderDetailGoodModel;
typedef void (^GotoOrderDetailBlock)(NSIndexPath *indexPath);
@interface OrderDetailGoodsCell : UITableViewCell

@property (nonatomic,copy) void (^reviewBlock)(NSInteger row);

@property (nonatomic,copy) void (^goosDetailBlock)(NSInteger row);

- (void)setArray:(NSArray *)array andOrderStatue:(NSString *)orderStatue;
+ (OrderDetailGoodsCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
