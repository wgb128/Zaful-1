


//
//  ZFHomePageViewController.m
//  Zaful
//
//  Created by QianHan on 2017/10/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomePageViewController.h"
#import "ZFHomeChannelViewController.h"
#import "ZFCartViewController.h"
#import "PYSearchViewController.h"
#import "SearchResultViewController.h"
#import "ZFGoodsDetailViewController.h"
#import "CategoryVirtualViewController.h"
#import "ZFCommunityAccountViewController.h"
#import "HomeViewController.h"

#import <AVOSCloud/AVOSCloud.h>

#import "ZFHomePageNavigationBar.h"
#import "ZFHomePageMenuListView.h"
#import "ZFHomeFloatingView.h"

#import "ZFHomePageMenuViewModel.h"

#import "WMPanGestureRecognizer.h"
#import "AppDelegate.h"

static CGFloat const kTabMenuHeight       = 44.0f;
static CGFloat const kWMHeaderViewHeight  = 44.0;    // ZFHomePageNavigationBar
#define kNavigationBarHeight (IPHONE_X_5_15 ? 44.0f : 20.0f)
@interface ZFHomePageViewController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) WMPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) CGFloat viewTop;

@property (nonatomic, strong) ZFHomePageMenuViewModel *pageMenuViewModel;
@property (nonatomic, strong) ZFHomePageNavigationBar *homePageNavigationBar;
@property (nonatomic, strong) ZFHomePageMenuListView  *menuListView;
@property (nonatomic, strong) UIView                  *separetorView;
@property (nonatomic, strong) UIButton                *menuExpansionButton;
@property (nonatomic, strong) CAGradientLayer         *menuGradientLayer;
@property (nonatomic, strong) UIView *blankView;
@property (nonatomic, assign) BOOL isLoadFloatView;
@property (nonatomic, assign) BOOL isFirstLoad;

@property (nonatomic, strong) ZFHomeFloatingView *homeFloatingView;

@end

@implementation ZFHomePageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.titleSizeNormal    = 16.0f;
        self.titleSizeSelected  = 16.0f;
        self.menuViewStyle      = WMMenuViewStyleLine;
        self.itemMargin         = 20.0f;
        self.titleColorSelected = ZFCOLOR(183, 96, 42, 1.0);
        self.titleColorNormal   = ZFCOLOR(51, 51, 51, 1.0);
        self.progressColor      = ZFCOLOR(183, 96, 42, 1.0);
        self.progressHeight     = 3.0f;
        self.automaticallyCalculatesItemWidths = YES;
        self.viewTop = kNavigationBarHeight + kWMHeaderViewHeight;
        self.isLoadFloatView    = NO;
        self.isFirstLoad        = YES;
        
        self.pageMenuViewModel  = [[ZFHomePageMenuViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self addGestures];
    [self homePageNavigationBarActions];
    
    if (self.pageMenuViewModel.tabMenuModels.count == 0) {
        [self.view addSubview:self.blankView];
        [self.blankView zf_showRequestBlankViewWithAction:^(NSInteger index) {
            [self requestTabMenus];
        }];
    } else {
        [self initChannelMenu:NO];
    }
    
    [self addNotificatetion];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    [self.homePageNavigationBar setBagValues];
    
    static BOOL firstLoadFloatView = YES;
    if (firstLoadFloatView && self.isLoadFloatView) {
        self.isLoadFloatView = NO;
        [self.homeFloatingView show];
    }
}

#pragma mark - initView
- (void)setupView {
    [self addSeparetorView];
    [self.view addSubview:self.homePageNavigationBar];
}

- (void)addGestures {
    self.panGesture = [[WMPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnView:)];
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)addMenuListView {
    self.menuListView = [[ZFHomePageMenuListView alloc] initWithMenuTitles:[self.pageMenuViewModel tabMenuTitles] selectedIndex:self.selectIndex];
    __weak ZFHomePageViewController *weakSelf = self;
    self.menuListView.selectedMenuIndex = ^(NSInteger index) {
        [weakSelf menuExpansionAction];
        weakSelf.selectIndex = (int)index;
    };
    
    self.menuListView.tabHiddenHandle = ^{
        [weakSelf menuExpansionAction];
    };
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.menuView.leftView  = self.menuExpansionButton;
    } else {
        self.menuView.rightView = self.menuExpansionButton;
    }
    [self addMenuGradientLayer];
}

