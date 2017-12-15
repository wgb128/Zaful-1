//
//  CartInfoPlaceOrderView.m
//  Zaful
//
//  Created by zhaowei on 2017/6/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CartInfoPlaceOrderView.h"

@interface CartInfoPlaceOrderView ()
@property (nonatomic, strong) UIButton *placeOrderBtn;
@end

@implementation CartInfoPlaceOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectZero]) {
        
        self.placeOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.placeOrderBtn setTitle:ZFLocalizedString(@"CartOrderInformationBottomView_PlaceOrderBtn",nil) forState:UIControlStateNormal];
        [self.placeOrderBtn setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        self.placeOrderBtn.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        self.placeOrderBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [self.placeOrderBtn addTarget:self action:@selector(placeOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.placeOrderBtn];
        [self.placeOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(49);
        }];
    }
    return self;
}

#pragma mark - Target Action
- (void)placeOrderBtnClick {
    
}



@end
