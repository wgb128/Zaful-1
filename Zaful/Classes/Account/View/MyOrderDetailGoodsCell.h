//
//  MyOrderDetailGoodsCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/12.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyOrderDetailGoodModel.h"

@interface MyOrderDetailGoodsCell : UITableViewCell

@property (nonatomic,copy) void (^reviewBlock)(NSInteger tag);

- (void) initWithGoodsModel:(MyOrderDetailGoodModel *)goodsModel orderStatue:(NSInteger)orderStatue;

@property (nonatomic, strong) MyOrderDetailGoodModel *goodsModel;

@end