- (void)addMenuGradientLayer {
    
    self.menuGradientLayer = [[CAGradientLayer alloc] init];
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.menuGradientLayer.colors = @[(__bridge id)ZFCOLOR(255.0, 255.0, 255.0, 1.0).CGColor, (__bridge id)ZFCOLOR(255.0, 255.0, 255.0, 0.0).CGColor];
        self.menuGradientLayer.frame = CGRectMake(self.menuExpansionButton.width, 0.0, 24.0, self.menuExpansionButton.height);
    } else {
        self.menuGradientLayer.colors = @[(__bridge id)ZFCOLOR(255.0, 255.0, 255.0, 0.0).CGColor, (__bridge id)ZFCOLOR(255.0, 255.0, 255.0, 1.0).CGColor];
        self.menuGradientLayer.frame = CGRectMake(-24.0, 0.0, 24.0, self.menuExpansionButton.height);
    }
    self.menuGradientLayer.startPoint = CGPointMake(0, 0);
    self.menuGradientLayer.endPoint   = CGPointMake(1, 0);
    [self.menuExpansionButton.layer addSublayer:self.menuGradientLayer];
}
    
#pragma mark - Notification
- (void)addNotificatetion {
    // 浮窗显示时机
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFloatViewNotice:) name:kHomeFloatingViewShowNotice object:nil];
    // 隐藏导航栏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNavBar) name:kHomeHideNavbarNotice object:nil];
}

#pragma mark - request
- (void)requestTabMenus {
    
    [self.blankView removeFromSuperview];
    _blankView = nil;
    
    if ([NoNetworkReachabilityManager shareManager].networkStatus == AFNetworkReachabilityStatusNotReachable) {
        [self.view addSubview:self.blankView];
        [self.blankView zf_showNetworkBlankViewWithAction:^(NSInteger index) {
            [self requestTabMenus];
        }];
        return;
    }

    self.pageMenuViewModel = [[ZFHomePageMenuViewModel alloc] init];
    [self.pageMenuViewModel requestHomePageMenuWithParam:nil completeHandler:^{

        if (!self.pageMenuViewModel.isSuccess) {
            if ([self.pageMenuViewModel.message length] > 0) {
                [MBProgressHUD showMessage:self.pageMenuViewModel.message];
            } else {
                if (self.pageMenuViewModel.tabMenuModels.count <= 0) {
                    [self.view addSubview:self.blankView];
                    [self.blankView zf_showRequestBlankViewWithAction:^(NSInteger index) {
                        [self requestTabMenus];
                    }];
                }
            }
            return;
        }

        if (self.pageMenuViewModel.tabMenuModels.count > 0) {
            [self initChannelMenu:YES];
        } else {
            [self.view addSubview:self.blankView];
            [self.blankView zf_showRequestBlankViewWithAction:^(NSInteger index) {
                [self requestTabMenus];
            }];
        }
    }];
}

