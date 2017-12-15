

//
//  ZFPayMethodsTipsView.m
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPayMethodsTipsView.h"
#import "ZFInitViewProtocol.h"

@interface ZFPayMethodsTipsView() <ZFInitViewProtocol>
@property (nonatomic, strong) UILabel           *tipsLabel;
@property (nonatomic, strong) UIView            *bottomSepareView;
@end

@implementation ZFPayMethodsTipsView
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
    self.backgroundColor = ZFCOLOR_WHITE;
    [self addSubview:self.tipsLabel];
    [self addSubview:self.bottomSepareView];
}

- (void)zfAutoLayoutView {
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(14);
        make.trailing.mas_equalTo(-14);
    }];
    
    [self.bottomSepareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(12);
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(12);
    }];
}

#pragma mark - getter
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.font = [UIFont systemFontOfSize:11];
        _tipsLabel.textColor = ZFCOLOR_BLACK;
        _tipsLabel.textAlignment = [SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentRight  : NSTextAlignmentLeft;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.text = ZFLocalizedString(@"ZFPaymentTips", nil);
    }
    return _tipsLabel;
}

- (UIView *)bottomSepareView {
    if (!_bottomSepareView) {
        _bottomSepareView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomSepareView.backgroundColor = ZFCOLOR(226, 226, 226, 1.f);
    }
    return _bottomSepareView;
}
@end
