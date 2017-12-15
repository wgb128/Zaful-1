//
//  CommunityViewController.m
//  Zaful
//
//  Created by huangxieyue on 16/11/24.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "CommunityViewController.h"

#import "PopularViewController.h"
#import "FavesViewController.h"
#import "MyStylePageViewController.h"

#import "MessagesViewController.h"
#import "CommunityViewModel.h"
#import "ZFLoginViewController.h"

@interface CommunityViewController ()

@property (nonatomic, strong) YYAnimatedImageView *leftBarView;

@property (nonatomic, strong) JSBadgeView *badgeView;

@property (nonatomic, strong) CommunityViewModel *viewModel;

@end

@implementation CommunityViewController

- (CommunityViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[CommunityViewModel alloc] init];
    }
    return _viewModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:ZFCOLOR(255, 255, 255, 1)];
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
    
    [self messageCount];
    
}

- (void)messageCount {
    if ([AccountManager sharedManager].isSignIn) {
        [self.viewModel requestNetwork:nil completion:^(id obj) {
            if ([obj integerValue] > 0 && [obj integerValue] < 100) {
                self.badgeView.badgeText = obj;
            }else if ([obj integerValue] > 0 && [obj integerValue] < 100) {
                self.badgeView.badgeText = @"99+";
            } else{
                self.badgeView.badgeText = nil;
            }
        } failure:^(id obj) {
            self.badgeView.badgeText = nil;
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLeftButton];
    [self initRightIconButton];
    //接收登录状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kLoginNotification object:nil];
    //接收登出状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutChangeValue:) name:kLogoutNotification object:nil];
    // 修改用户信息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kChangeUserInfoNotification object:nil];
    // 接收发送完照片刷新Popular数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPopularData:) name:kRefreshPopularNotification object:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *localeLanguageCode = [ZFLocalizationString shareLocalizable].nomarLocalizable;
        
        NSArray *viewControllers = @[[PopularViewController class], [FavesViewController class]];
        NSArray *titles = @[ZFLocalizedString(@"Community_Tab_Title_Popular",nil), ZFLocalizedString(@"Community_Tab_Title_Faves",nil)];
        
        self.viewControllerClasses = viewControllers;
        self.titles = titles;
        
        self.pageAnimatable = YES;
//        self.menuHeight = 40;
        self.showOnNavigationBar = YES;
        self.postNotification = YES;
        self.bounces = YES;
        self.titleSizeNormal = 18;
        self.titleSizeSelected = 19;
        self.menuViewStyle = WMMenuViewStyleSegmented;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        
        self.titleColorSelected = ZFCOLOR_WHITE;
        self.titleColorNormal = ZFCOLOR(51, 51, 51, 1.0);
        self.progressColor = ZFCOLOR(51, 51, 51, 1.0);
//        self.menuBGColor = ZFCOLOR_WHITE;
        if(([localeLanguageCode hasPrefix:@"fr"] || [localeLanguageCode hasPrefix:@"es"]) && SCREEN_WIDTH == 320) {
            self.menuItemWidth = 100 *DSCREEN_WIDTH_SCALE;
        } else {
             self.menuItemWidth = 90 *DSCREEN_WIDTH_SCALE;
        }
        if (![AccountManager sharedManager].isSignIn) {
            self.scrollEnable = NO;
        }
    }
    
    return self;
}

- (BOOL)pageController:(WMPageController *)pageController shouldEnterIndex:(NSInteger)index {
    @weakify(self)
    if (![AccountManager sharedManager].isSignIn) {
        @strongify(self)
        if (index == 1) {
            ZFLoginViewController *signVC = [ZFLoginViewController new];
            ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
            [self.navigationController presentViewController:nav animated:YES completion:^{
            }];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 当前用户头像
- (void)initLeftButton {
    self.leftBarView = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    self.leftBarView.userInteractionEnabled = YES;
    self.leftBarView.layer.cornerRadius = 16.5;
    self.leftBarView.contentMode = UIViewContentModeScaleToFill;
    self.leftBarView.clipsToBounds = YES;
    [self refreshLeftIcon];
    
    UITapGestureRecognizer *tapIconImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myStyleleftTouch:)];
    [self.leftBarView addGestureRecognizer:tapIconImg];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:self.leftBarView];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)initRightIconButton {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0,24,24)];
    [btn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(messagerightTouch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = buttonItem;
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.badgeView = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentTopLeft];
        self.badgeView.badgePositionAdjustment = CGPointMake(0, 0);
    } else {
        self.badgeView = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentTopRight];
        self.badgeView.badgePositionAdjustment = CGPointMake(17, -14);
    }
    self.badgeView.badgeTextFont = [UIFont systemFontOfSize:9];
    self.badgeView.badgeBackgroundColor = BADGE_BACKGROUNDCOLOR;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messagerightTouch:)];
    
    [self.badgeView addGestureRecognizer:tapGesture];
    
}

- (void)refreshLeftIcon {
    [self.leftBarView yy_setImageWithURL:[NSURL URLWithString:[AccountManager sharedManager].account.avatar]
                            processorKey:NSStringFromClass([self class])
                             placeholder:[UIImage imageNamed:@"account"]
                                 options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                               transform:^UIImage *(UIImage *image, NSURL *url) {
                                   return image;
                               }
                              completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                              }];
}


#pragma mark - 右上角点击头像进入My Style主页
- (void)messagerightTouch:(UIButton *)sender {
    if ([AccountManager sharedManager].isSignIn) {
        MessagesViewController *mesVC = [[MessagesViewController alloc]init];
        [self.navigationController pushViewController:mesVC animated:YES];
    }else {
        ZFLoginViewController *signVC = [ZFLoginViewController new];
        @weakify(self)
        signVC.successBlock = ^{
            @strongify(self)
            MessagesViewController *mesVC = [[MessagesViewController alloc]init];
            [self.navigationController pushViewController:mesVC animated:YES];
        };
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
        [self.navigationController presentViewController:nav animated:YES completion:^{
        }];
    }
}

- (void)myStyleleftTouch:(UITapGestureRecognizer*)sender {
    if ([AccountManager sharedManager].isSignIn) {
        MyStylePageViewController *myStyleVC = [MyStylePageViewController new];
        myStyleVC.userid = USERID;
        [self.navigationController pushViewController:myStyleVC animated:YES];
    }else {
        ZFLoginViewController *signVC = [ZFLoginViewController new];
        @weakify(self)
        signVC.successBlock = ^{
            @strongify(self)
            MyStylePageViewController *myStyleVC = [MyStylePageViewController new];
            myStyleVC.userid = USERID;
            [self.navigationController pushViewController:myStyleVC animated:YES];
        };
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
        [self.navigationController presentViewController:nav animated:YES completion:^{
        }];
    }
}

#pragma mark - 接收登录通知
- (void)loginChangeValue:(NSNotification *)nofi {
    self.scrollEnable = YES;
    [self refreshLeftIcon];
    [self messageCount];
}

/*========================================分割线======================================*/

#pragma mark - 接收登出通知
- (void)logoutChangeValue:(NSNotification *)nofi {
    self.scrollEnable = NO;
    self.selectIndex = 0;
    [self refreshLeftIcon];
    self.badgeView.badgeText = nil;
}

/*========================================分割线======================================*/

#pragma mark - 接收发送完照片刷新popular数据通知
- (void)refreshPopularData:(NSNotification *)nofi {
    self.selectIndex = 0;
}

#pragma mark - 清除所有通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
