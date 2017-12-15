//
//  ZFSizeSelectNormalHeaderView.m
//  Zaful
//
//  Created by liuxi on 2017/11/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFSizeSelectNormalHeaderView.h"
#import "ZFInitViewProtocol.h"

@interface ZFSizeSelectNormalHeaderView() <ZFInitViewProtocol>
@property (nonatomic, strong) UILabel           *titleLabel;
@end

@implementation ZFSizeSelectNormalHeaderView
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
    [self addSubview:self.titleLabel];
}

- (void)zfAutoLayoutView {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self.mas_leading).offset(16);
        make.trailing.mas_equalTo(self);
    }];
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        
    }
    return _titleLabel;
}

@end