#pragma mark - event
- (void)hideNavBar {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

// navigationBarAction
- (void)homePageNavigationBarActions {
    __weak ZFHomePageViewController *weakSelf = self;
    // 搜索
    self.homePageNavigationBar.searchActionHandle = ^{
        [weakSelf.menuListView hidden];
        // 谷歌统计
        [ZFAnalytics clickButtonWithCategory:@"Home" actionName:@"Home - Search" label:@"Home - Search icon"];
        [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Seach" itemName:@"Seach" ContentType:@"Search" itemCategory:@"Search"];
        
        NSArray *hotwordSearchArray = [[NSUserDefaults standardUserDefaults] valueForKey:KHotwordSearchKey];
        NSString *placeHolder = ZFLocalizedString(@"Search_PlaceHolder_Search",nil);
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotwordSearchArray searchBarPlaceholder:placeHolder didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            SearchResultViewController * searchResult = [[SearchResultViewController alloc]init];
            searchResult.searchString = searchText;
            searchResult.hidesBottomBarWhenPushed = YES;
            [searchViewController.navigationController pushViewController:searchResult animated:YES];
            // 谷歌统计
            [ZFAnalytics clickButtonWithCategory:@"Search" actionName:@"Search keyword" label:searchText];
        }];
        [searchViewController.searchBar showCurrentViewBorder:1.0 color:[UIColor lightGrayColor]];
        searchViewController.hotSearchStyle = PYHotSearchStyleBorderTag;
        searchViewController.searchHistoryStyle = PYSearchHistoryStyleBorderTag;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
        [weakSelf presentViewController:nav  animated:NO completion:nil];
    };
    
    // 购物车
    self.homePageNavigationBar.bagActionHandle = ^{
        [weakSelf.menuListView hidden];
        ZFCartViewController *cartVC = [[ZFCartViewController alloc] init];
        [weakSelf.navigationController pushViewController:cartVC animated:YES];
        
        // 统计
        [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Bag" itemName:@"home - bag" ContentType:@"Bag" itemCategory:@"Bag"];
        [ZFAnalytics clickButtonWithCategory:@"bag" actionName:@"Click_bag" label:@"Click_bag"];
    };
    
    // 切换环境
    self.homePageNavigationBar.changeLocalHostHandle = ^{
        [weakSelf.menuListView hidden];
        [weakSelf changeLocalHost];
    };
}

- (void)panOnView:(WMPanGestureRecognizer *)recognizer {
    if (self.pageMenuViewModel.tabMenuModels.count <= 0) {
        return;
    }
    
    CGPoint currentPoint = [recognizer locationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.lastPoint = currentPoint;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat targetPoint = velocity.y < 0 ? kNavigationBarHeight : kNavigationBarHeight + kWMHeaderViewHeight;
        NSTimeInterval duration = fabs((targetPoint - self.viewTop) / velocity.y);
        
        if (fabs(velocity.y) * 1.0 > fabs(targetPoint - self.viewTop)) {
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.viewTop = targetPoint;
            } completion:nil];
            return;
        }
    }
    CGFloat yChange = currentPoint.y - self.lastPoint.y;
    if ((yChange > 0.0f && self.viewTop != 64.0f)
        || (yChange < 0.0f && self.viewTop != 20.0f)) {
        self.viewTop += yChange;
    }
//    ZFLog(@"######## %f %f", yChange, self.viewTop);
    self.lastPoint = currentPoint;
}

