//
//  ZFRegisterView.m
//  Zaful
//
//  Created by TsangFa on 2/12/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFRegisterView.h"
#import "ZFInitViewProtocol.h"
#import "ZFTextField.h"
#import "HyperlinksButton.h"

static CGFloat kCornerRadius = 8.0f;

@interface ZFRegisterView ()<ZFInitViewProtocol,UITextFieldDelegate>
@property (nonatomic, strong) UIButton      *loginButton;
@property (nonatomic, strong) UIButton      *backButton;
@property (nonatomic, strong) UIImageView   *logo;
@property (nonatomic, strong) UIImageView   *welfareImageView; // 阿语注册送300美金(图片)
@property (nonatomic, strong) ZFTextField   *emailTextField;
@property (nonatomic, strong) ZFTextField   *passwordTextField;
@property (nonatomic, strong) UIButton      *eyeButton;
@property (nonatomic, strong) UIButton      *registerButton;
@property (nonatomic, strong) UIButton      *agreeButton;
@property (nonatomic, strong) HyperlinksButton      *termsButton;
@property (nonatomic, strong) UIButton      *subscribeButton;
@property (nonatomic, strong) UIButton      *facebookButton;
@property (nonatomic, strong) UIButton      *googlePlusButton;
@property (nonatomic, assign) BOOL          isSubscribe;
@end

@implementation ZFRegisterView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [ZFAnalytics screenViewQuantityWithScreenName:@"Sign Up"];
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self cutCornerRadiuWithRect:self.bounds rectCorners:UIRectCornerAllCorners];
}

#pragma mark - Private method
- (BOOL)registerCharacterCheck {
    if (![NSStringUtils isValidEmailString:self.emailTextField.text] ||
        [NSStringUtils isEmptyString:self.emailTextField.text])
    {
        [self.emailTextField showErrorTipLabel:YES];
        return NO;
    }
    
    if ([NSStringUtils isEmptyString:self.passwordTextField.text] ||
        self.passwordTextField.text.length < 6 ||
        self.passwordTextField.text.length > 20)
    {
        [self.passwordTextField showErrorTipLabel:YES];
        return NO;
    }
    
    if (!self.agreeButton.selected) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"Register_zaful.com", nil)];
        return NO;
    }
    
    return YES;
}

- (void)cutCornerRadiuWithRect:(CGRect)rect rectCorners:(UIRectCorner)rectCorners{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorners cornerRadii:CGSizeMake(kCornerRadius, kCornerRadius)];
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.frame = rect;
    shapelayer.path = bezierPath.CGPath;
    self.layer.mask = shapelayer;
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    // 注册时按Done可以自动请求登录接口
    if(textField == self.passwordTextField) {
        [self registerButtonAction:nil];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.passwordTextField.text.length > 20) {
        [self.passwordTextField showErrorTipLabel:YES];
        return NO;
    }
    
    if (self.passwordTextField.text.length == 0) {
        self.passwordTextField.isSecure = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowPlaceholderAnimationNotification" object:nil];
    }
    
    if (string.length == 0) {
        return YES;
    }

    // 明文切换密文后避免被清空
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.passwordTextField && textField.isSecureTextEntry) {
        textField.text = toBeString;
        return NO;
    }
    return YES;
}

#pragma mark - Target action
- (void)login:(UIButton *)sender {
    [self endEditing:YES];
    self.emailTextField.text = nil;
    self.passwordTextField.text = nil;
    [self.emailTextField resetAnimation];
    [self.passwordTextField resetAnimation];
    if (self.loginButtonCompletionHandler) {
        self.loginButtonCompletionHandler();
    }
}

- (void)back:(UIButton *)sender {
    [self endEditing:YES];
    if (self.backButtonCompletionHandler) {
        self.backButtonCompletionHandler();
    }
}

- (void)registerButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    if (![self registerCharacterCheck]) {
        return ;
    }
    if (self.registerButtonCompletionHandler) {
        self.registerButtonCompletionHandler(self.emailTextField.text, self.passwordTextField.text, self.isSubscribe);
    }
}

- (void)showPassWord:(UIButton *)sender {
    self.passwordTextField.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
    self.passwordTextField.font = [UIFont systemFontOfSize:12.0f];
}

- (void)subscribeButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    sender.selected = !sender.selected;
    self.isSubscribe = sender.selected;
}

- (void)facebookButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    if (self.facebookButtonCompletionHandler) {
        self.facebookButtonCompletionHandler();
    }
}

- (void)googleplusButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    if (self.googleplusButtonCompletionHandler) {
        self.googleplusButtonCompletionHandler();
    }
}

