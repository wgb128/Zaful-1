//
//  OrderDetailGoodsView.h
//  Zaful
//
//  Created by DBP on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderDetailGoodModel;

@interface OrderDetailGoodsView : UIView

@property (nonatomic, strong) OrderDetailGoodModel *goodsModel;

@property (nonatomic, assign) NSInteger orderStatue;

@property (nonatomic, copy) void (^reviewBlock)(NSInteger row);

- (void)setGoodsModel:(OrderDetailGoodModel *)goodsModel andOrderStatue:(NSString *)orderStatueValue andViewTag:(NSInteger)viewTag;
@end
