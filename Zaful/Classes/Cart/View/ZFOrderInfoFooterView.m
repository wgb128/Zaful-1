//
//  ZFOrderInfoFooterView.m
//  Zaful
//
//  Created by TsangFa on 21/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderInfoFooterView.h"
#import "ZFInitViewProtocol.h"
#import "ZFOrderInfoFooterModel.h"
#import "HyperlinksButton.h"

@interface ZFOrderInfoFooterView ()<ZFInitViewProtocol>
@property (nonatomic, strong) UILabel   *topLabel;
@property (nonatomic, strong) UILabel   *midelabel;
@property (nonatomic, strong) UIView    *bottomView;
@property (nonatomic, strong) HyperlinksButton   *learnMoreButton;
@property (nonatomic, strong) HyperlinksButton   *contactButton;
@property (nonatomic, strong) UILabel   *orLabel;
@end

@implementation ZFOrderInfoFooterView

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
    self.backgroundColor = ZFCOLOR(247, 247, 247, 1);
    [self addSubview:self.topLabel];
    [self addSubview:self.midelabel];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.learnMoreButton];
    [self.bottomView addSubview:self.orLabel];
    [self.bottomView addSubview:self.contactButton];
}

- (void)zfAutoLayoutView {
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(28);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(15);
    }];
    
    [self.midelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).offset(4);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(15);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.midelabel.mas_bottom).offset(12);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-28);
        make.height.mas_equalTo(30);
    }];
    
    [self.learnMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.equalTo(self.bottomView);
    }];

    [self.orLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.learnMoreButton.mas_trailing).offset(4);
        make.centerY.equalTo(self.bottomView);
    }];

    [self.contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.orLabel.mas_trailing).offset(4);
        make.trailing.centerY.equalTo(self.bottomView);
    }];
}

#pragma mark - Button Action
- (void)webviewJumpButtonAction:(UIButton *)sender{
    NSString *url;
    if (sender.tag == 0) {
        url = self.model.learn_more_url;
    }else{
        url = self.model.contact_us_url;
    }
    if (self.orderInfoH5Block) {
        self.orderInfoH5Block(url);
    }
}

#pragma mark - Setter
-(void)setModel:(ZFOrderInfoFooterModel *)model {
    _model = model;
    self.topLabel.text = model.topTip;
    self.midelabel.text = model.midTip;
}

#pragma mark - getter
- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [UILabel new];
        _topLabel.textColor = ZFCOLOR(153, 153, 153, 1);
        _topLabel.font = [UIFont systemFontOfSize:12.0];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.numberOfLines = 1;
        _topLabel.preferredMaxLayoutWidth = KScreenWidth - 10;
    }
    return _topLabel;
}

- (UILabel *)midelabel {
    if (!_midelabel) {
        _midelabel = [UILabel new];
        _midelabel.textColor = ZFCOLOR(153, 153, 153, 1);
        _midelabel.font = [UIFont systemFontOfSize:12.0];
        _midelabel.textAlignment = NSTextAlignmentCenter;
        _midelabel.numberOfLines = 1;
        _midelabel.preferredMaxLayoutWidth = KScreenWidth - 10;
    }
    return _midelabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = ZFCOLOR(247, 247, 247, 1);
    }
    return _bottomView;
    
}

- (HyperlinksButton *)learnMoreButton {
    if (!_learnMoreButton) {
        _learnMoreButton = [HyperlinksButton buttonWithType:UIButtonTypeCustom];
        [_learnMoreButton setTitleColor:ZFCOLOR(153, 153, 153, 1.0) forState:UIControlStateNormal];
        [_learnMoreButton setTitleColor:ZFCOLOR(153, 153, 153, 1.0) forState:UIControlStateHighlighted];
        _learnMoreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_learnMoreButton setTitle:ZFLocalizedString(@"ZFOrderList_Learn_more", nil) forState:UIControlStateNormal];
        [_learnMoreButton setColor:ZFCOLOR(153, 153, 153, 1.0)];
        _learnMoreButton.tag = 0;
        [_learnMoreButton addTarget:self action:@selector(webviewJumpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _learnMoreButton;
}

- (HyperlinksButton *)contactButton {
    if (!_contactButton) {
        _contactButton = [HyperlinksButton buttonWithType:UIButtonTypeCustom];
        [_contactButton setTitleColor:ZFCOLOR(153, 153, 153, 1.0) forState:UIControlStateNormal];
        [_contactButton setTitleColor:ZFCOLOR(153, 153, 153, 1.0) forState:UIControlStateHighlighted];
        _contactButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_contactButton setTitle:ZFLocalizedString(@"ZFOrderList_Contact_us", nil) forState:UIControlStateNormal];
        [_contactButton setColor:ZFCOLOR(153, 153, 153, 1.0)];
        _contactButton.tag = 1;
        [_contactButton addTarget:self action:@selector(webviewJumpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactButton;
}


- (UILabel *)orLabel {
    if (!_orLabel) {
        _orLabel = [UILabel new];
        _orLabel.textColor = ZFCOLOR(153, 153, 153, 1);
        _orLabel.font = [UIFont systemFontOfSize:12.0];
        _orLabel.text = ZFLocalizedString(@"ZFOrderInfo_Or", nil);
    }
    return _orLabel;
}

@end
