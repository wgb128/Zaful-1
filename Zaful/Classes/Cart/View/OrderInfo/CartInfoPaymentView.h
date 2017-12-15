//
//  CartInfoPaymentView.h
//  OrderInfoTest
//
//  Created by zhaowei on 2017/3/1.
//  Copyright © 2017年 share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentListModel.h"

@interface CartInfoPaymentView : UIView

@property (nonatomic,strong) PaymentListModel *model;

- (instancetype)initWithFrame:(CGRect)frame index:(NSUInteger)index;

@end
