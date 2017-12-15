

//
//  ZFCartNoDataEmptyView.m
//  Zaful
//
//  Created by liuxi on 2017/9/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartNoDataEmptyView.h"
#import "ZFInitViewProtocol.h"

@interface ZFCartNoDataEmptyView () <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView           *iconImageView;
@property (nonatomic, strong) UILabel               *emptyTipsLabel;
@property (nonatomic, strong) UIButton              *continueShopButton;

@end

@implementation ZFCartNoDataEmptyView
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
- (void)continueShopButtonAction:(UIButton *)sender {
    if (self.cartNoDataContinueShopCompletionHandler) {
        self.cartNoDataContinueShopCompletionHandler();
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR(245, 245, 245, 1.f);
    [self addSubview:self.iconImageView];
    [self addSubview:self.emptyTipsLabel];
    [self addSubview:self.continueShopButton];
}

- (void)zfAutoLayoutView {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(56);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(72, 82));
    }];
    
    [self.emptyTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(12);
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
    [self.continueShopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emptyTipsLabel.mas_bottom).offset(28);
        make.size.mas_equalTo(CGSizeMake(224, 44));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

#pragma mark - getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_blank"]];
    }
    return _iconImageView;
}

- (UILabel *)emptyTipsLabel {
    if (!_emptyTipsLabel) {
        _emptyTipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _emptyTipsLabel.font = [UIFont systemFontOfSize:14];
        _emptyTipsLabel.textAlignment = NSTextAlignmentCenter;
        _emptyTipsLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _emptyTipsLabel.text = ZFLocalizedString(@"CartViewModel_NoData_TitleLabel", nil);
    }
    return _emptyTipsLabel;
}

- (UIButton *)continueShopButton {
    if (!_continueShopButton) {
        _continueShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueShopButton setTitle:ZFLocalizedString(@"CartViewModel_NoData_TitleButton", nil) forState:UIControlStateNormal];
        [_continueShopButton setTitleColor:ZFCOLOR_WHITE forState:UIControlStateNormal];
        _continueShopButton.backgroundColor = ZFCOLOR_BLACK;
        _continueShopButton.layer.cornerRadius = 4;
        [_continueShopButton addTarget:self action:@selector(continueShopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _continueShopButton;
}
@end
