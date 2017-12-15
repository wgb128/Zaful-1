


//
//  ZFCartCountOptionView.m
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartCountOptionView.h"
#import "ZFInitViewProtocol.h"

@interface ZFCartCountOptionView () <ZFInitViewProtocol, UITextFieldDelegate>

@property (nonatomic, strong) UIButton          *increaseButton;
@property (nonatomic, strong) UITextField       *countTextField;
@property (nonatomic, strong) UIButton          *decreaseButton;

@end

@implementation ZFCartCountOptionView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - action methods
- (void)decreaseButtonActoin:(UIButton *)sender {
    [sender.layer addAnimation:[self createOptionAnimation] forKey:@""];
    if (self.cartGoodsCountChangeCompletionHandler) {
        self.cartGoodsCountChangeCompletionHandler(self.goodsNumber - 1);
    }
}

- (void)increaseButtonAction:(UIButton *)sender {
    [sender.layer addAnimation:[self createOptionAnimation] forKey:@""];
    if (self.cartGoodsCountChangeCompletionHandler) {
        self.cartGoodsCountChangeCompletionHandler(self.goodsNumber + 1);
    }
}


#pragma mark - private methods
- (CAKeyframeAnimation *)createOptionAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.1), @(1.0), @(1.5)];
    animation.keyTimes = @[@(0.0), @(0.5), @(0.8), @(1.0)];
    animation.calculationMode = kCAAnimationLinear;
    return animation;
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""]) return YES;
    
    if (textField.text.length > 2){
        return NO;
    }else{
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([textField.text integerValue] > self.maxGoodsNumber) {
        self.goodsNumber = self.maxGoodsNumber;
    } else if ([textField.text integerValue] <= 0) {
        self.goodsNumber = 1;
    } else {
        self.goodsNumber = [textField.text integerValue];
    }
    if (self.cartGoodsCountChangeCompletionHandler) {
        self.cartGoodsCountChangeCompletionHandler(self.goodsNumber);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
    self.layer.borderColor = ZFCOLOR(241, 241, 241, 1.0).CGColor;
    self.layer.borderWidth = MIN_PIXEL * 2;
    [self addSubview:self.decreaseButton];
    [self addSubview:self.countTextField];
    [self addSubview:self.increaseButton];
}

- (void)zfAutoLayoutView {
    [self.decreaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self);
        make.width.mas_equalTo(@35);
    }];
    
    [self.countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.leading.mas_equalTo(self.decreaseButton.mas_trailing).offset(2);
        make.width.mas_equalTo(@40);
    }];
    
    [self.increaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.mas_equalTo(self);
        make.width.mas_equalTo(@(35));
    }];
}

#pragma mark - setter
- (void)setGoodsNumber:(NSInteger)goodsNumber {
    _goodsNumber = goodsNumber;
    self.countTextField.text = [NSString stringWithFormat:@"%lu", _goodsNumber];
    self.increaseButton.enabled = _goodsNumber < self.maxGoodsNumber;
    self.decreaseButton.enabled = _goodsNumber > 1;
}

- (void)setMaxGoodsNumber:(NSInteger)maxGoodsNumber {
    _maxGoodsNumber = maxGoodsNumber;
}

#pragma mark - getter
- (UIButton *)increaseButton {
    if (!_increaseButton) {
        _increaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _increaseButton.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
        [_increaseButton addTarget:self action:@selector(increaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_increaseButton setImage:[UIImage imageNamed:@"plus_01"] forState:UIControlStateNormal];
        [_increaseButton setImage:[UIImage imageNamed:@"plus_status_01"] forState:UIControlStateDisabled];
    }
    return _increaseButton;
}

- (UITextField *)countTextField {
    if (!_countTextField) {
        _countTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _countTextField.keyboardType = UIKeyboardTypeNumberPad;
        _countTextField.returnKeyType = UIReturnKeyDone;
        _countTextField.layer.borderColor = ZFCOLOR(241, 241, 241, 1.0).CGColor;
        _countTextField.layer.borderWidth = MIN_PIXEL * 2;
        _countTextField.font = [UIFont systemFontOfSize:14.0];
        _countTextField.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _countTextField.textAlignment = NSTextAlignmentCenter;
        _countTextField.delegate = self;

    }
    return _countTextField;
}

- (UIButton *)decreaseButton {
    if (!_decreaseButton) {
        _decreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _decreaseButton.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
        [_decreaseButton addTarget:self action:@selector(decreaseButtonActoin:) forControlEvents:UIControlEventTouchUpInside];
        [_decreaseButton setImage:[UIImage imageNamed:@"minus_status_01"] forState:UIControlStateNormal];
        [_decreaseButton setImage:[UIImage imageNamed:@"minus_01"] forState:UIControlStateDisabled];
    }
    return _decreaseButton;
}
@end
