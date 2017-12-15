

//
//  ZFCommunityFollowersViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityFollowersViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityFollowersCell.h"
#import "ZFCommunityFollowersViewModel.h"
#import "ZFCommunityAccountViewController.h"
#import "ZFCommunityFollowModel.h"
#import "ZFLoginViewController.h"

static NSString *const kZFCommunityFollowersCellIdentifier = @"kZFCommunityFollowersCellIdentifier";

@interface ZFCommunityFollowersViewController () <ZFInitViewProtocol, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView                   *tableView;
@property (nonatomic, strong) ZFCommunityFollowersViewModel *viewModel;

@property (nonatomic, strong) NSMutableArray<ZFCommunityFollowModel*> *dataArray;
@end

@implementation ZFCommunityFollowersViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
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

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFCommunityFollowersCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityFollowersCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        YYAnimatedImageView *imageView = [YYAnimatedImageView new];
        imageView.image = [UIImage imageNamed:@"camera"];
        [customView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(customView.mas_top).mas_offset(120 * DSCREEN_HEIGHT_SCALE);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if ([self.userId isEqualToString:[AccountManager sharedManager].account.user_id]) {
            titleLabel.text = ZFLocalizedString(@"FollowViewModel_NoData_AddPhotos",nil);
            imageView.image = [UIImage imageNamed:@"camera"];
        }
        else {
            titleLabel.text = ZFLocalizedString(@"FollowViewModel_NoData_NoFollowers",nil);
            imageView.image = [UIImage imageNamed:@"follower"];
        }
        
        [customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(40);
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
    self.title = ZFLocalizedString(@"Follow_VC_Title_Followers",nil);
    self.view.backgroundColor = ZFCOLOR_WHITE;
    [self.view addSubview:self.tableView];
    
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - setter
- (void)setUserId:(NSString *)userId {
    _userId = userId;
    self.viewModel.userId = _userId;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - getter
- (ZFCommunityFollowersViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityFollowersViewModel alloc] init];
    }
    return _viewModel;
}

- (NSMutableArray<ZFCommunityFollowModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[ZFCommunityFollowersCell class] forCellReuseIdentifier:kZFCommunityFollowersCellIdentifier];
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:Refresh completion:^(id obj) {
                @strongify(self);
                self.dataArray = obj;
                self.tableView.mj_footer.hidden = NO;
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
                if([obj isEqual: NoMoreToLoad]) {
                    [self.tableView.mj_footer endRefreshing];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.tableView.mj_footer.hidden = YES;
                    }];
                }else {
                    self.dataArray = obj;
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
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
