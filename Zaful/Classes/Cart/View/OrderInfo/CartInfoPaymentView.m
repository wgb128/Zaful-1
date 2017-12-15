//
//  CartInfoPaymentView.m
//  OrderInfoTest
//
//  Created by zhaowei on 2017/3/1.
//  Copyright © 2017年 share. All rights reserved.
//

#import "CartInfoPaymentView.h"

@interface CartInfoPaymentView ()
@property (nonatomic, strong) RadioButton *radioButton;
@property (nonatomic, strong) YYAnimatedImageView *payImageView;
@property (nonatomic, strong) UILabel *introLabel;
@end

@implementation CartInfoPaymentView

-(void)setModel:(PaymentListModel *)model {
    _model = model;
    self.introLabel.text = model.pay_shuoming;
    [self.radioButton setChecked:[model.default_select boolValue]];
    self.payImageView.image = [UIImage imageNamed:model.pay_code];
}

- (instancetype)initWithFrame:(CGRect)frame index:(NSUInteger)index {
    if (self = [super initWithFrame:frame]) {
        
        self.radioButton = [[RadioButton alloc] initWithGroupId:@"payment" index:index normalImage:[UIImage imageNamed:@"order_unchoose"] selectedImage:[UIImage imageNamed:@"order_choose"]];
        self.radioButton.clickAreaRadious = 40;
        [self addSubview:self.radioButton];
        [self.radioButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading).offset(13);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.height.mas_equalTo(@(20));
        }];
        
        self.payImageView = [YYAnimatedImageView new];

        [self addSubview:self.payImageView];
        [self.payImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.leading.equalTo(self.radioButton.mas_trailing).offset(13);
        }];
        
        self.introLabel = [[UILabel alloc] init];
        self.introLabel.numberOfLines = 0;
        self.introLabel.font = [UIFont systemFontOfSize:14];
        self.introLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        
        [self addSubview:self.introLabel];
        [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.payImageView.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-10);
            make.top.equalTo(self.payImageView.mas_bottom).offset(8);
            make.bottom.mas_equalTo(self).offset(-10);
        }];
        
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceEvent:)]];
    }
    return self;
}

-(void)choiceEvent:(UITapGestureRecognizer *)gestureRecognizer{
    [self.radioButton handleButtonTap:nil];
}

@end
