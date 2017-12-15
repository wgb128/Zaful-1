
//
//  ZFReviewsDetailStarsView.m
//  Zaful
//
//  Created by liuxi on 2017/11/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFReviewsDetailStarsView.h"
#import "ZFInitViewProtocol.h"

@interface ZFReviewsDetailStarsView() <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView           *starViewFirst;
@property (nonatomic, strong) UIImageView           *starViewSecond;
@property (nonatomic, strong) UIImageView           *starViewThird;
@property (nonatomic, strong) UIImageView           *starViewFourth;
@property (nonatomic, strong) UIImageView           *starViewFiveth;
@end

@implementation ZFReviewsDetailStarsView
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
    self.backgroundColor = ZFCOLOR(247, 247, 247, 1.f);
    [self addSubview:self.starViewFirst];
    [self addSubview:self.starViewSecond];
    [self addSubview:self.starViewThird];
    [self addSubview:self.starViewFourth];
    [self addSubview:self.starViewFiveth];
}

- (void)zfAutoLayoutView {
    [self.starViewFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.leading.mas_equalTo(self.mas_leading);
    }];
    
    [self.starViewSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.leading.mas_equalTo(self.starViewFirst.mas_trailing).offset(5);
    }];
    
    [self.starViewThird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.leading.mas_equalTo(self.starViewSecond.mas_trailing).offset(5);
    }];
    
    [self.starViewFourth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.leading.mas_equalTo(self.starViewThird.mas_trailing).offset(5);
    }];
    
    [self.starViewFiveth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.leading.mas_equalTo(self.starViewFourth.mas_trailing).offset(5);
    }];
    
}

#pragma mark - setter
- (void)setRateAVG:(NSString *)rateAVG {
    _rateAVG = rateAVG;
    NSInteger count = [_rateAVG integerValue];
    for (int i = 1000; i < 1000 + count; ++i) {
        UIImageView *starView = [self viewWithTag:i];
        starView.image = [UIImage imageNamed:@"starLightBig"];
    }
}

#pragma mark - getter
- (UIImageView *)starViewFirst {
    if (!_starViewFirst) {
        _starViewFirst = [[UIImageView alloc] initWithFrame:CGRectZero];
        _starViewFirst.image = [UIImage imageNamed:@"starNormalBig"];
        _starViewFirst.tag = 1000;
    }
    return _starViewFirst;
}

- (UIImageView *)starViewSecond {
    if (!_starViewSecond) {
        _starViewSecond = [[UIImageView alloc] initWithFrame:CGRectZero];
        _starViewSecond.image = [UIImage imageNamed:@"starNormalBig"];
        _starViewSecond.tag = 1001;
    }
    return _starViewSecond;
}

- (UIImageView *)starViewThird {
    if (!_starViewThird) {
        _starViewThird = [[UIImageView alloc] initWithFrame:CGRectZero];
        _starViewThird.image = [UIImage imageNamed:@"starNormalBig"];
        _starViewThird.tag = 1002;
    }
    return _starViewThird;
}

- (UIImageView *)starViewFourth {
    if (!_starViewFourth) {
        _starViewFourth = [[UIImageView alloc] initWithFrame:CGRectZero];
        _starViewFourth.image = [UIImage imageNamed:@"starNormalBig"];
        _starViewFourth.tag = 1003;
    }
    return _starViewFourth;
}

- (UIImageView *)starViewFiveth {
    if (!_starViewFiveth) {
        _starViewFiveth = [[UIImageView alloc] initWithFrame:CGRectZero];
        _starViewFiveth.image = [UIImage imageNamed:@"starNormalBig"];
        _starViewFiveth.tag = 1004;
    }
    return _starViewFiveth;
}

@end
