//
//  CartInfoShippingView.h
//  OrderInfoTest
//
//  Created by zhaowei on 2017/3/1.
//  Copyright © 2017年 share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippingListModel.h"

@interface CartInfoShippingView : UIView

@property (nonatomic, strong) ShippingListModel *model;

- (instancetype)initWithFrame:(CGRect)frame index:(NSUInteger)index;



@end
