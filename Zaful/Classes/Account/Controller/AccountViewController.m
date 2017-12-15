//
//  AccountListViewController.m
//  Zaful
//
//  Created by DBP on 17/3/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "AccountViewController.h"
#import "MyOrdersListViewController.h"
#import "MyPointsViewController.h"
#import "CouponViewController.h"
#import "ZFAddressViewController.h"
#import "ChangePasswordViewController.h"
#import "CurrencyViewController.h"
#import "HelpViewController.h"
#import "SettingViewController.h"
#import "AccountHeaderView.h"
#import "AccountFooterView.h"
#import "AccountListViewModel.h"
#import "ZFCartViewController.h"
#import "PYSearchViewController.h"
#import "SearchResultViewController.h"
#import "ZFMessageUsViewController.h"

#ifdef LeandCloudEnabled
#   import <AVOSCloud/AVOSCloud.h>
#endif

@interface AccountViewController ()
@property (nonatomic, strong) AccountListViewModel *viewModel;
@property (nonatomic, strong) AccountHeaderView *headerView;
@property (nonatomic, strong) AccountFooterView *footerView;
@property (nonatomic, assign) BOOL firstEnter;
@property (nonatomic, strong) JSBadgeView *badgeView;

@end

@implementation AccountViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ZFLocalizedString(@"Account_VC_Title",nil);
    [self initView];
}

- (void)initView {
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftSearchBtnClick)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0,24,24)];
    [btn setImage:[UIImage imageNamed:@"bag"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightSearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightSearchBtnClick)];
    [self.badgeView addGestureRecognizer:tapGesture];
    
    self.badgeView.badgeBackgroundColor = BADGE_BACKGROUNDCOLOR;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.headerView = [[AccountHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.delegate = self.viewModel;
    self.headerView.controller = self;
    
    self.footerView = [[AccountFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    self.tableView.tableFooterView = self.footerView;
    
    @weakify(self)
    self.footerView.signOutBlock = ^{
        @strongify(self)
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ZFLocalizedString(@"Account_VC_SignOut_Alert_Message",nil) preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:ZFLocalizedString(@"Account_VC_SignOut_Alert_Yes",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[AccountManager sharedManager] clearUserInfo];
            
            [[AccountManager sharedManager] clearWebCookie];
            
            [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:kCollectionBadgeKey];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kSessionId];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.tabBarController.selectedIndex = TabBarIndexHome;
            
            [self.tableView reloadData];
#ifdef LeandCloudEnabled
            NSInteger user = [[[AccountManager sharedManager] userId] integerValue];
            AVInstallation *currentInstallationLeandcloud = [AVInstallation currentInstallation];
            [currentInstallationLeandcloud setObject:@(user) forKey:@"userId"];
            [currentInstallationLeandcloud setObject:@"YES" forKey:@"promotions"];
            [currentInstallationLeandcloud setObject:@"YES" forKey:@"orderMessages"];
            [currentInstallationLeandcloud setObject:[AppsFlyerTracker sharedTracker].getAppsFlyerUID forKey:@"appsFlyerId"];
            [currentInstallationLeandcloud setObject:[ZFLocalizationString shareLocalizable].nomarLocalizable forKey:@"language"];
            [currentInstallationLeandcloud saveInBackground];
#endif
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutNotification object:nil];
            
            [ZFFireBaseAnalytics selectContentWithItemId:@"Sign Out" itemName:@"SIGN OUT" ContentType:@"Sign Out" itemCategory:@"Button"];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:ZFLocalizedString(@"Account_VC_SignOut_Alert_No",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    };
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 谷歌统计
    if (!self.firstEnter) {
        [ZFAnalytics screenViewQuantityWithScreenName:@"Account"];
    }
    self.firstEnter = YES;
    [self.headerView refreshAcccountHeaderData];
    [self.tableView reloadData];
    [self refreshCollectionBadge];
    
}

- (void)refreshCollectionBadge {
    NSNumber *badgeNum = [[NSUserDefaults standardUserDefaults] valueForKey:kCollectionBadgeKey];
    
    NSString * numberIndex = @"";
    if ([badgeNum integerValue] > 99) {
        numberIndex = @"99+";
    }
    else
        numberIndex = [NSString stringWithFormat:@"%ld",(long)[badgeNum integerValue]];
    
    self.badgeView.badgeText = numberIndex;
    
    if ([self.badgeView.badgeText integerValue] == 0) {
        self.badgeView.hidden = YES;
    }else{
        self.badgeView.hidden = NO;
    }
}

// 初始化表单
- (void)initializeForm {
    // 表单对象
    XLFormDescriptor *form;
    // 表单Section对象
    XLFormSectionDescriptor *section;
    // 表单Row对象
    XLFormRowDescriptor *row;
    
    // 初始化form 顺便带个title
    form = [XLFormDescriptor formDescriptor];
    
    // 第一个Section
    section = [XLFormSectionDescriptor formSection];
    section.headerHeight = 0.1;
    section.footerHeight = 0.1;
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"section1" rowType:XLFormRowDescriptorTypeButton title:ZFLocalizedString(@"Account_Cell_Orders",nil)];
    [row.cellConfig setObject:[UIImage imageNamed:@"orders"] forKey:@"imageView.image"];
    [row.cellConfig setObject:[UIFont systemFontOfSize:14] forKey:@"textLabel.font"];
    row.action.viewControllerClass = [MyOrdersListViewController class];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"section1" rowType:XLFormRowDescriptorTypeButton title:ZFLocalizedString(@"Account_Cell_Points",nil)];
    [row.cellConfig setObject:[UIImage imageNamed:@"dRewards"] forKey:@"imageView.image"];
    [row.cellConfig setObject:[UIFont systemFontOfSize:14] forKey:@"textLabel.font"];
    row.action.viewControllerClass = [MyPointsViewController class];
    [section addFormRow:row];
    
    // 第2个Section
    section = [XLFormSectionDescriptor formSection];
    section.headerHeight = 10;
    section.footerHeight = 0.1;
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"section2" rowType:XLFormRowDescriptorTypeButton title:ZFLocalizedString(@"Account_Cell_Coupon",nil)];
    [row.cellConfig setObject:[UIImage imageNamed:@"coupon"] forKey:@"imageView.image"];
    [row.cellConfig setObject:[UIFont systemFontOfSize:14] forKey:@"textLabel.font"];
    row.action.viewControllerClass = [CouponViewController class];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"section2" rowType:XLFormRowDescriptorTypeButton title:ZFLocalizedString(@"Account_Cell_Address",nil)];
    [row.cellConfig setObject:[UIImage imageNamed:@"address"] forKey:@"imageView.image"];
    [row.cellConfig setObject:[UIFont systemFontOfSize:14] forKey:@"textLabel.font"];
    row.action.viewControllerClass = [ZFAddressViewController class];
    [section addFormRow:row];
    
    // 第3个Section
    section = [XLFormSectionDescriptor formSection];
    section.headerHeight = 10;
    section.footerHeight = 0.1;
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"section3" rowType:XLFormRowDescriptorTypeButton title:ZFLocalizedString(@"Account_Cell_Password",nil)];
    [row.cellConfig setObject:[UIImage imageNamed:@"password"] forKey:@"imageView.image"];
    [row.cellConfig setObject:[UIFont systemFontOfSize:14] forKey:@"textLabel.font"];
    row.action.viewControllerClass = [ChangePasswordViewController class];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"section3" rowType:XLFormRowDescriptorTypeSelectorPush title:ZFLocalizedString(@"Account_Cell_Currency",nil)];
    row.value = [ExchangeManager localCurrency];
    [row.cellConfig setObject:[UIImage imageNamed:@"currency"] forKey:@"imageView.image"];
    [row.cellConfig setObject:[UIFont systemFontOfSize:14] forKey:@"textLabel.font"];
    row.action.viewControllerClass = [CurrencyViewController class];
    [section addFormRow:row];
    
    // 第4个Section
    section = [XLFormSectionDescriptor formSection];
    section.headerHeight = 10;
    section.footerHeight = 0.1;
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"section4" rowType:XLFormRowDescriptorTypeButton title:ZFLocalizedString(@"Account_Cell_Setting",nil)];
    [row.cellConfig setObject:[UIImage imageNamed:@"aboutUs"] forKey:@"imageView.image"];
    [row.cellConfig setObject:[UIFont systemFontOfSize:14] forKey:@"textLabel.font"];
    row.action.viewControllerClass = [SettingViewController class];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"section4" rowType:XLFormRowDescriptorTypeButton title:ZFLocalizedString(@"Account_Cell_Help",nil)];
    [row.cellConfig setObject:[UIImage imageNamed:@"contactUs"] forKey:@"imageView.image"];
    [row.cellConfig setObject:[UIFont systemFontOfSize:14] forKey:@"textLabel.font"];
    row.action.viewControllerClass = [HelpViewController class];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"section4" rowType:XLFormRowDescriptorTypeButton title:ZFLocalizedString(@"Account_Cell_Message_Us",nil)];
    [row.cellConfig setObject:[UIImage imageNamed:@"mine_message_us"] forKey:@"imageView.image"];
    [row.cellConfig setObject:[UIFont systemFontOfSize:14] forKey:@"textLabel.font"];
    row.action.viewControllerClass = [ZFMessageUsViewController class];
    [section addFormRow:row];
    
    self.form = form;
}

