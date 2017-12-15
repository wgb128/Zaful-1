//
//  ZFNoNetEmptyView.m
//  Zaful
//
//  Created by liuxi on 2017/9/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFNoNetEmptyView.h"
#import "ZFInitViewProtocol.h"

@interface ZFNoNetEmptyView() <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView           *iconImageView;
@property (nonatomic, strong) UILabel               *noNetTipsLabel;
@property (nonatomic, strong) UIButton              *reloadButton;
@end;

@implementation ZFNoNetEmptyView
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
- (void)reloadButtonAction:(UIButton *)sender {
    if (self.noNetEmptyReRequestCompletionHandler) {
        self.noNetEmptyReRequestCompletionHandler();
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
    [self addSubview:self.iconImageView];
    [self addSubview:self.noNetTipsLabel];
    [self addSubview:self.reloadButton];
}

- (void)zfAutoLayoutView {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(90);
        
    }];
    
    [self.noNetTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
        make.leading.trailing.mas_equalTo(self);
    }];
    
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.noNetTipsLabel.mas_bottom).offset(14);
        make.height.mas_equalTo(45);
   
    }];
    
    self.reloadButton.layer.cornerRadius = 4;
}

#pragma mark - getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network_404"]];
    }
    return _iconImageView;
}

- (UILabel *)noNetTipsLabel {
    if (!_noNetTipsLabel) {
        _noNetTipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _noNetTipsLabel.font = [UIFont systemFontOfSize:14];
        _noNetTipsLabel.textColor = ZFCOLOR(153, 153, 153, 1.0f);
        _noNetTipsLabel.textAlignment = NSTextAlignmentCenter;
        _noNetTipsLabel.numberOfLines = 2;
        _noNetTipsLabel.text = ZFLocalizedString(@"Global_NO_NET_404", nil);
    }
    return _noNetTipsLabel;
}

- (UIButton *)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.backgroundColor = ZFCOLOR_BLACK;
        [_reloadButton setTitle:ZFLocalizedString(@"Base_VC_ShowAgain_TitleLabel", nil) forState:UIControlStateNormal];
        [_reloadButton setTitleColor:ZFCOLOR_WHITE forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(reloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _reloadButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _reloadButton.contentEdgeInsets = UIEdgeInsetsMake(14, 30, 14, 30);
    }
    return _reloadButton;
}
@end
