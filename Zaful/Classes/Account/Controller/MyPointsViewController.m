//
//  DRewardsViewController.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/28.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "MyPointsViewController.h"
#import "MyPointsApi.h"
#import "MyPointsCell.h"
#import "PointsModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MyPointViewModel.h"
#import "ZFInitViewProtocol.h"
#import "ZFWebViewViewController.h"

@interface MyPointsViewController () <ZFInitViewProtocol>
@property (nonatomic, strong) UIView                *headerView;

@property (nonatomic, strong) UIButton              *headerButton;

@property (nonatomic, strong) YYAnimatedImageView   *headImageView;

@property (nonatomic, strong) UILabel               *rewardsLabel;

@property (nonatomic, strong) UILabel               *headerLabel;

@property (nonatomic, strong) UIButton              *questionBtn;

@property (nonatomic, strong) UITableView           *tableView;

@property (nonatomic, assign) LoadingViewShowType   loadingViewShowType;

@property (nonatomic, strong) MyPointViewModel *viewModel;
@end

@implementation MyPointsViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ZFLocalizedString(@"MyPoints_VC_Title",nil);
    self.view.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    [self zfInitView];
    [self zfAutoLayoutView];
    [self addHeaderFooterView];
}

- (void)addHeaderFooterView {
    @weakify(self)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.viewModel requestNetwork:@[Refresh] completion:^(id obj) {
            @strongify(self)
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            self.tableView.mj_footer.hidden = NO;
        } failure:^(id obj) {
            @strongify(self)
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.viewModel requestNetwork:@[LoadMore] completion:^(id obj) {
            @strongify(self)
            [self.tableView reloadData];
            if([obj isEqual: NoMoreToLoad]) {
                // 无法加载更多的时候
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.hidden = YES;
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
        } failure:^(id obj) {
            @strongify(self)
            [self.tableView.mj_footer endRefreshing];
        }];
    }];
    //footer.stateLabel.hidden = YES;
    self.tableView.mj_footer = footer;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.headerLabel];
    [self.headerView addSubview:self.headImageView];
    [self.headerView addSubview:self.rewardsLabel];
    [self.headerView addSubview:self.questionBtn];
    [self.view addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(90);
    }];
    
    [self.headerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(@0);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(self.headerLabel);
        make.trailing.equalTo(self.headerLabel.mas_leading).offset(-8);
        make.size.equalTo(@18);
    }];
    
    [self.rewardsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(self.headerLabel);
        make.leading.equalTo(self.headerLabel.mas_trailing).offset(6);
    }];
    
    [self.questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(3);
        make.trailing.offset(-5);
        make.size.equalTo(@30);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark ---- Data Source Implementation ----
/* The attributed string for the description of the empty state */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"";
    if (self.loadingViewShowType == LoadingViewNoNetType) {
        text = ZFLocalizedString(@"Global_NO_NET_404",nil);
    }else if(self.loadingViewShowType == LoadingViewNoDataType)
    {
        text = ZFLocalizedString(@"MyPoints_EmptyData_Tip",nil);
    }
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/* The background color for the empty state */
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return ZFCOLOR(245, 245, 245, 1.0); // redColor whiteColor
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.loadingViewShowType == LoadingViewNoNetType){
        return [UIImage imageNamed:@"wifi"];
    }else if(self.loadingViewShowType == LoadingViewNoDataType)
    {
        return  [UIImage imageNamed:@"ic_point"];
    }
    return nil;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 88;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorStyle = YES;
        _tableView.emptyDataSetDelegate = self.viewModel;
        _tableView.emptyDataSetSource = self.viewModel;
    }
    return _tableView;
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
        _headerView.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
    }
    return _headerView;
}

-(YYAnimatedImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"dRewards_header"]];
    }
    return _headImageView;
}

-(UILabel *)rewardsLabel{
    if (!_rewardsLabel) {
        _rewardsLabel = [[UILabel alloc] init];
        _rewardsLabel.text = ZFLocalizedString(@"MyPoints_Rewards_Label",nil);
        _rewardsLabel.textColor = ZFCOLOR(255, 255, 255, 1.0);
        _rewardsLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _rewardsLabel;
}

-(UILabel *)headerLabel{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] init];
        _headerLabel.textColor = ZFCOLOR(255, 255, 255, 1.0);
        _headerLabel.font = [UIFont systemFontOfSize:45];
        _headerLabel.textAlignment= NSTextAlignmentCenter;
    }
    return _headerLabel;
}

-(UIButton *)questionBtn{
    if (!_questionBtn) {
        _questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_questionBtn setImage:[UIImage imageNamed:@"question"] forState:UIControlStateNormal];
        [_questionBtn addTarget:self action:@selector(questionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _questionBtn;
}

- (void)questionBtnClick
{
    ZFWebViewViewController *web = [[ZFWebViewViewController alloc] init];
    web.title = ZFLocalizedString(@"MyPoints_WhatPoints_VC_Title",nil);
    web.link_url = [NSString stringWithFormat:@"%@z-points/?app=1&lang=%@",H5BaseURL, [ZFLocalizationString shareLocalizable].nomarLocalizable];
    [self.navigationController pushViewController:web animated:YES];
}

- (MyPointViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MyPointViewModel alloc]init];
        _viewModel.controller = self;
        _viewModel.headerLabel = self.headerLabel;
    }
    return _viewModel;
}

@end
