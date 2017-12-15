//
//  ZFBaseViewController.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/21.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "ZFBaseViewController.h"
#import "ZFLoginViewController.h"

typedef void (^BtnBlock)();
typedef void (^NoNetworkBlock)();

@interface ZFBaseViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, assign)  BOOL isShowTabBar;
@property (nonatomic, strong)  UIView    *againRequestView;

@property (nonatomic, copy) BtnBlock btnBlock;

@property (nonatomic, copy) NoNetworkBlock noNetworkBlock;

@end

@implementation ZFBaseViewController
{
    UIView *emptyView;
    UIView *noDataView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    
    /**
     *  此方法是为了防止控制器的title发生偏移，造成这样的原因是因为返回按钮的文字描述占位
     */
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    
    if ([viewControllerArray containsObject:self]) {
        long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
        UIViewController *previous;
        if (previousViewControllerIndex >= 0) {
            previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
            previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:nil];
        }
    }
   
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;// = 1 白色文字，深色背景时使用
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (ISIOS7)
    {
        self.tabBarController.tabBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

-(void)popToSuperView
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  @param timeSp 时间戳
 *
 *  @return 格式化字符串
 */
- (NSString *)stringWithTimeSp:(NSString *)timeSp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"YYYY-MM-dd  HH:mm:ss"];
    NSDate *comefromTimeSp = [NSDate dateWithTimeIntervalSince1970:timeSp.integerValue];
    return [dateFormatter stringFromDate:comefromTimeSp];
}

/**
 *  @brief 点赞动画
 *
 *  @return
 */
- (CAKeyframeAnimation *)createFavouriteAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.1), @(1.0), @(1.5)];
    animation.keyTimes = @[@(0.0), @(0.5), @(0.8), @(1.0)];
    animation.calculationMode = kCAAnimationLinear;
    return animation;
}

- (void)loginVerifySuccess:(void (^)())success cancelLogin:(void (^)())cancel
{
    
    if ([AccountManager sharedManager].isSignIn)
    {
        if (success)
        {
            success();
        }
    }
    else
    {
        ZFLoginViewController *loginVC = [[ZFLoginViewController alloc] init];
        
        loginVC.successBlock = success;
        
        loginVC.cancelSignBlock = cancel;
        
        ZFNavigationController *navVC = [[ZFNavigationController alloc] initWithRootViewController:loginVC];
        
        navVC.navigationBar.hidden = YES;
        
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
        
    }
}

- (void)loginVerifySuccess:(void (^)())success
{
    if ([AccountManager sharedManager].isSignIn)
    {
        if (success)
        {
            success();
        }
    }
    else
    {
        ZFLoginViewController *loginVC = [[ZFLoginViewController alloc] init];
        
        loginVC.successBlock = success;
        
        ZFNavigationController *navVC = [[ZFNavigationController alloc] initWithRootViewController:loginVC];
        
        navVC.navigationBar.hidden = YES;
        
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
    }
}


// 显示错误时，边框颜色的改变
- (void)showErrorBorderColorWithTextField:(UITextField *)textField {
    textField.layer.borderColor = ZFCOLOR(255, 111, 0, 1.0).CGColor;
}

- (void)showAgainRequest
{
    _againRequestView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_againRequestView setBackgroundColor:ZFCOLOR(245, 245, 245, 1.0)];
    [self.view addSubview:_againRequestView];
    
    UIView * groundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 241)];
    [groundView setCenter:CGPointMake(self.view.center.x, self.view.center.y - 65)];
    [_againRequestView addSubview:groundView];
    
    YYAnimatedImageView * img = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, 0, 80, 117)];
    [img setImage:[UIImage imageNamed:@"wifi"]];
    [groundView addSubview:img];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+20, SCREEN_WIDTH, 55)];
    label.text = ZFLocalizedString(@"Global_NO_NET_404",nil);
    [label setTextColor:[UIColor lightGrayColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setFont:[UIFont systemFontOfSize:14.0f]];
    [groundView addSubview:label];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, CGRectGetMaxY(label.frame)+20, 200, 45)];
    titleLabel.text = ZFLocalizedString(@"Base_VC_ShowAgain_TitleLabel",nil);
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [titleLabel setBackgroundColor:[UIColor blackColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer * gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(againRequest)];
    [titleLabel addGestureRecognizer:gest];
    [groundView addSubview:titleLabel];
}

- (void)hiddenAgainRequest
{
    [_againRequestView removeFromSuperview];
}

- (void)againRequest
{
    
}

