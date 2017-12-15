
//
//  ZFPayMethodsCombinedHeaderView.m
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPayMethodsCombinedHeaderView.h"
#import "ZFInitViewProtocol.h"

@interface ZFPayMethodsCombinedHeaderView() <ZFInitViewProtocol>
@property (nonatomic, strong) UIButton          *selectButton;
@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UILabel           *tipsLabel;
@property (nonatomic, strong) UIView            *lineView;

@end

@implementation ZFPayMethodsCombinedHeaderView
#pragma mark - init methods
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - action methods
- (void)tapAction {
    if (self.payMethodsCombinedSelectCompletionHandler) {
        self.payMethodsCombinedSelectCompletionHandler();
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tipsLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.top.mas_equalTo(self.contentView.mas_top).offset(13);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(13);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.selectButton);
        make.leading.mas_equalTo(self.selectButton.mas_trailing).offset(13);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-13);
        make.height.mas_equalTo(28);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.leading.trailing.equalTo(self.titleLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(12);
        make.leading.mas_equalTo(self.titleLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0.5);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark - setter
- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    self.selectButton.selected = _isSelect;
}

#pragma mark - getter
- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.userInteractionEnabled = NO;
        [_selectButton setImage:[UIImage imageNamed:@"order_unchoose"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"order_choose"] forState:UIControlStateSelected];
    }
    return _selectButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = ZFLocalizedString(@"ZFPaymentCombine", nil);
        _titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.text = ZFLocalizedString(@"ZFPaymentCombineTip", nil);
        _tipsLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(244, 244, 244, 1.f);
    }
    return _lineView;
}

@end
