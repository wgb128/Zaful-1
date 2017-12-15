
//
//  ZFCartUnavailableGoodsHeaderView.m
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartUnavailableGoodsHeaderView.h"
#import "ZFInitViewProtocol.h"
#import "UIView+GBGesture.h"

@interface ZFCartUnavailableGoodsHeaderView () <ZFInitViewProtocol>
@property (nonatomic, strong) UILabel               *unavailabelLabel;
@property (nonatomic, strong) UIButton              *clearAllButton;
@property (nonatomic, strong) UIView                *lineView;
@end

@implementation ZFCartUnavailableGoodsHeaderView
#pragma mark - init methods
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - action methods 
- (void)clearAllButtonAction:(UIButton *)sender {
    if (self.cartUnavailableGoodsClearAllCompletionHandler) {
        self.cartUnavailableGoodsClearAllCompletionHandler();
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.unavailabelLabel];
    [self.contentView addSubview:self.clearAllButton];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.unavailabelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(40);
        make.trailing.mas_equalTo(self.clearAllButton.mas_leading).offset(-10);
    }];
    
    [self.clearAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.unavailabelLabel);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
    }];
    
    [self.clearAllButton setContentHuggingPriority:UILayoutPriorityRequired
                                      forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.clearAllButton setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                    forAxis:UILayoutConstraintAxisHorizontal];
}


#pragma mark - getter
- (UILabel *)unavailabelLabel {
    if (!_unavailabelLabel) {
        _unavailabelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _unavailabelLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _unavailabelLabel.font = [UIFont systemFontOfSize:14];
        _unavailabelLabel.text = ZFLocalizedString(@"CartUnavailableProductTips", nil);
    }
    return _unavailabelLabel;
}

- (UIButton *)clearAllButton {
    if (!_clearAllButton) {
        _clearAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearAllButton setTitleColor:ZFCOLOR(153, 153, 153, 1.f) forState:UIControlStateNormal];
        [_clearAllButton setTitle:ZFLocalizedString(@"CartClearAllButtonTips", nil) forState:UIControlStateNormal];
        _clearAllButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_clearAllButton setImage:[UIImage imageNamed:@"rubbish-min"] forState:UIControlStateNormal];
        [_clearAllButton addTarget:self action:@selector(clearAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (![SystemConfigUtils isRightToLeftShow]) {
            _clearAllButton.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
            _clearAllButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
        } else {
            _clearAllButton.imageEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
            _clearAllButton.titleEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
        }
    }
    return _clearAllButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}
@end