- (void)menuExpansionAction {
    
    [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Channel_Fast_Menu" itemName:@"Fast_Menu" ContentType:@"Channel - Menu" itemCategory:@"Button"];
    self.menuExpansionButton.selected = !self.menuExpansionButton.selected;
    self.panGesture.enabled = !self.menuExpansionButton.selected;
    if (self.menuExpansionButton.isSelected) {
        [self showMenus];
    } else {
        [self hiddenMenus];
    }
}

- (void)showFloatViewNotice:(NSNotification *)note {
    
    BannerModel *floatModel = [note object];
    if (floatModel) {
        
        self.isLoadFloatView = YES;
        self.homeFloatingView = [[ZFHomeFloatingView alloc] initWithModel:floatModel];
        @weakify(self)
        self.homeFloatingView.tapActionHandle = ^{
            @strongify(self)
            [ZFAnalytics clickButtonWithCategory:@"Home" actionName:@"HomeFloatingWindow Banner" label:@"HomeFloatingWindow Banner"];
            [ZFFireBaseAnalytics selectContentWithItemId:@"HomeFloatingWindow" itemName:@"HomeFloatingWindow" ContentType:@"Home - Banner" itemCategory:@"Banner"];
            [BannerManager doBannerActionTarget:self withBannerModel:floatModel];
        };
        
        id currentViewController = [self getCurrentVC];
        if ([currentViewController isKindOfClass:[ZFHomePageViewController class]]
            || [currentViewController isKindOfClass:[HomeViewController class]]) {
            
            [self.homeFloatingView show];
            self.isLoadFloatView = NO;
        }
    }
}

#pragma mark - delegate / datasource
#pragma mark -WMPageControllerDelegate / WMPageControllerDatasource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.pageMenuViewModel.tabMenuModels.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    ZFHomePageMenuModel *model = self.pageMenuViewModel.tabMenuModels[index];
    return model.tabTitle;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    ZFHomePageMenuModel *menuModel = self.pageMenuViewModel.tabMenuModels[index];
    if ([menuModel.jumpType length] > 0) {
        CategoryVirtualViewController *categoryVirtualViewController = [[CategoryVirtualViewController alloc] initInHome];
        categoryVirtualViewController.virtualType = menuModel.jumpType;
        return categoryVirtualViewController;
    } else {
        if (menuModel.tabType == -1) {
            HomeViewController *homeViewController = [[HomeViewController alloc] init];
            homeViewController.title = menuModel.tabTitle;
            return homeViewController;
        }
        ZFHomeChannelViewController *homeChannelViewController = [[ZFHomeChannelViewController alloc] init];
        homeChannelViewController.title = menuModel.tabTitle;
        return homeChannelViewController;
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = ZFCOLOR_WHITE;
    if (self.pageMenuViewModel.tabMenuTitles.count == 1) {
        return CGRectMake(0, _viewTop, KScreenWidth, 0.0);
    }
    return CGRectMake(0, _viewTop, KScreenWidth, kTabMenuHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGFloat originY;
    if (self.pageMenuViewModel.tabMenuTitles.count == 1) {
        originY = _viewTop + 0.0;
    } else {
        originY = _viewTop + kTabMenuHeight;
    }
    return CGRectMake(0, originY, KScreenWidth, KScreenHeight - originY - delegate.tabBarVC.tabBar.height);
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    self.menuListView.selectedIndex = self.selectIndex;
    // 防止启动页deeplink隐藏问题
    if (!self.isFirstLoad) {
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    self.isFirstLoad = NO;
    
    // firebase 点击统计
    ZFHomePageMenuModel *model = self.pageMenuViewModel.tabMenuModels[self.selectIndex];
    NSString *itemId = [NSString stringWithFormat:@"Click_Home_Channel_%@", model.tabTitle];
    [ZFFireBaseAnalytics selectContentWithItemId:itemId itemName:model.tabTitle ContentType:@"Home - Channel" itemCategory:@"channel"];
    [ZFAnalytics clickButtonWithCategory:@"channel" actionName:itemId label:itemId];
}

#pragma mark -UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    
    if (self.navigationController.viewControllers.count <= 2) {
        
        if ([viewController isKindOfClass:ZFGoodsDetailViewController.class]
            || [viewController isKindOfClass:ZFCommunityAccountViewController.class]) {
            return;
        }
        
        BOOL isHiddenNavigationBar = self.navigationController.viewControllers.count == 1;
        [self.navigationController setNavigationBarHidden:isHiddenNavigationBar animated:YES];
    }
}

#pragma mark - private method
- (void)initChannelMenu:(BOOL)isRequest {
    // 传值，界面刷新
    self.keys   = [self.pageMenuViewModel keys].mutableCopy;
    self.values = [self.pageMenuViewModel values].mutableCopy;
    
    [self reloadData];
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.selectIndex = (int)self.pageMenuViewModel.tabMenuTitles.count - 1;
        if (isRequest) {
            [self.menuView.scrollView setContentOffset:CGPointMake(44.0, 0.0)];
        } else {
            [self.menuView.scrollView setContentOffset:CGPointMake(self.menuView.scrollView.contentSize.width - self.menuView.scrollView.width + 44.0, 0.0)];
        }
    }
    
    // 可滑动才会显示
    if (self.menuView.scrollView.contentSize.width > self.menuView.width) {
        // 快捷列表
        [self addMenuListView];
    }
    [self addSeparetorView];
}

- (void)changeLocalHost {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ChangeLocalHost" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Production" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [ud setInteger:1 forKey:DebugConfigKey];
        [ud setInteger:0  forKey:PreConfigKey];
        [ud setInteger:0 forKey:TrunkConfigKey];
        [ud synchronize];
        [self logOut];
        [self logOutApplication];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Trunk" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [ud setInteger:0 forKey:DebugConfigKey];
        [ud setInteger:0  forKey:PreConfigKey];
        [ud setInteger:1 forKey:TrunkConfigKey];
        [ud synchronize];
        [self logOut];
        [self logOutApplication];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Prerelease" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [ud setInteger:1  forKey:DebugConfigKey];
        [ud setInteger:1  forKey:PreConfigKey];
        [ud setInteger:0 forKey:TrunkConfigKey];
        [ud synchronize];
        [self logOut];
        [self logOutApplication];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Develop" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [ud setInteger:0  forKey:DebugConfigKey];
        [ud setInteger:0  forKey:PreConfigKey];
        [ud setInteger:0 forKey:TrunkConfigKey];
        [ud synchronize];
        [self logOut];
        [self logOutApplication];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)logOut {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
#ifdef LeandCloudEnabled
        AVInstallation *currentInstallationLeandcloud = [AVInstallation currentInstallation];
        [currentInstallationLeandcloud setObject:USERID forKey:@"userId"];
        [currentInstallationLeandcloud saveInBackground];
#endif
    });
    [[AccountManager sharedManager] clearUserInfo];
}

