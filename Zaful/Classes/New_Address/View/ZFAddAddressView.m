



//
//  ZFAddAddressView.m
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddAddressView.h"
#import "ZFInitViewProtocol.h"

@interface ZFAddAddressView () <ZFInitViewProtocol> 
@property (nonatomic, strong) UIButton          *addAddressButton;
@end

@implementation ZFAddAddressView
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
- (void)addAddressButtonAction:(UIButton *)sender {
    if (self.addAddressCompletionHandler) {
        self.addAddressCompletionHandler();
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
    [self addSubview:self.addAddressButton];
}

- (void)zfAutoLayoutView {
    [self.addAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - getter
- (UIButton *)addAddressButton {
    if (!_addAddressButton) {
        _addAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addAddressButton.backgroundColor = ZFCOLOR_BLACK;
        [_addAddressButton setTitleColor:ZFCOLOR_WHITE forState:UIControlStateNormal];
        _addAddressButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _addAddressButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_addAddressButton setTitle:ZFLocalizedString(@"Address_VC_Add_Address",nil) forState:UIControlStateNormal];
        [_addAddressButton addTarget:self action:@selector(addAddressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAddressButton;
}

@end