- (void)webviewJumpButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    NSString *title = ZFLocalizedString(@"Login_Terms_Web_Title",nil);
    NSString *url = [NSString stringWithFormat:@"%@terms-of-use/?app=1&lang=%@",H5BaseURL, [ZFLocalizationString shareLocalizable].nomarLocalizable];
    if (self.webJumpActionCompletionHandler) {
        self.webJumpActionCompletionHandler(title, url);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    [self addSubview:self.loginButton];
    [self addSubview:self.backButton];
    [self addSubview:self.logo];
    [self addSubview:self.welfareImageView];
    [self addSubview:self.emailTextField];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.eyeButton];
    [self addSubview:self.registerButton];
    [self addSubview:self.agreeButton];
    [self addSubview:self.termsButton];
    [self addSubview:self.subscribeButton];
    [self addSubview:self.facebookButton];
    [self addSubview:self.googlePlusButton];
}

- (void)zfAutoLayoutView {
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.leading.mas_equalTo(15);
        make.height.mas_equalTo(44);
    }];

    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.trailing.mas_equalTo(-15);
        make.height.mas_equalTo(44);
    }];

    [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.welfareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logo.mas_bottom).offset(9);
        make.centerX.mas_equalTo(self);
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
    }];
    
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat padding = [SystemConfigUtils isRightToLeftShow] ? 45 : 25;
        make.top.equalTo(self.logo.mas_bottom).offset(padding);
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.height.mas_equalTo(28);
    }];

    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailTextField.mas_bottom).offset(27);
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.height.mas_equalTo(28);
    }];
    
    [self.eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.passwordTextField.mas_trailing).offset(-5);
        make.centerY.equalTo(self.passwordTextField);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(22);
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.height.mas_equalTo(35);
    }];

    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerButton.mas_bottom).offset(11);
        make.leading.mas_equalTo(15);
    }];
    
    [self.termsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.agreeButton.mas_centerY);
        make.leading.mas_equalTo(self.agreeButton.mas_trailing).offset(2);
    }];

    [self.subscribeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreeButton.mas_bottom).offset(9);
        make.leading.mas_equalTo(15);
    }];

    [self.facebookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(125, 35));
    }];

    [self.googlePlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(125, 35));
    }];
}

