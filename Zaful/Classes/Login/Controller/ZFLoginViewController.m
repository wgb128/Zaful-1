//
//  ZFLoginViewController.m
//  Zaful
//
//  Created by TsangFa on 28/11/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFLoginViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFLoginView.h"
#import "ZFRegisterView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "LoginViewModel.h"
#import "UIView+ZFMBProgressHUD.h"
#import "ZFWebViewViewController.h"

static CGFloat kCornerRadius = 8.0f;

@interface ZFLoginViewController ()<ZFInitViewProtocol, GIDSignInDelegate, GIDSignInUIDelegate>
@property (nonatomic, strong) UIView               *contentView;
@property (nonatomic, strong) ZFLoginView          *loginView;
@property (nonatomic, strong) ZFRegisterView       *registerView;
@property (nonatomic, strong) LoginViewModel       *viewModel;
@property (nonatomic, copy)   NSString             *fbAccessToken;
@end

@implementation ZFLoginViewController
#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.enterType = ZFLoginEnterTypeLogin;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBlurView];
    [self zfInitView];
    [self zfAutoLayoutView];
    //配置Google+登陆
    [self configGoogleplusLoginParams];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *email = [[NSUserDefaults standardUserDefaults] valueForKey:kUserEmail];
    if (email) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowPlaceholderAnimationNotification" object:nil];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - <ZFInitViewProtocol>
- (void)configureBlurView {
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"bg"];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.backgroundColor = [UIColor colorWithRed:(221)/255.0 green:(221)/255.0 blue:221/255.0 alpha:0.65];
    visualEffectView.frame = self.view.bounds;
    [self.view addSubview:visualEffectView];
}

- (void)zfInitView {
    [self.view addSubview:self.contentView];
    if (self.enterType == ZFLoginEnterTypeLogin) {
        [self.contentView addSubview:self.loginView];
    }else{
        [self.contentView addSubview:self.registerView];
    }
}

- (void)zfAutoLayoutView {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(290, 350));
    }];
    
    if (self.enterType == ZFLoginEnterTypeLogin) {
        [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }else{
        [self.registerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
}

#pragma mark - Private mathod
- (void)configGoogleplusLoginParams {
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.delegate = self;
    signIn.uiDelegate = self;
}

- (void)signUpWithEmail:(NSString *)email
               password:(NSString *)password
        confirmPassword:(NSString *)confirmPassword
            isSubscribe:(BOOL)isSubscribe
                    sex:(NSInteger)sex{
    NSDictionary *dict = @{
                           @"email"             : email,
                           @"password"          : password,
                           @"confirmPassword"   : confirmPassword,
                           @"sex"               : [@(sex) stringValue],
                           @"issubscribe"       : [@(isSubscribe) stringValue]
                           };
    [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kStartLoadingSignUp];
    [self.viewModel requestRegisterNetwork:dict completion:^(id obj) {
        [ZFAnalytics appsFlyerTrackEvent:@"af_sign_up" withValues:@{
                                                                    @"content_type" : @"Email"
                                                                    }];
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingSignUp];
        ZFLog(@"注册成功🇨🇳");
        
        if ([AccountManager sharedManager].isSignIn) {
            if (self.successBlock) {
                self.successBlock();
            }
            //登录通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [ZFFireBaseAnalytics signUpWithType:@"general"];
    } failure:^(id obj) {
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingSignUp];
    }];
}

- (void)signInWithEmail:(NSString *)email password:(NSString *)password {
    NSDictionary *dict = @{
                           @"email"     : email,
                           @"password"  : password
                           };
    [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kStartLoadingSignIn];
    [self.viewModel requestLoginNetwork:dict completion:^(id obj) {
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingSignIn];
        
        if ([AccountManager sharedManager].isSignIn) {
            [ZFFireBaseAnalytics signInWithTypeName:@"general"];
            if (self.successBlock) {
                self.successBlock();
            }
            //登录通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(id obj) {
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingSignIn];
    }];
}

