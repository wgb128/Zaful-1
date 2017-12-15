
//
//  ZFCommunityMessageViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityMessageViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityMessageListCell.h"
#import "ZFCommunityMessageViewModel.h"
#import "ZFCommunityAccountViewController.h"
#import "ZFCommunityMessageModel.h"
#import "CommunityDetailViewController.h"


static NSString *const kZFCommunityMessageListCellIdentifier = @"kZFCommunityMessageListCellIdentifier";

@interface ZFCommunityMessageViewController () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView                   *tableView;
@property (nonatomic, strong) ZFCommunityMessageViewModel   *viewModel;

@property (nonatomic, strong) NSMutableArray<ZFCommunityMessageModel *>  *dataArray;
@end

@implementation ZFCommunityMessageViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - private methods
- (void)jumpToMessageUserInfoWithUserId:(NSString *)userId {
    ZFCommunityAccountViewController *accountVC = [[ZFCommunityAccountViewController alloc] init];
    accountVC.userId = userId;
    [self.navigationController pushViewController:accountVC animated:YES];
}

- (void)followMessageUserWithUserId:(NSString *)userId andIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    [self.viewModel requestFollowedNetwork:userId completion:^(id obj) {
        @strongify(self);
        self.dataArray[indexPath.row].isFollow = !self.dataArray[indexPath.row].isFollow;
        [self.tableView reloadData];
        NSDictionary *dic = @{@"userId"   : userId,
                              @"isFollow" : @(self.dataArray[indexPath.row].isFollow)};
        [[NSNotificationCenter defaultCenter] postNotificationName:kFollowStatusChangeNotification object:dic];
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
    ZFCommunityMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityMessageListCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    @weakify(self);
    cell.communityMessageListFollowUserCompletionHandler = ^(NSString *userId) {
        @strongify(self);
        [self followMessageUserWithUserId:userId andIndexPath:indexPath];
    };
    
    cell.communityMessageAccountDetailCompletioinHandler = ^(NSString *userId) {
        @strongify(self);
        [self jumpToMessageUserInfoWithUserId:userId];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZFCommunityMessageModel *model = self.dataArray[indexPath.row];
    if (![NSStringUtils isEmptyString:model.pic_src]) {
        //跳转对应社区详情。
        CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:model.review_id userId:model.user_id];
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        [self jumpToMessageUserInfoWithUserId:model.user_id];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 83;
}

- (void)emptyNoDataOption {
    @weakify(self);
    [self.tableView zf_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
        @strongify(self);
        self.tableView.scrollEnabled = NO;
        UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
        YYAnimatedImageView *imageView = [YYAnimatedImageView new];
        imageView.image = [UIImage imageNamed:@"message_empty"];
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
        titleLabel.text = ZFLocalizedString(@"MessagesViewModel_NoData_Message",nil);
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
    self.title = ZFLocalizedString(@"MessagesViewModel_title", nil);
    self.view.backgroundColor = ZFCOLOR_WHITE;
    [self.view addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - getter
- (ZFCommunityMessageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityMessageViewModel alloc] init];
    }
    return _viewModel;
}

- (NSMutableArray<ZFCommunityMessageModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = ZFCOLOR_WHITE;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[ZFCommunityMessageListCell class] forCellReuseIdentifier:kZFCommunityMessageListCellIdentifier];
        @weakify(self);
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:@[LoadMore] completion:^(id obj) {
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
                [_tableView.mj_footer endRefreshing];
            }];
        }];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:@[Refresh] completion:^(id obj) {
                @strongify(self);
                self.dataArray = obj;
                if (self.dataArray.count == 0) {
                    [self emptyNoDataOption];
                }
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer.hidden = NO;
            } failure:^(id obj) {
                @strongify(self);
                if (self.dataArray.count == 0) {
                    [self emptyNoDataOption];
                }
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }];
        }];
       
    }
    return _tableView;
}

@end