#pragma mark - Getter
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:ZFLocalizedString(@"SignIn_Button_left", nil) forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
        [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:ZFLocalizedString(@"login_back", nil) forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
        [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _backButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIImageView *)logo {
    if (!_logo) {
        _logo = [[UIImageView alloc] init];
        _logo.image = [SystemConfigUtils isRightToLeftShow] ? [UIImage imageNamed:@"ARLogo"] : [UIImage imageNamed:@"LoginLogo"];
    }
    return _logo;
}

- (UIImageView *)welfareImageView {
    if (!_welfareImageView) {
        _welfareImageView = [[UIImageView alloc] init];
        _welfareImageView.image = [UIImage imageNamed:@"welfare"];
        _welfareImageView.hidden = [SystemConfigUtils isRightToLeftShow] ? NO : YES;
    }
    return _welfareImageView;
}

- (ZFTextField *)emailTextField {
    if (!_emailTextField) {
        _emailTextField = [[ZFTextField alloc] init];
        _emailTextField.backgroundColor = [UIColor whiteColor];
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.returnKeyType = UIReturnKeyNext;
        _emailTextField.placeholder = ZFLocalizedString(@"SignIn_Email",nil);
        _emailTextField.font = [UIFont systemFontOfSize:12.f];
        _emailTextField.placeholderColor = ZFCOLOR(212, 212, 212, 1);
        _emailTextField.leftImage = [UIImage imageNamed:@"emailTextField"];
        _emailTextField.clearImage = [UIImage imageNamed:@"clearButton"];
        _emailTextField.errorTip = ZFLocalizedString(@"LoginForgotView_Valid_Email",nil);
        _emailTextField.errorFontSize = 9.f;
        _emailTextField.errorTipColor = [UIColor orangeColor];
        _emailTextField.textAlignment = [SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    }
    return _emailTextField;
}

- (ZFTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[ZFTextField alloc] init];
        _passwordTextField.backgroundColor = [UIColor whiteColor];
        _passwordTextField.keyboardType = UIKeyboardTypeDefault;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
        _passwordTextField.placeholder = ZFLocalizedString(@"SignIn_Password",nil);
        _passwordTextField.font = [UIFont systemFontOfSize:12.f];
        _passwordTextField.placeholderColor = ZFCOLOR(212, 212, 212, 1);
        _passwordTextField.leftImage = [UIImage imageNamed:@"passwordTextField"];
        _passwordTextField.clearImage = [UIImage imageNamed:@"clearButton"];
        _passwordTextField.errorTip = ZFLocalizedString(@"Login_Confirm_Tip_Password",nil);
        _passwordTextField.errorFontSize = 9.f;
        _passwordTextField.errorTipColor = [UIColor orangeColor];
        _passwordTextField.secureTextEntry = NO;
        _passwordTextField.textAlignment = [SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentRight : NSTextAlignmentLeft;
        [_passwordTextField addDoneOnKeyboardWithTarget:self action:@selector(registerButtonAction:)];
        _passwordTextField.rightButton = self.eyeButton;
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}

- (UIButton *)eyeButton {
    if (!_eyeButton) {
        _eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eyeButton setImage:[UIImage imageNamed:@"showSecureText"] forState:UIControlStateNormal];
        [_eyeButton setImage:[UIImage imageNamed:@"hideSecureText"] forState:UIControlStateSelected];
        [_eyeButton addTarget:self action:@selector(showPassWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeButton;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:ZFLocalizedString(@"Register_Button",nil) forState:UIControlStateNormal];
        _registerButton.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
        [_registerButton setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _registerButton.layer.cornerRadius = 17.5f;
        _registerButton.layer.masksToBounds = YES;
    }
    return _registerButton;
}

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeButton setImage:[UIImage imageNamed:@"unchoosed"] forState:UIControlStateNormal];
        [_agreeButton setImage:[UIImage imageNamed:@"choosed"] forState:UIControlStateSelected];
        [_agreeButton setTitle:ZFLocalizedString(@"Register_agree", nil) forState:UIControlStateNormal];
        [_agreeButton setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
        _agreeButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_agreeButton addTarget:self action:@selector(subscribeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _agreeButton.selected = YES;
    }
    return _agreeButton;
}

- (HyperlinksButton *)termsButton {
    if (!_termsButton) {
        _termsButton = [HyperlinksButton buttonWithType:UIButtonTypeCustom];
        [_termsButton setTitleColor:ZFCOLOR(153, 153, 153, 1.0) forState:UIControlStateNormal];
        [_termsButton setTitleColor:ZFCOLOR(153, 153, 153, 1.0) forState:UIControlStateHighlighted];
        _termsButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_termsButton setTitle:ZFLocalizedString(@"Register_TermsOfUser",nil) forState:UIControlStateNormal];
        [_termsButton setColor:ZFCOLOR(153, 153, 153, 1.0)];
        _termsButton.tag = RegisterTermType;
        [_termsButton addTarget:self action:@selector(webviewJumpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _termsButton;
}

- (UIButton *)subscribeButton {
    if (!_subscribeButton) {
        _subscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subscribeButton setImage:[UIImage imageNamed:@"unchoosed"] forState:UIControlStateNormal];
        [_subscribeButton setImage:[UIImage imageNamed:@"choosed"] forState:UIControlStateSelected];
        [_subscribeButton setTitle:ZFLocalizedString(@"Register_subscribe", nil) forState:UIControlStateNormal];
        [_subscribeButton setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
        _subscribeButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_subscribeButton addTarget:self action:@selector(subscribeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _subscribeButton.selected = YES;
        self.isSubscribe = YES;
    }
    return _subscribeButton;
}

- (UIButton *)facebookButton {
    if (!_facebookButton) {
        _facebookButton = [ZFButton buttonWithType:UIButtonTypeCustom];
        [_facebookButton setTitle:ZFLocalizedString(@"Register_FB_Connect", nil) forState:UIControlStateNormal];
        [_facebookButton setImage:[UIImage imageNamed:@"register_fb"] forState:UIControlStateNormal];
        _facebookButton.backgroundColor = ZFCOLOR(59, 88, 156, 1.0);
        [_facebookButton setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [_facebookButton addTarget:self action:@selector(facebookButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _facebookButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    }
    return _facebookButton;
}

- (UIButton *)googlePlusButton {
    if (!_googlePlusButton) {
        _googlePlusButton = [ZFButton buttonWithType:UIButtonTypeCustom];
        [_googlePlusButton setTitle:ZFLocalizedString(@"Register_GG_Connect", nil) forState:UIControlStateNormal];
        [_googlePlusButton setImage:[UIImage imageNamed:@"register_google"] forState:UIControlStateNormal];
        _googlePlusButton.backgroundColor = ZFCOLOR(220, 72, 60, 1.0);
        [_googlePlusButton setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [_googlePlusButton addTarget:self action:@selector(googleplusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _googlePlusButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    }
    return _googlePlusButton;
}

@end
