//
//  ZFCommunityLikesViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityLikesViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityFollowModel.h"
#import "ZFCommunityLikesListCell.h"
#import "ZFCommunityLikesListViewModel.h"
#import "ZFCommunityAccountViewController.h"
#import "ZFLoginViewController.h"

static NSString *const kZFCommunityLikesListCellIdentifier = @"kZFCommunityLikesListCellIdentifier";

@interface ZFCommunityLikesViewController () <ZFInitViewProtocol, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView                               *tableView;
@property (nonatomic, strong) NSMutableArray<ZFCommunityFollowModel *>  *dataArray;
@property (nonatomic, strong) ZFCommunityLikesListViewModel             *viewModel;
@end

@implementation ZFCommunityLikesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - private methods
- (void)communityFollowUserWithModel:(ZFCommunityFollowModel *)model andIndexPath:(NSIndexPath *)indexPath{
    
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *loginVC = [[ZFLoginViewController alloc] init];
        @weakify(self);
        loginVC.successBlock = ^{
            @strongify(self);
            [self.viewModel requestFollowUserNetwork:model completion:^(id obj) {
                @strongify(self);
                ZFCommunityFollowModel *model = self.dataArray[indexPath.row];
                self.dataArray[indexPath.row].isFollow = !model.isFollow;
                [self.tableView reloadData];
            } failure:^(id obj) {
                [self.tableView reloadData];
            }];
        };
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        return ;
    }
    @weakify(self);
    [self.viewModel requestFollowUserNetwork:model completion:^(id obj) {
        @strongify(self);
        ZFCommunityFollowModel *model = self.dataArray[indexPath.row];
        self.dataArray[indexPath.row].isFollow = !model.isFollow;
        [self.tableView reloadData];
    } failure:^(id obj) {
        [self.tableView reloadData];
    }];
}


#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFCommunityLikesListCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityLikesListCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    @weakify(self);
    cell.communityFollowUserCompletionHandler = ^(ZFCommunityFollowModel *model) {
        @strongify(self);
        [self communityFollowUserWithModel:model andIndexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZFCommunityAccountViewController *accountVC = [[ZFCommunityAccountViewController alloc] init];
    accountVC.userId = self.dataArray[indexPath.row].userId;
    [self.navigationController pushViewController:accountVC animated:YES];
}

- (void)emptyNoDataOption {
    @weakify(self);
    [self.tableView zf_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
        @strongify(self);
        self.tableView.scrollEnabled = NO;
        UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
        customView.backgroundColor = ZFCOLOR(245, 245, 245, 1);
        
        YYAnimatedImageView *imageView = [YYAnimatedImageView new];
        imageView.image = [UIImage imageNamed:@"camera"];
        [customView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(customView.mas_top).offset(105 * DSCREEN_HEIGHT_SCALE);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        return customView;
        
    } normalBlock:^(UITableView * _Nonnull sender) {
        @strongify(self);
        self.tableView.scrollEnabled = YES;
    }];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.title = ZFLocalizedString(@"Follow_VC_Title_LikedBy",nil);
    self.view.backgroundColor = ZFCOLOR_WHITE;
    [self.view addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - setter
- (void)setRid:(NSString *)rid {
    _rid = rid;
    self.viewModel.rid = _rid;
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    self.viewModel.userId = _userId;
}

#pragma mark - getter
- (ZFCommunityLikesListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityLikesListViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[ZFCommunityLikesListCell class] forCellReuseIdentifier:kZFCommunityLikesListCellIdentifier];
        
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:Refresh completion:^(id obj) {
                @strongify(self);
                self.dataArray = obj;
                if (self.dataArray.count == 0) {
                    [self emptyNoDataOption];
                }
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                
            } failure:^(id obj) {
                @strongify(self);
                if (self.dataArray.count == 0) {
                    [self emptyNoDataOption];
                }
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:LoadMore completion:^(id obj) {
                @strongify(self);
                self.dataArray = obj;
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            } failure:^(id obj) {
                @strongify(self);
                [self.tableView.mj_footer endRefreshing];
            }];
        }];
       
    }
    return _tableView;
}

@end
