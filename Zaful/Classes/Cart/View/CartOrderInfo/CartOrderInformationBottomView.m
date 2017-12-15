//
//  CartOrderInformationBottomView.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/26.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CartOrderInformationBottomView.h"

@implementation CartOrderInformationBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviewContraint];
    }
    return self;
}

-(void)addSubviewContraint
{
    [self addSubview:self.placeOrderBtn];
    [self.placeOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


-(UIButton *)placeOrderBtn{
    if (!_placeOrderBtn) {
        _placeOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_placeOrderBtn setTitle:ZFLocalizedString(@"CartOrderInformationBottomView_PlaceOrderBtn",nil) forState:UIControlStateNormal];
        [_placeOrderBtn setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        _placeOrderBtn.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        _placeOrderBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [_placeOrderBtn addTarget:self action:@selector(placeOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _placeOrderBtn;
}

- (void)placeOrderBtnClick
{
    if ([self.delegate respondsToSelector:@selector(cartOrderInformationBottomViewPlaceOrderButtonClick:)]) {
        [self.delegate cartOrderInformationBottomViewPlaceOrderButtonClick:self];
        // 谷歌统计
        [ZFAnalytics clickButtonWithCategory:@"Order" actionName:@"Order - Place Order" label:@"Order - Place Order"];
    }
}

@end