- (void)leftSearchBtnClick {
    // 谷歌统计
    [ZFAnalytics clickButtonWithCategory:@"Search" actionName:@"Search" label:@"Search"];
    [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Seach" itemName:@"Seach" ContentType:@"Search" itemCategory:@"Search"];
    
    NSArray *hotwordSearchArray = [[NSUserDefaults standardUserDefaults] valueForKey:KHotwordSearchKey];
    NSString *placeHolder = ZFLocalizedString(@"Search_PlaceHolder_Search",nil);
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotwordSearchArray searchBarPlaceholder:placeHolder didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        SearchResultViewController * searchResult = [[SearchResultViewController alloc]init];
        searchResult.searchString = searchText;
        searchResult.hidesBottomBarWhenPushed = YES;
        [searchViewController.navigationController pushViewController:searchResult animated:YES];
    }];
    [searchViewController.searchBar showCurrentViewBorder:1.0 color:[UIColor lightGrayColor]];
    searchViewController.hotSearchStyle = PYHotSearchStyleBorderTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleBorderTag;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}

- (void)rightSearchBtnClick {
    ZFCartViewController *cartVC = [[ZFCartViewController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
    
    // 统计
    [ZFFireBaseAnalytics selectContentWithItemId:@"Click_bag" itemName:@"Account_bag" ContentType:@"Bag" itemCategory:@"Bag"];
    [ZFAnalytics clickButtonWithCategory:@"bag" actionName:@"Click_bag" label:@"Click_bag"];
}

- (AccountListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[AccountListViewModel alloc] init];
        _viewModel.controller = self;
    }
    return _viewModel;
}

@end
