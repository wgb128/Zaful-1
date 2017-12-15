//
//  ZFCartDiscountGoodsHeaderView.m
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartDiscountGoodsHeaderView.h"
#import "ZFInitViewProtocol.h"
#import "UIView+GBGesture.h"
#import "ZFCartGoodsListModel.h"
#import "UILabel+HTML.h"

@interface ZFCartDiscountGoodsHeaderView () <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView           *iconImageView;
@property (nonatomic, strong) UILabel               *discountTipsLabel;
@property (nonatomic, strong) UIButton              *nextButton;
@property (nonatomic, strong) UIView                *lineView;
@end

@implementation ZFCartDiscountGoodsHeaderView
#pragma mark - init methods

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        @weakify(self);
        [self addTapGestureWithComplete:^(UIView * _Nonnull view) {
            @strongify(self);
            if (self.cartDiscountTopicJumpCompletionHandler && ![NSStringUtils isEmptyString:self.model.url]) {
                self.cartDiscountTopicJumpCompletionHandler();
            }
        }];
    }
    return self;
}

#pragma mark - action methods
- (void)nextButtonAction:(UIButton *)sender {
    if (self.cartDiscountTopicJumpCompletionHandler && ![NSStringUtils isEmptyString:self.model.url]) {
        self.cartDiscountTopicJumpCompletionHandler();
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.discountTipsLabel];
    [self.contentView addSubview:self.nextButton];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(13);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.discountTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconImageView.mas_trailing).offset(13);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.trailing.mas_equalTo(self.nextButton.mas_leading).offset(-20);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-18);
        make.size.mas_equalTo(CGSizeMake(7, 10));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
    }];
}

#pragma mark - setter
- (void)setModel:(ZFCartGoodsListModel *)model {
    _model = model;

    [self.discountTipsLabel zf_setHTMLFromString:_model.msg];
    self.discountTipsLabel.textAlignment = ![SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentLeft : NSTextAlignmentRight;
    self.nextButton.hidden = [NSStringUtils isEmptyString:self.model.url] ? YES : NO;
}

#pragma mark - getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"off_tag"]];
    }
    return _iconImageView;
}

- (UILabel *)discountTipsLabel {
    if (!_discountTipsLabel) {
        _discountTipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _discountTipsLabel.font = [UIFont systemFontOfSize:14];
        _discountTipsLabel.numberOfLines = 2;
        [_discountTipsLabel sizeToFit];
        _discountTipsLabel.textColor = ZFCOLOR_BLACK;
        _discountTipsLabel.textAlignment = ![SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentLeft : NSTextAlignmentRight;
    }
    return _discountTipsLabel;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setImage:[UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"next-left" : @"next-right"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}
@end
