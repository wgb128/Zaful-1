//
//  ZFCommunityMoreTopicsViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityMoreHotTopicsViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommuntyMoreHotTopicListCell.h"
#import "ZFCommunityMoreHotTopicsViewModel.h"
#import "ZFCommunityMoreHotTopicModel.h"
#import "TopicViewController.h"

static NSString *const kZFCommuntyMoreHotTopicListCellIdentifier = @"kZFCommuntyMoreHotTopicListCellIdentifier";

@interface ZFCommunityMoreHotTopicsViewController () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView                                       *tableView;
@property (nonatomic, strong) NSMutableArray<ZFCommunityMoreHotTopicModel *>    *dataArray;
@property (nonatomic, strong) ZFCommunityMoreHotTopicsViewModel                 *viewModel;
@end

@implementation ZFCommunityMoreHotTopicsViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFCommuntyMoreHotTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommuntyMoreHotTopicListCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kZFCommuntyMoreHotTopicListCellIdentifier configuration:^(ZFCommuntyMoreHotTopicListCell *cell) {
        cell.model = self.dataArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZFCommunityMoreHotTopicModel *model = self.dataArray[indexPath.row];
    TopicViewController *topicVC = [[TopicViewController alloc] init];
    topicVC.topicId = model.topicId;
    [self.navigationController pushViewController:topicVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return !section ? 0 : 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    return view;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.title = ZFLocalizedString(@"TopicList_VC_Title", nil);
    self.view.backgroundColor = ZFCOLOR_WHITE;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - setter

#pragma mark - getter
- (ZFCommunityMoreHotTopicsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityMoreHotTopicsViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView registerClass:[ZFCommuntyMoreHotTopicListCell class] forCellReuseIdentifier:kZFCommuntyMoreHotTopicListCellIdentifier];
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:@[Refresh] completion:^(id obj) {
                @strongify(self);
                self.dataArray = obj;
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                self.tableView.mj_footer.hidden = NO;
            } failure:^(id obj) {
                @strongify(self);
                [self.tableView.mj_header endRefreshing];
            }];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:@[LoadMore] completion:^(id obj) {
                @strongify(self);
                if ([obj isEqual: NoMoreToLoad]) {
                    [self.tableView.mj_footer endRefreshing];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.tableView.mj_footer.hidden = YES;
                    }];
                } else {
                    self.dataArray = obj;
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView reloadData];
                }
            } failure:^(id obj) {
                @strongify(self);
                [self.tableView.mj_footer endRefreshing];
            }];
        }];
    }
    return _tableView;
}

@end
