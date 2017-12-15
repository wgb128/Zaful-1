//
//  ZFCommunityVideoDetailViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityVideoDetailViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityVideoDetailHeaderView.h"
#import "ZFCommunityVideoDetailCommentsListView.h"
#import "ZFCommunityVideoDetailProductListCell.h"
#import "ZFCommunityVideoDetailViewModel.h"

static NSString *const kZFCommunityVideoDetailHeaderViewIdentifier = @"kZFCommunityVideoDetailHeaderViewIdentifier";
static NSString *const kZFCommunityVideoDetailCommentsListViewIdentifier = @"kZFCommunityVideoDetailCommentsListViewIdentifier";
static NSString *const kZFCommunityVideoDetailProductListCellIdentifier = @"kZFCommunityVideoDetailProductListCellIdentifier";

@interface ZFCommunityVideoDetailViewController () <ZFInitViewProtocol, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView                           *tableView;
@property (nonatomic, strong) ZFCommunityVideoDetailViewModel       *viewModel;
@end

@implementation ZFCommunityVideoDetailViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZFCommunityVideoDetailHeaderView *headerView = [tableView dequeueReusableCellWithIdentifier:kZFCommunityVideoDetailHeaderViewIdentifier];
        
        return headerView;
    } else if (indexPath.section == 1) {
        ZFCommunityVideoDetailProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityVideoDetailProductListCellIdentifier];
        
        return cell;
    } else if (indexPath.section == 2) {
        ZFCommunityVideoDetailCommentsListView *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityVideoDetailCommentsListViewIdentifier];
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.view.backgroundColor = ZFCOLOR_WHITE;
    [self.view addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - setter


#pragma mark - getter
- (ZFCommunityVideoDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityVideoDetailViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView registerClass:[ZFCommunityVideoDetailHeaderView class] forCellReuseIdentifier:kZFCommunityVideoDetailHeaderViewIdentifier];
        [_tableView registerClass:[ZFCommunityVideoDetailProductListCell class] forCellReuseIdentifier:kZFCommunityVideoDetailProductListCellIdentifier];
        [_tableView registerClass:[ZFCommunityVideoDetailCommentsListView class] forCellReuseIdentifier:kZFCommunityVideoDetailCommentsListViewIdentifier];
    }
    return _tableView;
}

@end