#pragma mark - Error HUD
- (BOOL)checkInputTextFieldIsValid:(UITextField *)textField{
    
    BOOL isCheckValid = YES;
    NSString *showHudErrorString = nil;
    if ([NSStringUtils isEmptyString:textField.text]) {
        
        [self showErrorBorderColorWithTextField:textField];
        showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Base_VC_Enter_NickName_Message", nil);
        isCheckValid = NO;
        
    }
    if (!(textField.text.length > 1)) {
        
        [self showErrorBorderColorWithTextField:textField];
        showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Base_VC_Mix_Characters_Tip",nil);
        isCheckValid = NO;
        
    }
    if ((textField.text.length > 35)) {
        
        [self showErrorBorderColorWithTextField:textField];
        showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Base_VC_Max_Characters_Tip",nil);
        isCheckValid = NO;
    }
    
    if (!isCheckValid) {
        [MBProgressHUD showMessage:showHudErrorString];
        
    }
    return isCheckValid;
}



-(void)addBadgeToButton:(UIButton *)button
{
    self.badgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.badgeBtn.layer.cornerRadius = 9;
    self.badgeBtn.clipsToBounds = YES;
    self.badgeBtn.backgroundColor = [UIColor redColor];
    self.badgeBtn.titleLabel.font = [UIFont systemFontOfSize:9.0];
    [self.badgeBtn setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [button addSubview:self.badgeBtn];
    [self.badgeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.offset(0);
        make.top.offset(0);
        make.size.equalTo(@18);
    }];
}

/**
 *  加载no data View
 *  @param view       加载在哪个View
 *  @param imgName    图片名字
 *  @param title      文字
 *  @param name       button名字
 *  @param btnBlock   button 事件
 */

- (void)showNoDataInView:(UIView *)view imageView:(NSString *)imgName titleLabel:(NSString *)title button:(NSString *)name buttonBlock:(void (^)())btnBlock{
    
    /**
     *  防止用户退出登录时,view未加载而导致奔溃.
     */
    if (view == nil) return;
    
    noDataView = [[UIView alloc] initWithFrame:CGRectZero];
    noDataView.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    [view addSubview:noDataView];
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    YYAnimatedImageView *imageView = [YYAnimatedImageView new];
    imageView.image = [UIImage imageNamed:imgName];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [noDataView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(86, 86));
        make.centerX.offset(0);
        if (name == nil) {
            make.centerY.offset(-60);
        }else{
            make.centerY.offset(-80);
        }
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.text = title;
    [noDataView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.top.mas_equalTo(imageView.mas_bottom).offset(15);
    }];
    
    if (name == nil)return;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [button setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    [noDataView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.top.equalTo(titleLabel.mas_bottom).offset(45);
        make.leading.offset(38);
        make.trailing.offset(-38);
        make.height.equalTo(@50);
    }];
    
    self.btnBlock = btnBlock;
}

- (void)buttonClick
{
    if (self.btnBlock) {
        self.btnBlock();
        [noDataView removeFromSuperview];
        noDataView = nil;
    }
}

- (void)showNoNetworkViewInView:(UIView *)view buttonBlock:(void (^)())btnBlock
{
    if (view == nil) return;
    
    emptyView = [[UIView alloc]initWithFrame:CGRectZero];
    emptyView.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    [view addSubview:emptyView];
    
    UIButton *requestBut = [UIButton buttonWithType:UIButtonTypeCustom];
    requestBut.backgroundColor = [UIColor clearColor];
    [requestBut addTarget:self action:@selector(noNetworkClick) forControlEvents:UIControlEventTouchUpInside];
    [emptyView addSubview:requestBut];
    [requestBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    YYAnimatedImageView *emptyImage = [[YYAnimatedImageView alloc]initWithFrame:CGRectZero];
    emptyImage.image = [UIImage imageNamed:@"wifi"];
    [emptyView addSubview:emptyImage];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = ZFLocalizedString(@"Global_EMPTY_TITLE",nil);
    [emptyView addSubview:titleLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    descriptionLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.text = ZFLocalizedString(@"Global_NO_NET_404",nil);
    [emptyView addSubview:descriptionLabel];
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(@(0));
    }];
    
    [emptyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(emptyView.mas_centerX);
        make.centerY.mas_equalTo(emptyView.mas_centerY).offset(-80);//距离Y轴中心向上偏移80.
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(emptyView.mas_centerX);
        make.top.mas_equalTo(emptyImage.mas_bottom).offset(20);
    }];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(emptyView.mas_centerX);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
    }];
    self.noNetworkBlock = btnBlock;
}

- (void)noNetworkClick
{
    if (self.noNetworkBlock) {
        self.noNetworkBlock();
        [emptyView removeFromSuperview];
        emptyView = nil;
    }
}


@end
