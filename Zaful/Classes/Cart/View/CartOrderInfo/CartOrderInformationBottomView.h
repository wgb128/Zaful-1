//
//  CartOrderInformationBottomView.h
//  Dezzal
//
//  Created by 7FD75 on 16/7/26.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartOrderInformationBottomView;

@protocol CartOrderInformationBottomViewDelegate <NSObject>

- (void)cartOrderInformationBottomViewPlaceOrderButtonClick:(CartOrderInformationBottomView *)bottomView;

@end

@interface CartOrderInformationBottomView : UIView

@property (nonatomic, strong) UIButton *placeOrderBtn;

@property (nonatomic, weak) id <CartOrderInformationBottomViewDelegate> delegate;

@end
