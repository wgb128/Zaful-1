//
//  ZFLoginView.m
//  Zaful
//
//  Created by TsangFa on 1/12/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFLoginView.h"
#import "ZFInitViewProtocol.h"
#import "ZFTextField.h"

static CGFloat kCornerRadius = 8.0f;

@interface ZFLoginView ()<ZFInitViewProtocol,UITextFieldDelegate,CAAnimationDelegate>
@property (nonatomic, strong) UIButton      *registerButton;
@property (nonatomic, strong) UIButton      *backButton;
@property (nonatomic, strong) UIImageView   *logo;
@property (nonatomic, strong) UIImageView   *welfareImageView; // 阿语注册送300美金(图片)
@property (nonatomic, strong) ZFTextField   *emailTextField;
@property (nonatomic, strong) ZFTextField   *passwordTextField;
@property (nonatomic, strong) UIButton      *loginButton;
@property (nonatomic, strong) UIButton      *forgotButton;
@property (nonatomic, strong) UIButton      *facebookButton;
@property (nonatomic, strong) UIButton      *googlePlusButton;

@property (nonatomic, strong) UILabel       *forgetPasswordLabel;
@property (nonatomic, strong) UILabel       *forgetPasswordTips;
@property (nonatomic, strong) ZFTextField   *forgetPassWordTextField;
@property (nonatomic, strong) UIButton      *okButton;
@property (nonatomic, strong) UIButton      *cancelButton;

@property (nonatomic, strong) CABasicAnimation   *hideAnimation;

@property (nonatomic, assign) BOOL   isForgetPassWord;
@end

@implementation ZFLoginView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //谷歌分析页面统计
        [ZFAnalytics screenViewQuantityWithScreenName:@"Sign In"];
        [self zfInitView];
        [self zfAutoLayoutView];
        NSString *email = [[NSUserDefaults standardUserDefaults] valueForKey:kUserEmail];
        if (email) {
            self.emailTextField.text = email;
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self cutCornerRadiuWithRect:self.bounds rectCorners:UIRectCornerAllCorners];
}

#pragma mark - Private method
- (BOOL)loginCharacterCheck {
    
    if (self.isForgetPassWord) {
        if (![NSStringUtils isValidEmailString:self.forgetPassWordTextField.text] ||
            [NSStringUtils isEmptyString:self.forgetPassWordTextField.text])
        {
            [self.forgetPassWordTextField showErrorTipLabel:YES];
            return NO;
            
        }
        return YES;
    }
    
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
    
    return YES;
}

- (void)cutCornerRadiuWithRect:(CGRect)rect rectCorners:(UIRectCorner)rectCorners{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorners cornerRadii:CGSizeMake(kCornerRadius, kCornerRadius)];
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.frame = rect;
    shapelayer.path = bezierPath.CGPath;
    self.layer.mask = shapelayer;
}

- (void)showHideLoginViewAnimation {
    [self.hideAnimation setValue:@"hideLoginAnimation" forKey:@"AnimationKey"];
    [self.emailTextField.layer addAnimation:self.hideAnimation forKey:@"hideLoginAnimation"];
    [self.passwordTextField.layer addAnimation:self.hideAnimation forKey:@"hideLoginAnimation"];
    [self.loginButton.layer addAnimation:self.hideAnimation forKey:@"hideLoginAnimation"];
    [self.forgotButton.layer addAnimation:self.hideAnimation forKey:@"hideLoginAnimation"];
    [self.facebookButton.layer addAnimation:self.hideAnimation forKey:@"hideLoginAnimation"];
    [self.googlePlusButton.layer addAnimation:self.hideAnimation forKey:@"hideLoginAnimation"];
}

- (void)showForgetPassWordAnimation {
    [self configureForgetPassWordAnimation:self.forgetPasswordLabel delay:0];
    [self configureForgetPassWordAnimation:self.forgetPasswordTips delay:0];
    [self configureForgetPassWordAnimation:self.forgetPassWordTextField delay:0];
    [self configureForgetPassWordAnimation:self.okButton delay:0];
    [self configureForgetPassWordAnimation:self.cancelButton delay:0];
}

