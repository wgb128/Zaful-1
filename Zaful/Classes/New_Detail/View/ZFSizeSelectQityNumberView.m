//
//  ZFSizeSelectQityNumberView.m
//  Zaful
//
//  Created by liuxi on 2017/11/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFSizeSelectQityNumberView.h"
#import "ZFInitViewProtocol.h"

@interface ZFSizeSelectQityNumberView() <ZFInitViewProtocol>

@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UIButton          *mulitButton;
@property (nonatomic, strong) UILabel           *numberLabel;
@property (nonatomic, strong) UIButton          *plusButton;

@end

@implementation ZFSizeSelectQityNumberView
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
- (void)mulitButtonAction:(UIButton *)sender {
    if (self.number <= 1) {
        return ;
    }
    self.number = self.number - 1;
    if (self.sizeSelectQityNumberChangeCompletionHandler) {
        self.sizeSelectQityNumberChangeCompletionHandler(self.number);
    }
}

- (void)plusButtonAction:(UIButton *)sender {
    if (self.number + 1 > self.goodsNumber) {
        return ;
    }
    self.number = self.number + 1;
    if (self.sizeSelectQityNumberChangeCompletionHandler) {
        self.sizeSelectQityNumberChangeCompletionHandler(self.number);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
    [self addSubview:self.titleLabel];
    [self addSubview:self.mulitButton];
    [self addSubview:self.numberLabel];
    [self addSubview:self.plusButton];
}

- (void)zfAutoLayoutView {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(16);
        make.centerY.mas_equalTo(self.mas_top).offset(24);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.height.mas_equalTo(48);
    }];
    
    [self.mulitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    self.mulitButton.layer.cornerRadius = 22;
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mulitButton.mas_trailing);
        make.centerY.mas_equalTo(self.mulitButton);
        make.size.mas_equalTo(CGSizeMake(70, 44));
    }];
    
    [self.plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.numberLabel.mas_trailing);
        make.centerY.mas_equalTo(self.mulitButton);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    self.plusButton.layer.cornerRadius = 22;
}

#pragma mark - setter
- (void)setNumber:(NSInteger)number {
    _number = number;
    self.numberLabel.text = [NSString stringWithFormat:@"%lu", _number];
    if (_number <= 1) {
        self.mulitButton.layer.borderColor = ZFCOLOR(247, 247, 247, 1.f).CGColor;
        [self.mulitButton setTitleColor:ZFCOLOR(221, 221, 221, 1.f) forState:UIControlStateNormal];
    } else {
        self.mulitButton.layer.borderColor = ZFCOLOR(221, 221, 221, 1.f).CGColor;
        [self.mulitButton setTitleColor:ZFCOLOR(51, 51, 51, 1.f) forState:UIControlStateNormal];
    }
    
    if (_number >= self.goodsNumber) {
        self.plusButton.layer.borderColor = ZFCOLOR(247, 247, 247, 1.f).CGColor;
        [self.plusButton setTitleColor:ZFCOLOR(221, 221, 221, 1.f) forState:UIControlStateNormal];
    } else {
        self.plusButton.layer.borderColor = ZFCOLOR(221, 221, 221, 1.f).CGColor;
        [self.plusButton setTitleColor:ZFCOLOR(51, 51, 51, 1.f) forState:UIControlStateNormal];
    }
}

- (void)setGoodsNumber:(NSInteger)goodsNumber {
    _goodsNumber = goodsNumber;
    
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = ZFLocalizedString(@"Qity", nil);
    }
    return _titleLabel;
}

- (UIButton *)mulitButton {
    if (!_mulitButton) {
        _mulitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mulitButton.layer.borderWidth = 1;
        _mulitButton.layer.borderColor = ZFCOLOR(221, 221, 221, 1.f).CGColor;
        [_mulitButton setTitle:@"-" forState:UIControlStateNormal];
        [_mulitButton setTitleColor:ZFCOLOR(51, 51, 51, 1.f) forState:UIControlStateNormal];
        _mulitButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [_mulitButton addTarget:self action:@selector(mulitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mulitButton;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _numberLabel.font = [UIFont systemFontOfSize:19];
        _numberLabel.text = @"1";
    }
    return _numberLabel;
}

- (UIButton *)plusButton {
    if (!_plusButton) {
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _plusButton.layer.borderWidth = 1;
        _plusButton.layer.borderColor = ZFCOLOR(221, 221, 221, 1.f).CGColor;
        [_plusButton setTitle:@"+" forState:UIControlStateNormal];
        [_plusButton setTitleColor:ZFCOLOR(51, 51, 51, 1.f) forState:UIControlStateNormal];
        _plusButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [_plusButton addTarget:self action:@selector(plusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusButton;
}

@end
