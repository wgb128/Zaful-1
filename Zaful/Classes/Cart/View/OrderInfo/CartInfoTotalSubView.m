//
//  CartInfoTotalSubView.m
//  OrderInfoTest
//
//  Created by zhaowei on 2017/3/1.
//  Copyright © 2017年 share. All rights reserved.
//

#import "CartInfoTotalSubView.h"

@interface CartInfoTotalSubView ()
@property (nonatomic, strong) UILabel *rightValueLabel;
@end

@implementation CartInfoTotalSubView

- (instancetype)initWithRightTitle:(NSString *)rightTitle defaultColor:(BOOL)defaultColor {
    if (self = [super initWithFrame:CGRectZero]) {

        self.leftTitleLabel = [[UILabel alloc] init];
        self.leftTitleLabel.backgroundColor = [UIColor whiteColor];
        self.leftTitleLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        self.leftTitleLabel.font = [UIFont systemFontOfSize:14];
        self.leftTitleLabel.text = rightTitle;
        
        [self addSubview:self.leftTitleLabel];
        [self.leftTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(15);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.leading.mas_equalTo(self.mas_leading).offset(12);
        }];
        
        self.rightValueLabel = [[UILabel alloc] init];
        self.rightValueLabel.backgroundColor = [UIColor whiteColor];
        self.rightValueLabel.textColor = defaultColor ? ZFCOLOR(51, 51, 51, 1.0) : ZFCOLOR(245, 86, 88, 1.0);
        self.rightValueLabel.font = defaultColor ? [UIFont systemFontOfSize:14] : [UIFont boldSystemFontOfSize:14];
        
        [self addSubview:self.rightValueLabel];
        [self.rightValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.leftTitleLabel);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
        }];
    }
    return self;
}

- (void)setRightValue:(NSString *)rightValue {
    _rightValue = rightValue;
    self.rightValueLabel.text = rightValue;
}

- (void)setDefaultColor:(BOOL)defaultColor {
    self.rightValueLabel.textColor = defaultColor ? ZFCOLOR(51, 51, 51, 1.0) : ZFCOLOR(245, 86, 88, 1.0);
}
@end
