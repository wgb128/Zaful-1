
//
//  HomeViewController.m
//  Zaful
//
//  Created by Y001 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "JSBadgeView.h"
#import "BannerManager.h"
#import "BannerModel.h"
#import "HomeGoodsHeadView.h"
#import "ZFCartViewController.h"
#import "PYSearchViewController.h"
#import "SearchResultViewController.h"
#ifdef LeandCloudEnabled
#import <AVOSCloud/AVOSCloud.h>
#endif

#import "UIView+GestureRecognizer.h"
#import "ZFLoginViewController.h"
#import "ZFStartLoadingViewModel.h"

@interface HomeViewController ()

@property (nonatomic, strong) HomeViewModel *homeViewModel;
@property (nonatomic, strong) JSBadgeView   *badgeView;
@property (nonatomic, copy) NSString *tabType;
@property (nonatomic, strong) ZFStartLoadingViewModel       *startLoadViewModel;
@end

@implementation HomeViewController

#pragma mark - Life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kLoginNotification object:nil];
        
        // 汇率改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurrency) name:kCurrencyNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self changeUserLoginState];
    [self setNavagationBar];
    [self addHeaderFooterView];
    [self downloadStartLoadingInfo];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *initializeDict = [defaults objectForKey:kInitialize];
    /*这里应该使用后台返回的数据进行判断，是否开启应用更新提示*/
    if (initializeDict != nil && [initializeDict[@"status"] boolValue]) {
        [self showUpdateInfo];
    }
    if (!isFormalhost) {  // 测试环境
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        lbl.backgroundColor = isTrunkHost ? [UIColor greenColor] : ZFCOLOR(0, 0, 255, 1.0);
        lbl.layer.cornerRadius = 4;
        lbl.clipsToBounds = YES;
        [self.navigationItem.titleView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 8));
            make.center.equalTo(self.navigationItem.titleView);
        }];
    }
    
    if (preRelease && isFormalhost) {  // 预发布环境
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        lbl.backgroundColor = [UIColor orangeColor];
        lbl.layer.cornerRadius = 4;
        lbl.clipsToBounds = YES;
        [self.navigationItem.titleView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 8));
            make.center.equalTo(self.navigationItem.titleView);
        }];
    }
    
#ifdef DEBUG
    self.navigationItem.titleView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLocalHost)];
    [self.navigationItem.titleView addGestureRecognizer:tap];
#endif
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self refreshCollectionBadge];
    [ZFAnalytics screenViewQuantityWithScreenName:@"Home"];
}


#pragma mark - Private method
- (void)downloadStartLoadingInfo {
    //判断设备 1， 2 ， 3， 4， 5

    NSString *kind = @"";
    if (IPHONE_4X_3_5) {
        kind = @"1";
    } else if (IPHONE_5X_4_0) {
        kind = @"2";
    } else if (IPHONE_6X_4_7) {
        kind = @"3";
    } else if (IPHONE_6P_5_5 || IPHONE_7P_5_5) {
        kind = @"4";
    } else if (IPHONE_X_5_15) {
        kind = @"5";
    }
    [self.startLoadViewModel requestNetwork:kind completion:^(id obj) {
        
    } failure:^(id obj) {
        
    }];
}

- (void)changeCurrency {
    [self.collectionView reloadData];
}

- (void)userLogin {
    [self refreshCollectionBadge];
}

- (void)refreshCollectionBadge {
    NSNumber *badgeNum = [[NSUserDefaults standardUserDefaults] valueForKey:kCollectionBadgeKey];
    NSString * numberIndex = @"";
    if ([badgeNum integerValue] == 0) {
        self.badgeView.badgeText = nil;
        return;
    }
    if ([badgeNum integerValue]>99) {
        numberIndex = @"99+";
    } else {
        numberIndex = [NSString stringWithFormat:@"%ld",(long)[badgeNum integerValue]];
    }
    self.badgeView.badgeText = numberIndex;
}

- (void)showUpdateInfo {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", @"https://itunes.apple.com/lookup?id=", kCfgAppId];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSError *error;
        NSDictionary *appInfoDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        if (error) {
            ZFLog(@"%@", error.description);
            return;
        }
        
        NSArray *resultArray = [appInfoDict objectForKey:@"results"];
        if (![resultArray count]) {
            ZFLog(@"error : resultArray == nil");
            return;
        }
        
        //获取服务器上应用的最新版本号
        NSString * versionStr =[[[appInfoDict objectForKey:@"results"]objectAtIndex:0]valueForKey:@"version"];
        NSString *trackName = [NSString stringWithFormat:@"%@ %@",ZFLocalizedString(@"SettingViewModel_Version_Alert_Title", nil),versionStr];
        
        //获取当前设备中应用的版本号
        //判断两个版本是否相同
        if (![versionStr isEqualToString:ZFSYSTEM_VERSION]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController =  [UIAlertController
                                                       alertControllerWithTitle:trackName
                                                       message:ZFLocalizedString(@"SettingViewModel_Version_Alert_Message",nil)
                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:ZFLocalizedString(@"SettingViewModel_Version_Alert_NotNow",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                }];
                UIAlertAction *updata = [UIAlertAction actionWithTitle:ZFLocalizedString(@"SettingViewModel_Version_Alert_Update",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/zaful/id%@?l=zh&ls=1&mt=8",kCfgAppId]];
                    [[UIApplication sharedApplication] openURL:url];
                }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:updata];
                [self presentViewController:alertController animated:YES completion:nil];
                
            });
        }
    });
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
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
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