- (void)logOutApplication {
    [UIView animateWithDuration:0.4f animations:^{
        WINDOW.alpha = 0;
        CGFloat y = WINDOW.bounds.size.height;
        CGFloat x = WINDOW.bounds.size.width / 2;
        WINDOW.frame = CGRectMake(x, y, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

- (void)showMenus {
    [self.menuListView showWithOffsetY:self.menuView.y + self.menuView.height];
    [UIView animateWithDuration:0.25 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        [self.menuExpansionButton.imageView setTransform:transform];
    }];
}

- (void)hiddenMenus {
    [self.menuListView hidden];
    [UIView animateWithDuration:0.25 animations:^{
        CGAffineTransform transform = CGAffineTransformIdentity;
        [self.menuExpansionButton.imageView setTransform:transform];
    }];
}

- (void)addSeparetorView {
    [self.separetorView removeFromSuperview];
    [self.menuView addSubview:self.separetorView];
    [self.menuView bringSubviewToFront:self.separetorView];
    self.separetorView.hidden = self.pageMenuViewModel.tabMenuTitles.count == 1;
}

- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

#pragma mark - getter/setter
- (ZFHomePageNavigationBar *)homePageNavigationBar {
    if (!_homePageNavigationBar) {
        _homePageNavigationBar = [[ZFHomePageNavigationBar alloc] init];
    }
    return _homePageNavigationBar;
}

- (UIView *)separetorView {
    if (!_separetorView) {
        
        _separetorView = [[UIView alloc] init];
        _separetorView.frame = CGRectMake(0.0, kTabMenuHeight - 1.0, self.view.width, 1.0);
        _separetorView.backgroundColor = [UIColor colorWithRed:221.0 / 255.0
                                                         green:221.0 / 255.0
                                                          blue:221.0 / 255.0
                                                         alpha:1.0];
    }
    return _separetorView;
}

- (UIButton *)menuExpansionButton {
    if (!_menuExpansionButton) {
        _menuExpansionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuExpansionButton.frame = CGRectMake(0.0, 0.0, kTabMenuHeight, kTabMenuHeight);
        _menuExpansionButton.backgroundColor =  [UIColor clearColor];
        if ([SystemConfigUtils isRightToLeftShow]) {
            _menuExpansionButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 3.0f, 0.0, -3.0f);
        } else {
            _menuExpansionButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -3.0f, 0.0, 3.0f);
        }
        [_menuExpansionButton setImage:[UIImage imageNamed:@"cart_unavailable_arrow_down"] forState:UIControlStateNormal];
        [_menuExpansionButton addTarget:self action:@selector(menuExpansionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuExpansionButton;
}

- (UIView *)blankView {
    if (!_blankView) {
        CGFloat offsetY = self.homePageNavigationBar.y + self.homePageNavigationBar.height;
        _blankView = [[UIView alloc] init];
        _blankView.frame = CGRectMake(0.0, offsetY, self.view.width, self.view.height - offsetY);
        _blankView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _blankView;
}

- (void)setViewTop:(CGFloat)viewTop {
    _viewTop = viewTop;
    
    if (_viewTop <= kNavigationBarHeight) {
        _viewTop = kNavigationBarHeight;
    }
    
    if (_viewTop > kWMHeaderViewHeight + kNavigationBarHeight) {
        _viewTop = kWMHeaderViewHeight + kNavigationBarHeight;
    }
    
    self.homePageNavigationBar.frame = ({
        CGRect oriFrame = self.homePageNavigationBar.frame;
        oriFrame.origin.y = _viewTop - kWMHeaderViewHeight;
        oriFrame;
    });
    CGFloat alpha = 0.0;
    if (IPHONE_X_5_15) {
        alpha = (_viewTop + self.homePageNavigationBar.y - kNavigationBarHeight) / (kWMHeaderViewHeight);
    } else {
        alpha = (_viewTop + self.homePageNavigationBar.y) / (kWMHeaderViewHeight);
    }
    [self.homePageNavigationBar subViewWithAlpa:alpha];
    
    [self forceLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
