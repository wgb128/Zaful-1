//
//  ZFCartUnavailableViewAllView.m
//  Zaful
//
//  Created by liuxi on 2017/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartUnavailableViewAllView.h"
#import "ZFInitViewProtocol.h"
#import "UIView+GBGesture.h"

@interface ZFCartUnavailableViewAllView () <ZFInitViewProtocol>
@property (nonatomic, strong) UIView            *containView;
@property (nonatomic, strong) UILabel           *tipsLabel;
@property (nonatomic, strong) UIImageView       *arrowImageView;
@property (nonatomic, strong) UIView            *bottomLineView;
@end

@implementation ZFCartUnavailableViewAllView
#pragma mark - init methods
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        @weakify(self);
        [self addTapGestureWithComplete:^(UIView * _Nonnull view) {
            @strongify(self);
            if (self.cartUnavailableViewAllSelectCompletionHandler) {
                self.cartUnavailableViewAllSelectCompletionHandler(!self.isShowMore);
            }
        }];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.containView];
    [self.containView addSubview:self.tipsLabel];
    [self.containView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.bottomLineView];
    
}

- (void)zfAutoLayoutView {
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(40);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.containView);
        make.centerY.mas_equalTo(self.containView);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.tipsLabel.mas_trailing).offset(8);
        make.trailing.mas_equalTo(self.containView);
        make.centerY.mas_equalTo(self.containView);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(12);
    }];
}

#pragma mark - setter
- (void)setIsShowMore:(BOOL)isShowMore {
    _isShowMore = isShowMore;
    
    self.tipsLabel.text = ZFLocalizedString(_isShowMore ? @"CartUnavailableFoldUpTips" : @"CartUnavailableViewMoreTips", nil) ;
    self.arrowImageView.image = [UIImage imageNamed: _isShowMore ? @"cart_unavailable_arrow_up" : @"cart_unavailable_arrow_down"];
}

#pragma mark - getter
- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] initWithFrame:CGRectZero];
        _containView.backgroundColor = ZFCOLOR_WHITE;
    }
    return _containView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        _tipsLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _tipsLabel.text = @"View More";
    }
    return _tipsLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowImageView.image = [UIImage imageNamed:@"cart_unavailable_arrow_down"];
    }
    return _arrowImageView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = ZFCOLOR(247, 247, 247, 1.f);
    }
    return _bottomLineView;
}

@end