- (void)facebookLogin {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorWeb;
    NSArray *permissions = @[@"public_profile", @"email", @"user_likes",@"user_about_me"];
    [login logInWithReadPermissions:permissions fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) { ZFLog(@"FB登录错误❌❌❌"); return; }
        if (result.isCancelled) { ZFLog(@"取消FB登录"); return; }
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, gender, email"} tokenString:[FBSDKAccessToken currentAccessToken].tokenString version:@"v2.5" HTTPMethod:nil];
        self.fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error) { ZFLog(@"FB登录请求错误❌❌"); return; }
            NSString *fbid = [result valueForKey:@"id"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:fbid forKey:@"fbid"];
            [dict setObject:NullFilter(self.fbAccessToken) forKey:@"access_token"];
            [self.viewModel requestFbidCheckNetwork:dict completion:^(id obj) {
                
                [ZFFireBaseAnalytics signInWithTypeName:@"facebook"];
                // fbid验证成功，直接登录
                if ([obj boolValue]) {
                    [login logOut];
                    [self loginSuccess];
                    return;
                }
                // 验证失败，判断email是否为空，为空绑定邮箱，重新注册登录
                NSString *sex = [result valueForKey:@"gender"];
                sex = [sex isEqualToString:@"male"] ? @"0" : @"1";
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@"Facebook" forKey:@"type"];
                [dict setObject:fbid forKey:@"fb_id"];
                [dict setObject:[NSStringUtils isEmptyString:sex] ? @"" : sex forKey:@"sex"];
                [dict setObject:NullFilter(self.fbAccessToken) forKey:@"access_token"];
                NSString *email = [result valueForKey:@"email"];
                
                [ZFFireBaseAnalytics signUpWithType:@"facebook"];
                if (email) { // 取出已有邮箱登录
                    [dict setObject:email forKey:@"email"];
                    [self.viewModel requestFBLoginNetwork:dict completion:^(id obj) {
                        [self loginSuccess];
                    } failure:nil];
                    return;
                }
                // 否则绑定邮箱，重新注册登录
                [self bindEmailWith:dict];
                
            } failure:nil];
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
        }];
    }];
}

- (void)bindEmailWith:(NSMutableDictionary *)dict {
    UIAlertController *alertController =  [UIAlertController
                                           alertControllerWithTitle: ZFLocalizedString(@"confirmEmail", nil)
                                           message:ZFLocalizedString(@"inputEmail", nil)
                                           preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = ZFLocalizedString(@"signPlaceholderEmail", nil);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"cancel",nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"confirm",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *email = alertController.textFields.firstObject.text;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        [dict setObject:email forKey:@"email"];
        [self.viewModel requestFBLoginNetwork:dict completion:^(id obj) {
            [self loginSuccess];
        } failure:^(id obj) {
        }];
    }];
    confirmAction.enabled = NO;
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)forgotPasswordRequestWithEmail:(NSString *)email {
    [self.viewModel requestForgotNetwork:email completion:^(id obj) {
        //发送邮件成功
        NSString *tips = [NSString stringWithFormat:@"%@ %@ %@", ZFLocalizedString(@"LoginForgotView_SuccessView_Descripe",nil), email, ZFLocalizedString(@"LoginForgotView_SuccessView_Descripe2",nil)];
        
        [MBProgressHUD showMessage:tips];
        
    } failure:^(id obj) {
        //发送邮件失败
    }];
}

- (void)loginSuccess {
    if ([AccountManager sharedManager].isSignIn) {
        if (self.successBlock) {
            self.successBlock();
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        NSString *email = alertController.textFields.firstObject.text;
        UIAlertAction *confirmAction = alertController.actions.lastObject;
        confirmAction.enabled = [NSStringUtils isValidEmailString:email];
    }
}

- (void)changeToTargetview:(UIView *)targetView {
    [UIView transitionWithView:self.contentView duration:0.65 options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionCurveLinear animations:^{
        [self.contentView addSubview:targetView];
        [targetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    } completion:^(BOOL finished) {
        [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqual:targetView]) {
                [obj removeFromSuperview];
                obj = nil;
            }
        }];
    }];
}