- (void)showHideForgetPassWordAnimation {
    [self.hideAnimation setValue:@"hideForgetPassWordAnimation" forKey:@"AnimationKey"];
    [self.forgetPasswordLabel.layer addAnimation:self.hideAnimation forKey:@"hideForgetPassWordAnimation"];
    [self.forgetPasswordTips.layer addAnimation:self.hideAnimation forKey:@"hideForgetPassWordAnimation"];
    [self.forgetPassWordTextField.layer addAnimation:self.hideAnimation forKey:@"hideForgetPassWordAnimation"];
    [self.okButton.layer addAnimation:self.hideAnimation forKey:@"hideForgetPassWordAnimation"];
    [self.cancelButton.layer addAnimation:self.hideAnimation forKey:@"hideForgetPassWordAnimation"];
}

- (void)showLoginAnimation {
    [self configureForgetPassWordAnimation:self.emailTextField delay:0];
    [self configureForgetPassWordAnimation:self.passwordTextField delay:0];
    [self configureForgetPassWordAnimation:self.loginButton delay:0];
    [self configureForgetPassWordAnimation:self.forgotButton delay:0];
    [self configureForgetPassWordAnimation:self.facebookButton delay:0];
    [self configureForgetPassWordAnimation:self.googlePlusButton delay:0];
}

- (void)configureForgetPassWordAnimation:(UIView *)targetView delay:(CGFloat)delay{
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @(0);
    opacity.toValue = @(1);
    
    CABasicAnimation *positionY = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionY.fromValue =  @(CGRectGetMidY(targetView.frame) + CGRectGetHeight(targetView.frame) + 120);
    positionY.toValue =  @(CGRectGetMidY(targetView.frame));
    
    CAAnimationGroup *anigroup = [CAAnimationGroup animation];
    anigroup.animations = @[opacity,positionY];
    anigroup.duration = 0.4;
    anigroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anigroup.beginTime = CACurrentMediaTime() + delay;
    anigroup.fillMode = kCAFillModeForwards;
    anigroup.removedOnCompletion = NO;
    [targetView.layer addAnimation:anigroup forKey:@"anigroup"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if([[anim valueForKey:@"AnimationKey"] isEqualToString:@"hideLoginAnimation"]) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.forgetPasswordLabel.hidden = NO;
            self.forgetPasswordTips.hidden = NO;
            self.forgetPassWordTextField.hidden = NO;
            self.okButton.hidden = NO;
            self.cancelButton.hidden = NO;
        } completion:^(BOOL finished) {

        }];
        [self showForgetPassWordAnimation];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.emailTextField.hidden = YES;
            self.passwordTextField.hidden = YES;
            self.loginButton.hidden = YES;
            self.forgotButton.hidden = YES;
            self.facebookButton.hidden = YES;
            self.googlePlusButton.hidden = YES;
        } completion:nil];
        return;
    }

    if([[anim valueForKey:@"AnimationKey"] isEqualToString:@"hideForgetPassWordAnimation"]) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.forgetPasswordLabel.hidden = YES;
            self.forgetPasswordTips.hidden = YES;
            self.forgetPassWordTextField.hidden = YES;
            self.okButton.hidden = YES;
            self.cancelButton.hidden = YES;
        } completion:^(BOOL finished) {

        }];
        [self showLoginAnimation];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.emailTextField.hidden = NO;
            self.passwordTextField.hidden = NO;
            self.loginButton.hidden = NO;
            self.forgotButton.hidden = NO;
            self.facebookButton.hidden = NO;
            self.googlePlusButton.hidden = NO;
        } completion:nil];
    }
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    // 登录时按Done可以自动请求登录接口
    if(textField == self.passwordTextField) {
        [self loginButtonAction:nil];
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
- (void)register:(UIButton *)sender {
    [self endEditing:YES];
    self.emailTextField.text = nil;
    self.passwordTextField.text = nil;
    [self.emailTextField resetAnimation];
    [self.passwordTextField resetAnimation];
    if (self.registerButtonCompletionHandler) {
        self.registerButtonCompletionHandler();
    }
}

- (void)back:(UIButton *)sender {
    [self endEditing:YES];
    if (self.backButtonCompletionHandler) {
        self.backButtonCompletionHandler();
    }
}

- (void)loginButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    if (![self loginCharacterCheck]) {
        return ;
    }
    if (self.signInButtonCompletionHandler) {
        self.signInButtonCompletionHandler(self.emailTextField.text, self.passwordTextField.text);
    }
}

