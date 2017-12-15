//
//  ChangePasswordSuccessViewController.m
//  Dezzal
//
//  Created by ZJ1620 on 16/8/6.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "ChangePasswordSuccessViewController.h"
#import "ZFInitViewProtocol.h"

@interface ChangePasswordSuccessViewController () <ZFInitViewProtocol>

@property (nonatomic, strong) UILabel   *dearLabel;
@property (nonatomic, strong) UILabel   *pointLabel;
@property (nonatomic, strong) UIButton  *laterButton;
@property (nonatomic, strong) UIButton  *nowButton;


@end

@implementation ChangePasswordSuccessViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
}

#pragma mark - action methods
//sign in later Button
- (void)signInLaterAction:(UIButton *)sender {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate goHome];
}

//sign in now Button
- (void)signInNowAction:(UIButton *)sender {
    [self loginVerifySuccess:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    [self.view addSubview:self.dearLabel];
    [self.view addSubview:self.pointLabel];
    [self.view addSubview:self.laterButton];
    [self.view addSubview:self.nowButton];
}

- (void)zfAutoLayoutView {
    [self.dearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(@(10));
        make.top.mas_equalTo(@(65));
    }];
    
    [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(@(10));
        make.top.mas_equalTo(self.dearLabel.mas_bottom).offset(15);
        make.trailing.mas_equalTo(@(-10));
    }];
    
    NSArray *butArray = @[self.laterButton,self.nowButton];
    [butArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    [butArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pointLabel.mas_bottom).offset(40);
        make.height.mas_equalTo(@(56));
    }];
}

#pragma mark - getter
- (UILabel *)dearLabel {
    if (!_dearLabel) {
        _dearLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _dearLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        _dearLabel.text = ZFLocalizedString(@"ChangePassword_Success_Customer",nil);
        _dearLabel.font = [UIFont systemFontOfSize:22];
    }
    return _dearLabel;
}

- (UILabel *)pointLabel {
    if (!_pointLabel) {
        _pointLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _pointLabel.textColor = ZFCOLOR(178, 178, 178, 1);
        _pointLabel.text = ZFLocalizedString(@"ChangePassword_Success_NewPassword",nil);
        _pointLabel.font = [UIFont systemFontOfSize:20];
        _pointLabel.numberOfLines = 0;
    }
    return _pointLabel;
}

- (UIButton *)laterButton {
    if (!_laterButton) {
        _laterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _laterButton.backgroundColor = ZFCOLOR_WHITE;
        _laterButton.layer.borderWidth = 1.0;
        _laterButton.layer.borderColor = ZFCOLOR(0, 0, 0, 1.0).CGColor;
        [_laterButton setTitle:ZFLocalizedString(@"ChangePassword_Success_SigninLater",nil) forState:UIControlStateNormal];
        [_laterButton setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
        [_laterButton addTarget:self action:@selector(signInLaterAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _laterButton;
}

- (UIButton *)nowButton {
    if (!_nowButton) {
        _nowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nowButton.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
        [_nowButton setTitle:ZFLocalizedString(@"ChangePassword_Success_SignInNow",nil) forState:UIControlStateNormal];
        [_nowButton setTitleColor:ZFCOLOR_WHITE forState:UIControlStateNormal];
        [_nowButton addTarget:self action:@selector(signInNowAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nowButton;
}
@end