- (void)setNavagationBar{
    
    [self.navigationItem setTitleView:[[YYAnimatedImageView alloc]initWithImage:[UIImage imageNamed:@"zaful"]]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0,24,24)];
    [btn setImage:[UIImage imageNamed:@"bag"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cartIconClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, buttonItem];
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.badgeView = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentTopLeft];
        self.badgeView.badgePositionAdjustment = CGPointMake(0, 5);
    } else {
        self.badgeView = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentTopRight];
        self.badgeView.badgePositionAdjustment = CGPointMake(15, -8);
    }
    
    self.badgeView.badgeBackgroundColor = BADGE_BACKGROUNDCOLOR;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cartIconClick)];
    [self.badgeView addGestureRecognizer:tapGesture];
}

- (void)addHeaderFooterView {
    @weakify(self)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 谷歌统计
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kStartLoadingHomeContent];
        @strongify(self)
        @weakify(self)
        [self.homeViewModel requestNetwork:@[Refresh] completion:^(id obj) {
            @strongify(self)
            // 谷歌统计
            [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingHomeContent];
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
            self.collectionView.mj_footer.hidden = NO;
            
            [MBProgressHUD hideHUD];
            [self hiddenAgainRequest];
            
        } failure:^(id obj) {
            @strongify(self)
            // 谷歌统计
            [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingHomeContent];
            [MBProgressHUD hideHUD];
            NSInteger count =((NSMutableArray *)obj).count;
            if (count == 0) {
                [self showAgainRequest];
            }
            
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
        }];
    }];
    
    self.collectionView.mj_header = header;
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)againRequest {
    [self hiddenAgainRequest];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)changeUserLoginState {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *initializeDict = [defaults objectForKey:kInitialize];
    
    if (initializeDict != nil && ![NSStringUtils isEmptyString:initializeDict[@"login_expired"]]) {
        if ([initializeDict[@"login_expired"] integerValue] == 1) { // 1 代表token失效,需要重新登录
            [[AccountManager sharedManager] clearUserInfo];
            
            ZFLoginViewController *loginVC = [[ZFLoginViewController alloc] init];
            @weakify(self)
            loginVC.successBlock = ^{
                 @strongify(self)
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            };
            
            loginVC.cancelSignBlock = ^{
                 @strongify(self)
                 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            };
            
            ZFNavigationController *navVC = [[ZFNavigationController alloc] initWithRootViewController:loginVC];
            
            navVC.navigationBar.hidden = YES;
            
            [self.navigationController presentViewController:navVC animated:YES completion:nil];
            
        }
    }

}

#pragma mark - Action
- (void)cartIconClick {
    ZFCartViewController *cartVC = [[ZFCartViewController alloc] init];
    
    [self.navigationController pushViewController:cartVC animated:YES];
}

- (void)searchClick {
    // 谷歌统计
    [ZFAnalytics clickButtonWithCategory:@"Home" actionName:@"Home - Search" label:@"Home - Search icon"];
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
    [self presentViewController:nav  animated:NO completion:nil];
}

#pragma mark- getter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self.homeViewModel;
        _collectionView.delegate = self.homeViewModel;
//        _collectionView.emptyDataSetDelegate = self.homeViewModel;
//        _collectionView.emptyDataSetSource = self.homeViewModel;
        _collectionView.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
        _collectionView.scrollsToTop = YES;
        [_collectionView registerClass:[HomeGoodsHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HomeGoodsHeadView class])];
        [self.view addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _collectionView;
}

- (HomeViewModel *) homeViewModel {
    if (_homeViewModel == nil) {
        _homeViewModel = [[HomeViewModel alloc]init];
        _homeViewModel.collectionView = self.collectionView;
        _homeViewModel.viewController = self;
    }
    return _homeViewModel;
    
}

- (ZFStartLoadingViewModel *)startLoadViewModel {
    if (!_startLoadViewModel) {
        _startLoadViewModel = [[ZFStartLoadingViewModel alloc] init];
    }
    return _startLoadViewModel;
}
@end
