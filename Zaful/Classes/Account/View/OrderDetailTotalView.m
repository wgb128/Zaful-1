//
//  OrderDetailTotalView.m
//  Zaful
//
//  Created by DBP on 17/3/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "OrderDetailTotalView.h"

@interface OrderDetailTotalView ()
@property (nonatomic, strong) UILabel *rightLabel;
@end

@implementation OrderDetailTotalView

- (instancetype)initWithTitle:(NSString *)leftTitle andDefaultColor:(BOOL)DefaultColor {
    if (self = [super initWithFrame:CGRectZero]) {
        self.leftLabel = [[UILabel alloc] init];
        self.leftLabel.font = [UIFont systemFontOfSize:14];
        self.leftLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        self.leftLabel.text = leftTitle;
        [self addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(8);
            make.leading.mas_equalTo(self.mas_leading).offset(12);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
        }];
        
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.font = [UIFont systemFontOfSize:14];
        self.rightLabel.textColor = DefaultColor ? ZFCOLOR(51, 51, 51, 1.0) : ZFCOLOR(244, 67, 69, 1.0);
        [self addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.leftLabel.mas_centerY);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
        }];
    }
    return self;
}

- (void)setRightValue:(NSString *)rightValue {
    _rightValue = rightValue;
    self.rightLabel.text = rightValue;
}

- (void)setDefaultColor:(BOOL)DefaultColor {
    self.rightLabel.textColor = DefaultColor ? ZFCOLOR(51, 51, 51, 1.0) : ZFCOLOR(244, 67, 69, 1.0);
}

@end
