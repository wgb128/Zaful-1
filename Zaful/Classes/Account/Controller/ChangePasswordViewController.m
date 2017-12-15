//
//  ChangePasswordViewController.m
//  Dezzal
//
//  Created by ZJ1620 on 16/8/6.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ChangePasswordViewModel.h"
#import "ChangePasswordSuccessViewController.h"
#import "ZFInitViewProtocol.h"

@interface ChangePasswordViewController () <UITextFieldDelegate, ZFInitViewProtocol>

@property (nonatomic, strong) ChangePasswordViewModel   *viewModel;
@property (nonatomic, strong) CustomTextField           *oldpassWordField;
@property (nonatomic, strong) CustomTextField           *passWordField;
@property (nonatomic, strong) CustomTextField           *confirmPassWordField;
@property (nonatomic, strong) UIButton                  *resetButton;
@property (nonatomic, strong) UILabel                   *pointOldLabel;
@property (nonatomic, strong) UILabel                   *pointNewLabel;
@property (nonatomic, strong) UILabel                   *pointConfirmLabel;

@end

@implementation ChangePasswordViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zfInitView];
    [self zfAutoLayoutView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBlankPage)];
    [self.view addGestureRecognizer:tap];
    
}

#pragma mark - action methods
- (void)resetButtonAction:(UIButton *)sender {
    
    if (![self checkInfo]) {
        return;
    }
    [MBProgressHUD showLoadingView:nil];
    [self.viewModel requestNetwork:@[self.oldpassWordField.text,self.passWordField.text,self.confirmPassWordField.text] completion:^(id obj) {
        [MBProgressHUD hideHUD];
        if ([obj[@"statusCode"] integerValue] == 200) {
            if ([obj[@"result"][@"error"] integerValue] == 0) {
                [[AccountManager sharedManager] clearUserInfo];
                ChangePasswordSuccessViewController *vc = [ChangePasswordSuccessViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
             [MBProgressHUD showMessage:obj[@"result"][@"msg"]];
        }
        
    } failure:^(id obj) {
        [MBProgressHUD hideHUD];
         [MBProgressHUD showMessage:ZFLocalizedString(@"ChangePassword_VC_Request_Failure_Message",nil)];
    }];
}

- (void)tapBlankPage {
    [self.oldpassWordField resignFirstResponder];
    [self.passWordField resignFirstResponder];
    [self.confirmPassWordField resignFirstResponder];
    [self checkInfo];
}

- (BOOL)checkInfo {
    
    if ([self.oldpassWordField.text isEqualToString:@""] || self.oldpassWordField.text.length == 0) {
        self.pointOldLabel.text = ZFLocalizedString(@"ChangePassword_VC_Provide_Message",nil);
        self.pointOldLabel.hidden = NO;
        return NO;
    }
    
    if (self.passWordField.text.length < 5) {
        self.pointNewLabel.text = ZFLocalizedString(@"ChangePassword_VC_Least_Message",nil);
        self.pointNewLabel.hidden = NO;
        return NO;
    }
    if (self.passWordField.text.length > 50) {
        self.pointNewLabel.text = ZFLocalizedString(@"ChangePassword_VC_Most_Message",nil);
        self.pointNewLabel.hidden = NO;
        return NO;
    }
    
    if ([self.confirmPassWordField.text isEqualToString:@""] || self.confirmPassWordField.text.length == 0) {
        self.pointConfirmLabel.text = ZFLocalizedString(@"ChangePassword_VC_Confirm_Message",nil);
        self.pointConfirmLabel.hidden = NO;
        return NO;
    }
    if (![self.confirmPassWordField.text isEqualToString:self.passWordField.text]) {
        self.pointConfirmLabel.text = ZFLocalizedString(@"ChangePassword_VC_NotMatch_Message",nil);
        self.pointConfirmLabel.hidden = NO;
        return NO;
    }
    return YES;
}

#pragma  mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.pointConfirmLabel.hidden = YES;
    self.pointNewLabel.hidden = YES;
    self.pointOldLabel.hidden = YES;
    return YES;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.title = ZFLocalizedString(@"ChangePassword_VC_Title",nil);
    self.view.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    self.oldpassWordField = [self setTextFielWith:ZFLocalizedString(@"ChangePassword_VC_OrignPassword",nil)];
    self.passWordField = [self setTextFielWith:ZFLocalizedString(@"ChangePassword_VC_NewPassword",nil)];
    self.confirmPassWordField = [self setTextFielWith:ZFLocalizedString(@"ChangePassword_VC_ConfirmPassword",nil)];
    [self.view addSubview:self.pointOldLabel];
    [self.view addSubview:self.pointNewLabel];
    [self.view addSubview:self.pointConfirmLabel];
    [self.view addSubview:self.resetButton];
}

- (void)zfAutoLayoutView {
    [self.oldpassWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(50));
        make.leading.mas_equalTo(@(20));
        make.trailing.mas_equalTo(@(-20));
        make.height.mas_equalTo(@(50));
    }];
    
    [self.passWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.oldpassWordField.mas_bottom).offset(25);
        make.leading.mas_equalTo(@(20));
        make.trailing.mas_equalTo(@(-20));
        make.height.mas_equalTo(@(50));
    }];
    
    [self.confirmPassWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passWordField.mas_bottom).offset(25);
        make.leading.mas_equalTo(@(20));
        make.trailing.mas_equalTo(@(-20));
        make.height.mas_equalTo(@(50));
    }];
    
    [self.pointOldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.oldpassWordField.mas_bottom);
        make.leading.mas_equalTo(@(20));
    }];
    
    [self.pointNewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passWordField.mas_bottom);
        make.leading.mas_equalTo(@(20));
    }];
    
    [self.pointConfirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.confirmPassWordField.mas_bottom);
        make.leading.mas_equalTo(@(20));
    }];
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.confirmPassWordField.mas_bottom).offset(25);
        make.leading.mas_equalTo(@(20));
        make.trailing.mas_equalTo(@(-20));
        make.height.mas_equalTo(@(56));
    }];
}

