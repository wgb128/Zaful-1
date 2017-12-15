//
//  MyOrderDetailTotalCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/13.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderDetailOrderModel.h"
#import "MyOrderDetailGoodModel.h"

typedef void (^PayNowBlock) ();

typedef void (^CancelBlock) ();

@interface MyOrderDetailTotalCell : UITableViewCell

@property (nonatomic, strong) MyOrderDetailOrderModel *orderModel;

@property (nonatomic, strong) NSArray *goodsArray;

@property (nonatomic, copy) PayNowBlock payNowBlock;

@property (nonatomic, copy) CancelBlock cancelBlock;

@end