- (void)jumpToWebVCWithTitle:(NSString *)title url:(NSString *)url{
    ZFWebViewViewController *web = [[ZFWebViewViewController alloc] init];
    web.title = title;
    web.link_url = url;
    [self.navigationController pushViewController:web animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - <GIDSignInDelegate, GIDSignInUIDelegate>
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    if (user != nil) {
        NSDictionary *dict = @{@"email"        : user.profile.email,
                               @"googleId"     : user.userID,
                               @"sex"          : @(UserEnumSexTypePrivacy),
                               @"access_token" : NullFilter(user.authentication.idToken)
                               };
        [self.viewModel requestGoogleLoginNetwork:dict completion:^(id obj) {
            //取得用户信息，后台生成/取得用户信息后，可以直接退出
            //登录通知
            [ZFFireBaseAnalytics signUpWithType:@"google"];
            [ZFFireBaseAnalytics signInWithTypeName:@"google"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.successBlock) {
                    self.successBlock();
                }
                if ([signIn hasAuthInKeychain]) {
                    [signIn signOut];
                }
            }];
        } failure:^(id obj) {
            [self dismissViewControllerAnimated:YES completion:^{
                if ([signIn hasAuthInKeychain]) {
                    [signIn signOut];
                }
            }];
        }];
    }
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        CGRect rect = CGRectMake(0, 0, 290, 350);
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(kCornerRadius, kCornerRadius)];
        CAShapeLayer *shapelayer = [CAShapeLayer layer];
        shapelayer.frame = rect;
        shapelayer.path = bezierPath.CGPath;
        _contentView.layer.mask = shapelayer;
        _contentView.layer.shadowColor = ZFCOLOR(51, 51, 51, 0.5).CGColor;
        _contentView.layer.shadowRadius = 20.0f;
        _contentView.layer.shadowOffset = CGSizeMake(0,5);
        _contentView.layer.shadowOpacity = 0.8;
    }
    return _contentView;
}

- (ZFLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[ZFLoginView alloc] init];
        @weakify(self)
        _loginView.registerButtonCompletionHandler = ^{
            @strongify(self)
            [self changeToTargetview:self.registerView];
        };
        
        _loginView.backButtonCompletionHandler = ^{
             @strongify(self)
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
        _loginView.signInButtonCompletionHandler = ^(NSString *email, NSString *password) {
            @strongify(self);
            [self signInWithEmail:email password:password];
        };
        
        _loginView.forgotPasswordRequestCompletionHandler = ^(NSString *email) {
            @strongify(self);
            [self forgotPasswordRequestWithEmail:email];
        };
        
        _loginView.facebookButtonCompletionHandler = ^{
            @strongify(self);
            [self facebookLogin];
        };
        
        _loginView.googleplusButtonCompletionHandler = ^{
            GIDSignIn *signIn = [GIDSignIn sharedInstance];
            [signIn signIn];
        };
    }
    return _loginView;
}

- (ZFRegisterView *)registerView {
    if (!_registerView) {
        _registerView = [[ZFRegisterView alloc] init];
        @weakify(self)
        _registerView.loginButtonCompletionHandler = ^{
            @strongify(self)
            [self changeToTargetview:self.loginView];
        };
        
        _registerView.backButtonCompletionHandler = ^{
            @strongify(self)
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
        _registerView.registerButtonCompletionHandler = ^(NSString *email, NSString *password, BOOL isSubscribe) {
            @strongify(self);
            [self signUpWithEmail:email password:password confirmPassword:password isSubscribe:isSubscribe sex:0];
        };
        
        _registerView.facebookButtonCompletionHandler = ^{
            @strongify(self);
            [self facebookLogin];
        };
        
        _registerView.googleplusButtonCompletionHandler = ^{
            GIDSignIn *signIn = [GIDSignIn sharedInstance];
            [signIn signIn];
        };
        
        _registerView.webJumpActionCompletionHandler = ^(NSString *title, NSString *url) {
            @strongify(self);
            [self jumpToWebVCWithTitle:title url:url];
        };
        
    }
    return _registerView;
}

- (LoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    return _viewModel;
}

@end
