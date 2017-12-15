//
//  FollowViewController.m
//  Buyyer
//
//  Created by Stone on 16/7/11.
//  Copyright © 2016年 Globalegrow. All rights reserved.
//

#import "FollowViewController.h"
#import "Masonry.h"
#import "FollowViewModel.h"

@interface FollowViewController () 

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FollowViewModel *viewModel;

@end

@implementation FollowViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin:) name:kLoginNotification object:nil];
    [self initUI];
    [self requestData];
}

#pragma mark - UI
- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = YES;
    self.tableView.rowHeight = 59;
    self.tableView.dataSource = self.viewModel;
    self.tableView.delegate = self.viewModel;
    self.tableView.emptyDataSetDelegate = self.viewModel;
    self.tableView.emptyDataSetSource = self.viewModel;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)requestData
{
    @weakify(self)
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.viewModel requestNetwork:LoadMore completion:^(id obj) {
            @strongify(self)
            [self.tableView reloadData];
            
            if([obj isEqual: NoMoreToLoad]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.tableView.mj_footer.hidden = YES;
                }];
                
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
            
        } failure:^(id obj) {
            @strongify(self)
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.viewModel requestNetwork:Refresh completion:^(id obj) {
            @strongify(self)
            [self.tableView reloadData];
            /**
             *  备注此处，两种思路
             一、是改变不显示 no more Data MJRefreshAutoFooterNoMoreDataText
             二、是 直接隐藏 mj_footer
             */
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                // 此处是对应 mj_footer.state == 不能加载更多后的重置
//                [self.tableView.mj_footer resetNoMoreData];
                self.tableView.mj_footer.hidden = NO;
            }
            /**
             *    另外 刷新的时候不足一页的情况，是否判断需要footer 
                  也可以有两种方式 numberOfRow 处 和此处的判断, 当count = pageSize -5后就可以删除下面啦
                  用 numberOfRow有一个好处，就是网络失败的时候，自动隐藏 footer 否则会显现出来
             */
            if ([obj isEqual: NoMoreToLoad]) {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.hidden = YES;
            }
 
            [self.tableView.mj_header endRefreshing];
        } failure:^(id obj) {
            @strongify(self)
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (FollowViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[FollowViewModel alloc] init];
        _viewModel.controller = self;
        _viewModel.tableView  = self.tableView;
        if (_userListType == ZFUserListTypeLike) {
            _viewModel.rid = _rid;
        }
        _viewModel.userId = _userId;
        _viewModel.userListType = _userListType;
        @weakify(self)
        _viewModel.emptyOperationBlock = ^{
            @strongify(self)
            [self.tableView.mj_header beginRefreshing];
        };
    }
    return _viewModel;
}

- (void)setUserListType:(ZFUserListType)userListType
{
    _userListType = userListType;
    switch (userListType) {
        case ZFUserListTypeLike:
        {
            self.title = ZFLocalizedString(@"Follow_VC_Title_LikedBy",nil);
        }
            break;
        case ZFUserListTypeFollowing:
        {
            self.title = ZFLocalizedString(@"Follow_VC_Title_Following",nil);
        }
            break;
        case ZFUserListTypeFollowed:
        {
            self.title = ZFLocalizedString(@"Follow_VC_Title_Followers",nil);
        }
            break;
            
        default:
            break;
    }
}

- (void)userLogin:(NSNotification *)nofi
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
