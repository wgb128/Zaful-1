//
//  ZFGoodsDetailNavigationView.m
//  Zaful
//
//  Created by liuxi on 2017/11/23.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailNavigationView.h"
#import "ZFInitViewProtocol.h"


@interface ZFGoodsDetailNavigationView() <ZFInitViewProtocol>

@property (nonatomic, strong) BigClickAreaButton      *backButton;
@property (nonatomic, strong) UIImageView             *goodsImageView;
@property (nonatomic, strong) BigClickAreaButton      *shareButton;
@property (nonatomic, strong) UIView                  *lineView;
@end

@implementation ZFGoodsDetailNavigationView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.backButton];
    [self addSubview:self.goodsImageView];
    [self addSubview:self.shareButton];
    [self addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(12);
        make.top.mas_equalTo(self.mas_top).offset(24);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    self.backButton.layer.cornerRadius = 18;

    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(29);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];

    self.goodsImageView.layer.cornerRadius = 15;
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
        make.centerY.mas_equalTo(self.backButton);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    self.shareButton.layer.cornerRadius = 18;
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - setter
- (void)setAlpha:(CGFloat)alpha {
    _alpha = alpha;
    //更新导航栏背景透明度， 移动图片位置
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:_alpha];
    self.goodsImageView.alpha = _alpha;
    self.lineView.alpha = _alpha < .85 ? 0 : _alpha;
    self.shareButton.backgroundColor = [UIColor colorWithWhite:1 alpha:(0.7-_alpha) < 0 ? 0 : 0.7 - alpha];
    self.backButton.backgroundColor = [UIColor colorWithWhite:1 alpha:(0.7-_alpha) < 0 ? 0 : 0.7 - alpha];
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.goodsImageView yy_setImageWithURL:[NSURL URLWithString:_imageUrl]
                          processorKey:NSStringFromClass([self class])
                           placeholder:[UIImage imageNamed:@"loading_cat_list"]
                               options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                              progress:nil
                             transform:nil
                            completion:nil];
}

#pragma mark - getter
- (BigClickAreaButton *)backButton {
    if (!_backButton) {
        _backButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        if ([SystemConfigUtils isRightToLeftShow]) {
            [_backButton setImage:[UIImage imageNamed:@"detail_back_right"] forState:UIControlStateNormal];
        } else {
            [_backButton setImage:[UIImage imageNamed:@"detail_back_left"] forState:UIControlStateNormal];
        }
        _backButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        _backButton.clipsToBounds = YES;
        _backButton.clickAreaRadious = 64;
    }
    return _backButton;
}

- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsImageView.alpha = 0;
        _goodsImageView.clipsToBounds = YES;
    }
    return _goodsImageView;
}

- (BigClickAreaButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"share-icon"] forState:UIControlStateNormal];
        _shareButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        _shareButton.clipsToBounds = YES;
        _shareButton.clickAreaRadious = 64;
    }
    return _shareButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
        _lineView.alpha = 0;
    }
    return _lineView;
}

@end
