//
//  OtherAlertView.m
//  Zaful
//
//  Created by DBP on 17/3/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "OtherAlertView.h"

@interface OtherAlertView ()
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *okBtn;
@end

@implementation OtherAlertView

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([UIApplication sharedApplication].keyWindow).with.insets(UIEdgeInsetsZero);
    }];
    
    CGFloat duration = 0.3;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.8), @(1), @(1.05), @(1)];
    animation.keyTimes = @[@(0), @(0.3), @(0.5), @(1.0)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:@"bouce"];
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma maek - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = ZFCOLOR(0,0,0,0.6);
        
        [self addSubview:self.backGroundView];
        [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading).offset(10);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-10);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [self.backGroundView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.backGroundView);
            make.top.mas_equalTo(self.backGroundView.mas_top).offset(30);
        }];

        [self.backGroundView addSubview:self.okBtn];
        [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
            make.leading.mas_equalTo(self.backGroundView.mas_leading).offset(12);
            make.trailing.mas_equalTo(self.backGroundView.mas_trailing).offset(-12);
            make.height.mas_equalTo(43);
            make.bottom.mas_equalTo(self.backGroundView.mas_bottom).offset(-18);;
            
        }];
    }
    return self;
}

#pragma mark - Click
- (void)okBtnClick {
    [self removeFromSuperview];
}

#pragma mark - lazy
- (UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] init];
        _backGroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backGroundView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _titleLabel.text = ZFLocalizedString(@"OrderInfoViewModel_alertMsg_COD", nil);
    }
    return _titleLabel;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBtn.backgroundColor = [UIColor blackColor];
        [_okBtn setTitle:ZFLocalizedString(@"OK", nil) forState:UIControlStateNormal];
        [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

@end
