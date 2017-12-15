
//
//  ZFGoodsDetailQualifiedView.m
//  Zaful
//
//  Created by liuxi on 2017/11/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailQualifiedView.h"
#import "ZFInitViewProtocol.h"
#import "UIView+GBGesture.h"
#import "UILabel+HTML.h"

@interface ZFGoodsDetailQualifiedView() <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView           *iconImageView;
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UIImageView           *arrowImageView;
@property (nonatomic, strong) UIView                *lineView;
@end

@implementation ZFGoodsDetailQualifiedView
#pragma mark - init methods
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        @weakify(self);
        [self addTapGestureWithComplete:^(UIView * _Nonnull view) {
            @strongify(self);
            if (![NSStringUtils isEmptyString:self.model.reductionModel.url]) {
                if (self.goodsDetailQualifiedCompletionHandler) {
                    self.goodsDetailQualifiedCompletionHandler(self.model.reductionModel.url);
                }
            }
        }];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.iconImageView.mas_trailing).offset(10);
//        make.trailing.mas_equalTo(self.arrowImageView.mas_leading).offset(25);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        make.size.mas_equalTo(CGSizeMake(7, 13));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconImageView);
        make.bottom.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - setter
- (void)setModel:(GoodsDetailModel *)model {
    _model = model;
    GoodsReductionModel *reductionModel = _model.reductionModel;

    [self.titleLabel zf_setHTMLFromString:reductionModel.msg];
    
    if ([NSStringUtils isEmptyString:_model.reductionModel.url]) {
        self.arrowImageView.hidden = YES;
    } else {
        self.arrowImageView.hidden = NO;
    }
}

#pragma mark - getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.image = [UIImage imageNamed:@"topic"];
        _iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        if ([SystemConfigUtils isRightToLeftShow]) {
            _arrowImageView.image = [UIImage imageNamed:@"size_arrow_left"];
        } else {
            _arrowImageView.image = [UIImage imageNamed:@"size_arrow_right"];
        }
        _arrowImageView.userInteractionEnabled = YES;
    }
    return _arrowImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}

@end
