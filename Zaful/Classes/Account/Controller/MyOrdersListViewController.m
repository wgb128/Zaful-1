//
//  MyOrdersListViewController.m
//  Yoshop
//
//  Created by Qiu on 16/5/31.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "MyOrdersListViewController.h"
#import "MyOrdersListViewModel.h"
#import "MyOrdersListCell.h"
#import "CartBadgeNumApi.h"
#import "ZFInitViewProtocol.h"
#import "ZFWebViewViewController.h"

@interface MyOrdersListViewController () <ZFInitViewProtocol>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MyOrdersListViewModel *viewModel;
@property (nonatomic, copy) NSString    *linkURL;
@end

@implementation MyOrdersListViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
    [self configureRightButton];
    [self.tableView.mj_header beginRefreshing];
    [self requestCartBadgeNum];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 谷歌统计
    if (!self.firstEnter) {
        [ZFAnalytics screenViewQuantityWithScreenName:@"MyOrderList"];
    }
    self.firstEnter = YES;
}

#pragma mark - private methods
- (void)requestCartBadgeNum {
    CartBadgeNumApi *api = [[CartBadgeNumApi alloc] init];
    
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON ds_integerForKey:@"statusCode"] == 200){
            
            if ([requestJSON ds_stringForKey:@"result"] != nil) {
                
                [[NSUserDefaults standardUserDefaults] setValue:@([requestJSON ds_integerForKey:@"result"]) forKey:kCollectionBadgeKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        
    }];
}

- (void)configureRightButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"contact_us-min"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, buttonItem];
}

#pragma mark - Target action
- (void)rightButtonClick {
    if ([NSStringUtils isBlankString:self.linkURL]) {
        return;
    }
    ZFWebViewViewController *webVC = [[ZFWebViewViewController alloc] init];
    webVC.link_url = self.linkURL;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark -<ZFInitViewProtocol>
- (void)zfInitView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = ZFLocalizedString(@"MyOrders_VC_Title",nil);
    self.view.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    [self.view addSubview:self.tableView];
    
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[MyOrdersListCell class] forCellReuseIdentifier:NSStringFromClass([MyOrdersListCell class])];
        _tableView.dataSource = self.viewModel;
        _tableView.delegate = self.viewModel;
        _tableView.scrollsToTop = YES;
        @weakify(self)
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel requestOrderListNetwork:LoadMore completion:^(NSDictionary *dict) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                self.tableView.mj_footer.hidden = [dict[@"state"] boolValue];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            } failure:^(id obj) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }];
        }];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel requestOrderListNetwork:Refresh completion:^(NSDictionary *dict) {
                [self.tableView reloadData];
                 self.linkURL = dict[@"url"];
                self.tableView.mj_footer.hidden = [dict[@"state"] boolValue];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            } failure:^(id obj) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }];
        }];

    }
    return _tableView;
}

- (MyOrdersListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MyOrdersListViewModel alloc] init];
        _viewModel.controller = self;
        @weakify(self)
        _viewModel.emptyOperationBlock = ^{
            @strongify(self)
            [self.tableView.mj_header beginRefreshing];
        };
        
        _viewModel.refreshOrderListCompletionHandler = ^{
            @strongify(self)
            [self.tableView.mj_header beginRefreshing];
        };
    }
    return _viewModel;
}

@end
