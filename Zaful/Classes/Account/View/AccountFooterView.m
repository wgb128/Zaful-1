//
//  AccountFooterView.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/28.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "AccountFooterView.h"
#import "ZFInitViewProtocol.h"

@interface AccountFooterView () <ZFInitViewProtocol>

@property (nonatomic, strong) UIButton  *signOutButton;

@end

@implementation AccountFooterView
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
- (void)signOutButtonAction:(UIButton *)sender {
    if (self.signOutBlock) {
        self.signOutBlock();
    }
    // 谷歌统计
    [ZFAnalytics clickButtonWithCategory:@"Account" actionName:@"Account - Sign Out" label:@"Account - Sign Out"];
}


#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    [self addSubview:self.signOutButton];
}

- (void)zfAutoLayoutView {
    [self.signOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        make.leading.trailing.mas_equalTo(self);
    }];
}


-(UIButton *)signOutButton {
    if (!_signOutButton) {
        _signOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _signOutButton.backgroundColor = ZFCOLOR(235, 235, 235, 1.0);
        _signOutButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_signOutButton setTitleColor:ZFCOLOR(0, 0, 0, 1.0) forState:UIControlStateNormal];
        [_signOutButton setTitle:ZFLocalizedString(@"Account_SignOut_Button",nil) forState:UIControlStateNormal];
        [_signOutButton addTarget:self action:@selector(signOutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signOutButton;
}

@end
