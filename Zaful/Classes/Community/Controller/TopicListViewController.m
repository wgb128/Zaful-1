//
//  TopicListViewController.m
//  Zaful
//
//  Created by zhaowei on 2016/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//  话题列表

#import "TopicListViewController.h"
#import "TopicListViewModel.h"
#import "TopicListTableViewCell.h"

@interface TopicListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TopicListViewModel *viewModel;
@end

@implementation TopicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ZFLocalizedString(@"TopicList_VC_Title",nil);
    [self initView];
    [self requestData];
}

#pragma mark - requestApi
- (void)requestData {
    @weakify(self)
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.viewModel requestNetwork:@[LoadMore] completion:^(id obj) {
            @strongify(self)
            [self.tableView reloadData];
            if([obj isEqual: NoMoreToLoad]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [UIView animateWithDuration:0.3 animations:^{
                    _tableView.mj_footer.hidden = YES;
                }];
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
        } failure:^(id obj) {
            @strongify(self)
            [self.tableView.mj_footer endRefreshing];
        }];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.viewModel requestNetwork:@[Refresh] completion:^(NSArray *obj) {
            @strongify(self)
            if (![NSArrayUtils isEmptyArray:obj]) {
            }
            
            [self.tableView reloadData];
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
        } failure:^(id obj) {
            @strongify(self)
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - initView
- (void)initView {
    //添加约束，进行自动布局
    __weak typeof(self.view) ws = self.view;
    
    ws.backgroundColor = ZFCOLOR(241, 241, 241, 1.0);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = ZFCOLOR(241, 241, 241, 1.0);
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self.viewModel;
    tableView.delegate = self.viewModel;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    [tableView setTableFooterView:view];
    [tableView registerClass:[TopicListTableViewCell class] forCellReuseIdentifier:TOPIC_LIST_CELL_IDENTIFIER];
    [ws addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView = tableView;
}

- (TopicListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TopicListViewModel alloc] init];
        _viewModel.controller = self;
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
