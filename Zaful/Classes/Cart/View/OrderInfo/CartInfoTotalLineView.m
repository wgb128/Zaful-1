//
//  CartInfoTotalLineView.m
//  OrderInfoTest
//
//  Created by zhaowei on 2017/3/1.
//  Copyright © 2017年 share. All rights reserved.
//

#import "CartInfoTotalLineView.h"

@implementation CartInfoTotalLineView

- (instancetype)initWithColor:(UIColor *)color height:(CGFloat)height{
    if (self = [super initWithFrame:CGRectZero]) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = color;
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(15, 0, 0, 0));
            make.height.mas_equalTo(height);
        }];
    }
    return self;
}

@end
