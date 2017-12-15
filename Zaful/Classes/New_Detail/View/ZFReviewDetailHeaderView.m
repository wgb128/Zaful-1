

//
//  ZFReviewDetailHeaderView.m
//  Zaful
//
//  Created by liuxi on 2017/11/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFReviewDetailHeaderView.h"
#import "ZFInitViewProtocol.h"
#import "ZFReviewsDetailStarsView.h"

@interface ZFReviewDetailHeaderView() <ZFInitViewProtocol>
@property (nonatomic, strong) UIView                        *lineView;
@property (nonatomic, strong) UILabel                       *pointsLabel;
@property (nonatomic, strong) ZFReviewsDetailStarsView      *starsView;
@property (nonatomic, strong) UILabel                       *reviewsLabel;
@end

@implementation ZFReviewDetailHeaderView
#pragma mark - init methods
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR(247, 247, 247, 1.f);
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.pointsLabel];
    [self.contentView addSubview:self.starsView];
    [self.contentView addSubview:self.reviewsLabel];
}

- (void)zfAutoLayoutView {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.pointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.starsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.pointsLabel.mas_trailing).offset(16);
        make.top.mas_equalTo(self.pointsLabel.mas_top).offset(4);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(120);
    }];
    
    [self.reviewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.leading.mas_equalTo(self.pointsLabel.mas_trailing).offset(16);
        make.bottom.mas_equalTo(self.pointsLabel);
    }];
}

#pragma mark - setter
- (void)setPoints:(NSString *)points {
    _points = points;
    self.starsView.rateAVG = _points;
    self.pointsLabel.text = [NSString stringWithFormat:@"%.1lf", [_points floatValue]];
}

- (void)setReviewsCount:(NSInteger)reviewsCount {
    _reviewsCount = reviewsCount;
    self.reviewsLabel.text = [NSString stringWithFormat:@"%lu %@", _reviewsCount, ZFLocalizedString(@"GoodsReviews_HeaderView_Reviews", nil)];
}

#pragma mark - getter
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}

- (UILabel *)pointsLabel {
    if (!_pointsLabel) {
        _pointsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _pointsLabel.textColor = ZFCOLOR(255, 168, 0, 1.f);
        _pointsLabel.font = [UIFont boldSystemFontOfSize:64];
    }
    return _pointsLabel;
}

- (ZFReviewsDetailStarsView *)starsView {
    if (!_starsView) {
        _starsView = [[ZFReviewsDetailStarsView alloc] initWithFrame:CGRectZero];
    }
    return _starsView;
}

- (UILabel *)reviewsLabel {
    if (!_reviewsLabel) {
        _reviewsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _reviewsLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _reviewsLabel.font = [UIFont systemFontOfSize:18];
        _reviewsLabel.text = [NSString stringWithFormat:@"0 %@", ZFLocalizedString(@"GoodsReviews_HeaderView_Reviews", nil)];
    }
    return _reviewsLabel;
}

@end
