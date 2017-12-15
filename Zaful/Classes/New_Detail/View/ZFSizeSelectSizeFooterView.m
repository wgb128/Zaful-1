//
//  ZFSizeSelectSizeFooterView.m
//  Zaful
//
//  Created by liuxi on 2017/11/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFSizeSelectSizeFooterView.h"
#import "ZFInitViewProtocol.h"
#import "UILabel+HTML.h"

@interface ZFSizeSelectSizeFooterView() <ZFInitViewProtocol>
@property (nonatomic, strong) UILabel           *tipsLabel;
@end

@implementation ZFSizeSelectSizeFooterView
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
}

- (void)zfAutoLayoutView {
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
}

#pragma mark - setter
- (void)setTipsInfo:(NSString *)tipsInfo {
    _tipsInfo = tipsInfo;
    self.tipsLabel.text = _tipsInfo;
}

#pragma mark - getter
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.numberOfLines = 2;
    }
    return _tipsLabel;
}

@end
