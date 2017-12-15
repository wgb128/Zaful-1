
//
//  ZFGoodsDetailReviewsHeaderView.m
//  Zaful
//
//  Created by liuxi on 2017/11/21.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailReviewsHeaderView.h"
#import "ZFInitViewProtocol.h"
#import "ZFGoodsReviewStarsView.h"
#import "UIView+GBGesture.h"

@interface ZFGoodsDetailReviewsHeaderView() <ZFInitViewProtocol>

@property (nonatomic, strong) UILabel                   *titleLabel;
@property (nonatomic, strong) UILabel                   *pointsLabel;
@property (nonatomic, strong) ZFGoodsReviewStarsView    *starsView;
@property (nonatomic, strong) UIImageView               *arrowImageView;

@end

@implementation ZFGoodsDetailReviewsHeaderView
#pragma mark - init methods
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        @weakify(self);
        [self addTapGestureWithComplete:^(UIView * _Nonnull view) {
            @strongify(self);
            if ([_model.reViewCount integerValue] > 0) {

                if (self.goodsDetailReviewsViewMoreCompletionHandler) {
                    self.goodsDetailReviewsViewMoreCompletionHandler();
                }
            }
        }];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.pointsLabel];
    [self.contentView addSubview:self.starsView];
}

- (void)zfAutoLayoutView {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
    }];
    
    [self.pointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.arrowImageView.mas_leading).offset(-8);
        make.width.mas_equalTo(30);
    }];
    
    [self.starsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(95, 20));
        make.trailing.mas_equalTo(self.pointsLabel.mas_leading);
    }];
}

#pragma mark - setter
- (void)setModel:(GoodsDetailModel *)model {
    _model = model;
    
    if (![SystemConfigUtils isRightToLeftShow]) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)", ZFLocalizedString(@"Detail_Product_Reviews", nil), _model.reViewCount ?: @"0"];
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"(%@)%@", _model.reViewCount ?: @"0", ZFLocalizedString(@"Detail_Product_Reviews", nil)];
    }
    if ([_model.reViewCount integerValue] > 0) {

        self.pointsLabel.hidden = NO;
        self.starsView.hidden = NO;
        self.pointsLabel.text = [NSString stringWithFormat:@"%.1lf", [_model.rateAVG floatValue]];
        self.starsView.rateAVG = _model.rateAVG;
    } else {
        self.pointsLabel.hidden = YES;
        self.starsView.hidden = YES;
        self.arrowImageView.hidden = YES;
    }
    
}

- (void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    if (!_isOpen) {
        if ([SystemConfigUtils isRightToLeftShow]) {
            self.arrowImageView.image = [UIImage imageNamed:@"size_arrow_left"];
        } else {
            self.arrowImageView.image = [UIImage imageNamed:@"size_arrow_right"];
        }
    } else {
        self.arrowImageView.image = [UIImage imageNamed:@"size_arrow_down"];
    }
    
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        _titleLabel.text = [NSString stringWithFormat:@"%@(0)", ZFLocalizedString(@"Detail_Product_Reviews", nil)];
    }
    return _titleLabel;
}

- (UILabel *)pointsLabel {
    if (!_pointsLabel) {
        _pointsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _pointsLabel.textColor = ZFCOLOR(255, 168, 0, 1.f);
        _pointsLabel.font = [UIFont systemFontOfSize:14];
        _pointsLabel.textAlignment = NSTextAlignmentRight;
        _pointsLabel.hidden = YES;
    }
    return _pointsLabel;
}

- (ZFGoodsReviewStarsView *)starsView {
    if (!_starsView) {
        _starsView = [[ZFGoodsReviewStarsView alloc] initWithFrame:CGRectZero];
        _starsView.hidden = YES;
    }
    return _starsView;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        if ([SystemConfigUtils isRightToLeftShow]) {
            _arrowImageView.image = [UIImage imageNamed:@"size_arrow_left"];
        } else {
            _arrowImageView.image = [UIImage imageNamed:@"size_arrow_right"];
        }
    }
    return _arrowImageView;
}

@end
