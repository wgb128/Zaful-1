

//
//  ZFGoodsDetailInfoView.m
//  Zaful
//
//  Created by liuxi on 2017/11/21.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailInfoView.h"
#import "ZFInitViewProtocol.h"

@interface ZFGoodsDetailInfoView() <ZFInitViewProtocol>

@property (nonatomic, strong) UILabel               *shopPriceLabel;
@property (nonatomic, strong) UILabel               *marketPriceLabel;
@property (nonatomic, strong) UIView                *deleteLineView;
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UILabel               *appLabel;
@property (nonatomic, strong) UILabel               *codLabel;
@property (nonatomic, strong) UILabel               *offLabel;
@property (nonatomic, strong) UIView                *lineView;
@property (nonatomic, strong) BigClickAreaButton    *collectionButton;
@property (nonatomic, strong) UILabel               *goodNumberLabel;
@property (nonatomic, strong) UIView                *bottomLineView;

@property (nonatomic, strong) CABasicAnimation      *scaleAnimation;

@end

@implementation ZFGoodsDetailInfoView
#pragma mark - init methods
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - action methods
- (void)collectionButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.collectionButton.layer addAnimation:self.scaleAnimation forKey:@"scaleAnimation"];
    if (self.goodsDetailCollectionCompletionHandler) {
        self.goodsDetailCollectionCompletionHandler(sender.selected);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.shopPriceLabel];
    [self.contentView addSubview:self.marketPriceLabel];
    [self.contentView addSubview:self.deleteLineView];
    [self.contentView addSubview:self.codLabel];
    [self.contentView addSubview:self.appLabel];
//    [self.contentView addSubview:self.offLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.collectionButton];
    [self.contentView addSubview:self.goodNumberLabel];
    [self.contentView addSubview:self.bottomLineView];
    
}

- (void)zfAutoLayoutView {
    [self.shopPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.height.mas_equalTo(24);
    }];
    
    [self.marketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.shopPriceLabel);
        make.leading.mas_equalTo(self.shopPriceLabel.mas_trailing).offset(4);
        make.height.mas_equalTo(24);
    }];
    
    [self.deleteLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.marketPriceLabel);
        make.centerY.mas_equalTo(self.marketPriceLabel);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.codLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.top.mas_equalTo(self.self.shopPriceLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(28, 12));
    }];
    
    [self.appLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.codLabel.mas_trailing).offset(4);
        make.top.mas_equalTo(self.self.shopPriceLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(28, 12));
    }];
    
//    [self.offLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(self.appLabel.mas_trailing).offset(4);
//        make.top.mas_equalTo(self.self.shopPriceLabel.mas_bottom).offset(12);
//        make.size.mas_equalTo(CGSizeMake(28, 12));
//    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.top.mas_equalTo(self.codLabel.mas_bottom).offset(4);
        make.trailing.mas_equalTo(self.lineView.mas_leading).offset(-16);
    }];
    
    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-30);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.collectionButton.mas_leading).offset(-30);
        make.width.mas_equalTo(0.5);
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-16);
    }];
    
    [self.goodNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.collectionButton);
        make.top.mas_equalTo(self.collectionButton.mas_bottom);
        make.height.mas_equalTo(15);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(8);
    }];
}

#pragma mark - setter
- (void)setModel:(GoodsDetailModel *)model {
    _model = model;
    self.shopPriceLabel.text = [ExchangeManager transforPrice:_model.shop_price];
    self.marketPriceLabel.text = [ExchangeManager transforPrice:_model.market_price];
    self.titleLabel.text = _model.goods_name;
    self.collectionButton.selected = [_model.is_collect boolValue];
    self.goodNumberLabel.text = _model.like_count;
    if (_model.is_cod) {
        self.codLabel.hidden = NO;
    }
    
    if ([_model.is_mobile_price boolValue]) {
        self.appLabel.hidden = NO;
    }
    
    if (!_model.is_cod && [_model.is_mobile_price boolValue]) {
        [self.appLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
            make.top.mas_equalTo(self.self.shopPriceLabel.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(28, 12));
        }];
    }
    
