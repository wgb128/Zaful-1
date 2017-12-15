
//
//  ZFCartUnavailableClearAllTipsView.m
//  Zaful
//
//  Created by liuxi on 2017/9/21.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartUnavailableClearAllTipsView.h"
#import "ZFInitViewProtocol.h"

@interface ZFCartUnavailableClearAllTipsView () <ZFInitViewProtocol>
@property (nonatomic, strong) UIView        *containView;
@property (nonatomic, strong) UILabel       *tipsLabel;
@property (nonatomic, strong) UIButton      *cancelButton;
@property (nonatomic, strong) UIButton      *confirmButton;
@property (nonatomic, strong) UIView        *lineView;
@property (nonatomic, strong) UIView        *buttonLineView;
@end

@implementation ZFCartUnavailableClearAllTipsView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - private methods
- (void)tipsShowAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.8), @(1.2), @(1.0)];
    animation.keyTimes = @[@(0.0), @(0.5), @(0.8), @(1.0)];
    animation.calculationMode = kCAAnimationLinear;
    [self.containView.layer addAnimation:animation forKey:@"showAnimation"];
}

#pragma mark - action methods
- (void)cancelButtonAction:(UIButton *)sender {
    if (self.cartUnavailableClearAllConfirmCompletionHandler) {
        self.cartUnavailableClearAllConfirmCompletionHandler(NO);
    }
}

- (void)confirmButtonAction:(UIButton *)sender {
    if (self.cartUnavailableClearAllConfirmCompletionHandler) {
        self.cartUnavailableClearAllConfirmCompletionHandler(YES);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self addSubview:self.containView];
    [self.containView addSubview:self.tipsLabel];
    [self.containView addSubview:self.cancelButton];
    [self.containView addSubview:self.buttonLineView];
    [self.containView addSubview:self.confirmButton];
    [self.containView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(280, 160));
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.containView.mas_leading).offset(24);
        make.trailing.mas_equalTo(self.containView.mas_trailing).offset(-24);
        make.top.mas_equalTo(self.containView);
        make.height.mas_equalTo(112);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.containView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(-0.5);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.mas_equalTo(self.containView);
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.width.mas_equalTo(139.75);
    }];
    
    [self.buttonLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.bottom.mas_equalTo(self.containView);
        make.leading.mas_equalTo(self.cancelButton.mas_trailing);
        make.width.mas_equalTo(0.5);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.mas_equalTo(self.containView);
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.width.mas_equalTo(139.75);
    }];
}

#pragma mark - getter
- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] initWithFrame:CGRectZero];
        _containView.backgroundColor = ZFCOLOR_WHITE;
        _containView.layer.cornerRadius = 12;
    }
    return _containView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:16];
        _tipsLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.text = ZFLocalizedString(@"CartUnavailableClearAllTips", nil);
    }
    return _tipsLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.clipsToBounds = YES;
        [_cancelButton setTitle:ZFLocalizedString(@"CartRemoveProductNo", nil) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:ZFCOLOR(255, 168, 0, 1.f) forState:UIControlStateNormal];
        _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.clipsToBounds = YES;
        [_confirmButton setTitle:ZFLocalizedString(@"CartRemoveProductYes", nil) forState:UIControlStateNormal];
        [_confirmButton setTitleColor:ZFCOLOR(51, 51, 51, 1.f) forState:UIControlStateNormal];
        _confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _confirmButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}

- (UIView *)buttonLineView {
    if (!_buttonLineView) {
        _buttonLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _buttonLineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _buttonLineView;
}
@end