- (void)forgotButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    [self showHideLoginViewAnimation];
    if ([self.passwordTextField.text length] || [self.emailTextField.text length]) {
        [self.emailTextField resetAnimation];
        [self.passwordTextField resetAnimation];

    }
    self.emailTextField.text = nil;
    self.passwordTextField.text = nil;
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

- (void)okeyButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    self.isForgetPassWord = YES;
    if (![self loginCharacterCheck]) {
        return ;
    }
    [self showHideForgetPassWordAnimation];
    if (self.forgotPasswordRequestCompletionHandler) {
        self.forgotPasswordRequestCompletionHandler(self.forgetPassWordTextField.text);
    }
}

- (void)cancelButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    self.isForgetPassWord = NO;
    [self showHideForgetPassWordAnimation];
    if ([self.forgetPassWordTextField.text length]) {
        [self.forgetPassWordTextField resetAnimation];
    }
    self.forgetPassWordTextField.text = nil;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    [self addSubview:self.registerButton];
    [self addSubview:self.backButton];
    [self addSubview:self.logo];
    [self addSubview:self.welfareImageView];
    [self addSubview:self.emailTextField];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.loginButton];
    [self addSubview:self.forgotButton];
    [self addSubview:self.facebookButton];
    [self addSubview:self.googlePlusButton];
    
    [self addSubview:self.forgetPasswordLabel];
    [self addSubview:self.forgetPasswordTips];
    [self addSubview:self.forgetPassWordTextField];
    [self addSubview:self.okButton];
    [self addSubview:self.cancelButton];
}

- (void)zfAutoLayoutView {
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(self.logo.mas_bottom).offset(8);
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

    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(20);
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.height.mas_equalTo(35);
    }];

    [self.forgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(44);
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
    
    [self.forgetPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat padding = [SystemConfigUtils isRightToLeftShow] ? 45 : 30;
        make.top.equalTo(self.logo.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(self);
    }];

    [self.forgetPasswordTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forgetPasswordLabel.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self);
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
    }];

    [self.forgetPassWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forgetPasswordTips.mas_bottom).offset(25);
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.height.mas_equalTo(28);
    }];

    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forgetPassWordTextField.mas_bottom).offset(28);
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.height.mas_equalTo(35);
    }];

    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - Getter
- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:ZFLocalizedString(@"Register_Button_left", nil) forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
        [_registerButton addTarget:self action:@selector(register:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
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
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.textAlignment = [SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentRight : NSTextAlignmentLeft;
        [_passwordTextField addDoneOnKeyboardWithTarget:self action:@selector(loginButtonAction:)];
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:ZFLocalizedString(@"SignIn_Button",nil) forState:UIControlStateNormal];
        _loginButton.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
        [_loginButton setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _loginButton.layer.cornerRadius = 17.5f;
        _loginButton.layer.masksToBounds = YES;
    }
    return _loginButton;
}

- (UIButton *)forgotButton {
    if (!_forgotButton) {
        _forgotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgotButton setTitle:ZFLocalizedString(@"SignIn_ForgotPassword",nil) forState:UIControlStateNormal];
        [_forgotButton setTitleColor:ZFCOLOR(153, 153, 153, 1.0) forState:UIControlStateNormal];
        _forgotButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_forgotButton addTarget:self action:@selector(forgotButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotButton;
}

- (UIButton *)facebookButton {
    if (!_facebookButton) {
        _facebookButton = [ZFButton buttonWithType:UIButtonTypeCustom];
        [_facebookButton setTitle:ZFLocalizedString(@"Register_FB_Connect", nil) forState:UIControlStateNormal];
        [_facebookButton setImage:[UIImage imageNamed:@"register_fb"] forState:UIControlStateNormal];
        _facebookButton.backgroundColor = ZFCOLOR(59, 88, 156, 1.0);
        [_facebookButton setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [_facebookButton addTarget:self action:@selector(facebookButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _facebookButton.titleLabel.font = [UIFont systemFontOfSize:18];
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
        _googlePlusButton.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _googlePlusButton;
}

- (UILabel *)forgetPasswordLabel {
    if (!_forgetPasswordLabel) {
        _forgetPasswordLabel = [[UILabel alloc] init];
        _forgetPasswordLabel.textColor = [UIColor blackColor];
        _forgetPasswordLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _forgetPasswordLabel.textAlignment = NSTextAlignmentCenter;
        _forgetPasswordLabel.text = ZFLocalizedString(@"LoginForgotView_Title",nil);
        _forgetPasswordLabel.hidden = YES;
    }
    return _forgetPasswordLabel;
}

- (UILabel *)forgetPasswordTips {
    if (!_forgetPasswordTips) {
        _forgetPasswordTips = [[UILabel alloc] init];
        _forgetPasswordTips.textAlignment = NSTextAlignmentCenter;
        _forgetPasswordTips.font = [UIFont systemFontOfSize:12.f];
        _forgetPasswordTips.numberOfLines = 0;
        _forgetPasswordTips.text = ZFLocalizedString(@"LoginForgotView_EmailView_Descripe",nil);
        _forgetPasswordTips.hidden = YES;
    }
    return _forgetPasswordTips;
}

- (ZFTextField *)forgetPassWordTextField {
    if (!_forgetPassWordTextField) {
        _forgetPassWordTextField = [[ZFTextField alloc] init];
        _forgetPassWordTextField.backgroundColor = [UIColor whiteColor];
        _forgetPassWordTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _forgetPassWordTextField.returnKeyType = UIReturnKeyDone;
        _forgetPassWordTextField.placeholder = ZFLocalizedString(@"LoginForgotView_Your_Email",nil);
        _forgetPassWordTextField.font = [UIFont systemFontOfSize:12.f];
        _forgetPassWordTextField.placeholderColor = ZFCOLOR(212, 212, 212, 1);
        _forgetPassWordTextField.leftImage = [UIImage imageNamed:@"emailTextField"];
        _forgetPassWordTextField.clearImage = [UIImage imageNamed:@"clearButton"];
        _forgetPassWordTextField.errorTip = ZFLocalizedString(@"LoginForgotView_Valid_Email",nil);
        _forgetPassWordTextField.errorFontSize = 9.f;
        _forgetPassWordTextField.errorTipColor = [UIColor orangeColor];
        _forgetPassWordTextField.textAlignment = [SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentRight : NSTextAlignmentLeft;
        _forgetPassWordTextField.hidden = YES;
    }
    return _forgetPassWordTextField;
}

- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
        [_okButton setTitle:ZFLocalizedString(@"LoginForgotView_OK",nil) forState:UIControlStateNormal];
        [_okButton setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(okeyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _okButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
        _okButton.layer.cornerRadius = 17.5f;
        _okButton.layer.masksToBounds = YES;
        _okButton.hidden = YES;
    }
    return _okButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitle:ZFLocalizedString(@"LoginForgotView_Cancel",nil) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:ZFCOLOR(0, 0, 0, 1.0) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
        _cancelButton.hidden = YES;
    }
    return _cancelButton;
}

- (CABasicAnimation *)hideAnimation {
    if (!_hideAnimation) {
        _hideAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _hideAnimation.fromValue = @(1);
        _hideAnimation.toValue = @(0);
        _hideAnimation.duration = 0.25;
        _hideAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        _hideAnimation.beginTime = CACurrentMediaTime();
        _hideAnimation.fillMode = kCAFillModeForwards;
        _hideAnimation.removedOnCompletion = NO;
        _hideAnimation.delegate = self;
    }
    return _hideAnimation;
}


@end
