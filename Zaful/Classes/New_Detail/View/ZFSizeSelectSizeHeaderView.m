
//
//  ZFSizeSelectSizeHeaderView.m
//  Zaful
//
//  Created by liuxi on 2017/11/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFSizeSelectSizeHeaderView.h"
#import "ZFInitViewProtocol.h"

@interface ZFSizeSelectSizeHeaderView() <ZFInitViewProtocol>
@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UIButton          *sizeGuideButton;
@property (nonatomic, strong) UIImageView       *arrowImageView;
@end

@implementation ZFSizeSelectSizeHeaderView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - action methods
- (void)sizeGuideButtonAction:(UIButton *)sender {
    if (self.sizeSelectGuideJumpCompletionHandler) {
        self.sizeSelectGuideJumpCompletionHandler();
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.sizeGuideButton];
}

- (void)zfAutoLayoutView {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self.mas_leading).offset(16);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-16);
    }];
    
    [self.sizeGuideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.trailing.mas_equalTo(self.arrowImageView.mas_leading).offset(-8);
    }];
}

#pragma mark - setter
- (void)setModel:(GoodsDetailModel *)model {
    _model = model;
    if ([NSStringUtils isEmptyString:_model.size_url]) {
        self.arrowImageView.hidden = YES;
        self.sizeGuideButton.hidden = YES;
    } else {
        self.arrowImageView.hidden = NO;
        self.sizeGuideButton.hidden = NO;
    }
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = ZFLocalizedString(@"Size", nil);
    }
    return _titleLabel;
}

- (UIButton *)sizeGuideButton {
    if (!_sizeGuideButton) {
        _sizeGuideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sizeGuideButton setTitle:ZFLocalizedString(@"Detail_Product_SizeGuides", nil) forState:UIControlStateNormal];
        _sizeGuideButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sizeGuideButton setTitleColor:ZFCOLOR(153, 153, 153, 1.f) forState:UIControlStateNormal];
        [_sizeGuideButton addTarget:self action:@selector(sizeGuideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sizeGuideButton;
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
