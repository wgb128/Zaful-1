


//
//  ZFCartDiscountTipsView.m
//  Zaful
//
//  Created by liuxi on 2017/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartDiscountTipsView.h"
#import "ZFInitViewProtocol.h"

@interface ZFCartDiscountTipsView () <ZFInitViewProtocol>
@property (nonatomic, strong) UILabel           *tipsLabel;
@end

@implementation ZFCartDiscountTipsView
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
    [self addSubview:self.tipsLabel];
}

- (void)zfAutoLayoutView {
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - setter
- (void)setDiscountTips:(NSString *)discountTips {
    _discountTips = discountTips;
    self.tipsLabel.text = [NSString stringWithFormat:@"%@ %@", ZFLocalizedString(@"CartHeaderView_FREELABELTEXT",nil),  _discountTips];
}

#pragma mark - getter
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        _tipsLabel.textColor = ZFCOLOR(183, 96, 42, 1.f);
    }
    return _tipsLabel;
}

@end