//    if ([NSStringUtils isEmptyString:_model.promote_zhekou]) {
//        self.offLabel.hidden = NO;
//        self.offLabel.text = [NSString stringWithFormat:@"%@ OFF", _model.promote_zhekou];
//    } else {
//        self.offLabel.hidden = YES;
//    }
    
}

#pragma mark - getter
- (UILabel *)shopPriceLabel {
    if (!_shopPriceLabel) {
        _shopPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _shopPriceLabel.textColor = ZFCOLOR(183, 96, 42, 1.f);
        _shopPriceLabel.font = [UIFont systemFontOfSize:24];
        
    }
    return _shopPriceLabel;
}

- (UILabel *)marketPriceLabel {
    if (!_marketPriceLabel) {
        _marketPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _marketPriceLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _marketPriceLabel.font = [UIFont systemFontOfSize:16];
    }
    return _marketPriceLabel;
}

- (UIView *)deleteLineView {
    if (!_deleteLineView) {
        _deleteLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _deleteLineView.backgroundColor = ZFCOLOR(153, 153, 153, 1.f);
    }
    return _deleteLineView;
}

- (UILabel *)codLabel {
    if (!_codLabel) {
        _codLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _codLabel.textAlignment = NSTextAlignmentCenter;
        _codLabel.font = [UIFont systemFontOfSize:10];
        _codLabel.textColor = ZFCOLOR_WHITE;
        _codLabel.backgroundColor = ZFCOLOR(183, 96, 42, 1.f);
        _codLabel.text = @"COD";
        _codLabel.hidden = YES;
    }
    return _codLabel;
}

- (UILabel *)appLabel {
    if (!_appLabel) {
        _appLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _appLabel.textAlignment = NSTextAlignmentCenter;
        _appLabel.font = [UIFont systemFontOfSize:10];
        _appLabel.textColor = ZFCOLOR_WHITE;
        _appLabel.backgroundColor = ZFCOLOR(183, 96, 42, 1.f);
        _appLabel.text = @"APP";
        _appLabel.hidden = YES;
    }
    return _appLabel;
}

- (UILabel *)offLabel {
    if (!_offLabel) {
        _offLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _offLabel.textAlignment = NSTextAlignmentCenter;
        _offLabel.font = [UIFont systemFontOfSize:10];
        _offLabel.textColor = ZFCOLOR_WHITE;
        _offLabel.backgroundColor = ZFCOLOR(183, 96, 42, 1.f);
        _offLabel.hidden = YES;
    }
    return _offLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}

- (BigClickAreaButton *)collectionButton {
    if (!_collectionButton) {
        _collectionButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        [_collectionButton setImage:[UIImage imageNamed:@"GoodsDetail_Uncollect"] forState:UIControlStateNormal];
        [_collectionButton setImage:[UIImage imageNamed:@"GoodsDetail_collect"] forState:UIControlStateSelected];
        [_collectionButton addTarget:self action:@selector(collectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _collectionButton.clickAreaRadious = 64;
    }
    return _collectionButton;
}

- (UILabel *)goodNumberLabel {
    if (!_goodNumberLabel) {
        _goodNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodNumberLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _goodNumberLabel.font = [UIFont systemFontOfSize:10];
        _goodNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _goodNumberLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = ZFCOLOR(247, 247, 247, 1.f);
    }
    return _bottomLineView;
}

- (CABasicAnimation *)scaleAnimation {
    if (!_scaleAnimation) {
        _scaleAnimation = [CABasicAnimation animation];
        _scaleAnimation.keyPath = @"transform.scale";
        _scaleAnimation.fromValue = @(0.6);
        _scaleAnimation.toValue = @(1.2);
        _scaleAnimation.duration = 0.35;
    }
    return _scaleAnimation;
}
@end
