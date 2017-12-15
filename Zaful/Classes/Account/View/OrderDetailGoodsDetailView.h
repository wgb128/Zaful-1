//
//  OrderDetailGoodsDetailView.h
//  Zaful
//
//  Created by DBP on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderDetailGoodModel.h"

@interface OrderDetailGoodsDetailView : UIView
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *goodsTitle;
@property (nonatomic, strong) NSString *sku;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *reviewState;

@property (nonatomic, strong) MyOrderDetailGoodModel *goodsModel;

@property (nonatomic, assign) NSInteger orderStatue;

@property (nonatomic, copy) void (^reviewBlock)(NSInteger row);
@property (nonatomic, copy) void (^GotoOrderDetailBlock)(NSIndexPath *indexPath);

- (void)setGoodsModel:(MyOrderDetailGoodModel *)goodsModel andOrderStatue:(NSString *)orderStatueValue andViewTag:(NSInteger)viewTag;
@end