- (CustomTextField *)setTextFielWith:(NSString *)placeholder {
    CustomTextField * text = [[CustomTextField alloc]initWithFrame:CGRectZero];
    text.placeholder = placeholder;
    text.textAlignment = [SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    text.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
    text.textColor = ZFCOLOR(0, 0, 0, 1.0);
    text.clearButtonMode = UITextFieldViewModeWhileEditing;
    [text setSecureTextEntry:YES];
    text.delegate = self;
    text.font = [UIFont systemFontOfSize:16];
    [text setValue:ZFCOLOR(153, 153, 153, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    [text setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:text];
    return text;
}

#pragma mark - getter
- (UILabel *)pointOldLabel {
    if (!_pointOldLabel) {
        _pointOldLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _pointOldLabel.textColor = ZFCOLOR(245, 86, 88, 1.0);
        _pointOldLabel.font = [UIFont systemFontOfSize:14];
        _pointOldLabel.hidden = YES;
    }
    return _pointOldLabel;
}

- (UILabel *)pointNewLabel {
    if (!_pointNewLabel) {
        _pointNewLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _pointNewLabel.textColor = ZFCOLOR(245, 86, 88, 1.0);
        _pointNewLabel.font = [UIFont systemFontOfSize:14];
        _pointNewLabel.hidden = YES;
    }
    return _pointNewLabel;
}

- (UILabel *)pointConfirmLabel {
    if (!_pointConfirmLabel) {
        _pointConfirmLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _pointConfirmLabel.textColor = ZFCOLOR(245, 86, 88, 1.0);
        _pointConfirmLabel.font = [UIFont systemFontOfSize:14];
        _pointConfirmLabel.hidden = YES;
    }
    return _pointConfirmLabel;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetButton.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
        [_resetButton setTitle:ZFLocalizedString(@"ChangePassword_VC_ResetPassword",nil) forState:UIControlStateNormal];
        [_resetButton setTitleColor:ZFCOLOR_WHITE forState:UIControlStateNormal];
        NSString *localeLanguageCode = [ZFLocalizationString shareLocalizable].nomarLocalizable;
        _resetButton.titleLabel.font = [localeLanguageCode hasPrefix:@"fr"] || [localeLanguageCode hasPrefix:@"es"] ?  [UIFont systemFontOfSize:18 *DSCREEN_WIDTH_SCALE] : [UIFont systemFontOfSize:18];
        [_resetButton addTarget:self action:@selector(resetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

- (ChangePasswordViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [ChangePasswordViewModel new];
    }
    return _viewModel;
}

@end
