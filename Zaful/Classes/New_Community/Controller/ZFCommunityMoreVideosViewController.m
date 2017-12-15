//
//  ZFCommunityMoreVideosViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityMoreVideosViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityVideoDetailViewController.h"
#import "ZFCommunityMoreHotVideoListCell.h"
#import "ZFCommunityHotMoreVideoBannerCell.h"
#import "BannerModel.h"
#import "ZFCommunityMoreHotVideoModel.h"
#import "ZFCommunityMoreHotVideoListModel.h"
#import "ZFCommunityMoreHotVideosViewModel.h"
#import "ZFCommunityVideoDetailViewController.h"
#import "BannerManager.h"
#import "VideoViewController.h"
static NSString *const kZFCommunityMoreHotVideoListCellIdentifier = @"kZFCommunityMoreHotVideoListCellIdentifier";
static NSString *const kZFCommunityHotMoreVideoBannerCellIdentifier = @"kZFCommunityHotMoreVideoBannerCellIdentifier";


@interface ZFCommunityMoreVideosViewController () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView                           *tableView;
@property (nonatomic, strong) ZFCommunityMoreHotVideoListModel      *listModel;
@property (nonatomic, strong) ZFCommunityMoreHotVideosViewModel     *viewModel;
@end

@implementation ZFCommunityMoreVideosViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - private methods
- (void)jumpToBannerWebViewControllerWithModel:(BannerModel *)model {
    [BannerManager doBannerActionTarget:self withBannerModel:model];
}

- (void)reloadVideoListInfo {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.listModel.bannerList.count == 0) {
        return 0;
    }
    return section == 0 ? 1 : self.listModel.videoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZFCommunityHotMoreVideoBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityHotMoreVideoBannerCellIdentifier forIndexPath:indexPath];
        cell.bannerArray = [NSMutableArray arrayWithArray:self.listModel.bannerList];
        @weakify(self);
        cell.moreHotVideoBannerJumpCompletionHandler = ^(BannerModel *model){
            @strongify(self);
            [self jumpToBannerWebViewControllerWithModel:model];
        };
        return cell;
    } else {
        ZFCommunityMoreHotVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityMoreHotVideoListCellIdentifier forIndexPath:indexPath];
        cell.model = self.listModel.videoList[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return ;
    }
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    videoVC.videoId = self.listModel.videoList[indexPath.row].videoId;
    [self.navigationController pushViewController:videoVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.listModel.bannerList.count == 0) {
        return CGFLOAT_MIN;
    }
    return indexPath.section == 0 ? 190 : 120;
}

- (void)emptyNoDataOption {
    @weakify(self);
    [self.tableView zf_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
        @strongify(self);
        self.tableView.scrollEnabled = NO;
        UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
        
        if (![NSArrayUtils isEmptyArray:self.listModel.videoList]) {
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.text = ZFLocalizedString(@"VideoViewViewModel_NoData_Title",nil);
            [customView addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(customView.mas_bottom).mas_offset(-120 * DSCREEN_HEIGHT_SCALE);
                make.centerX.mas_equalTo(customView.mas_centerX);
            }];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = ZFMAIN_COLOR;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
            [button setTitle:ZFLocalizedString(@"VideoViewViewModel_Refresh",nil) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(reloadVideoListInfo) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 3;
            [customView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(titleLabel.mas_bottom).offset(33);
                make.centerX.mas_equalTo(customView.mas_centerX);
                make.width.mas_equalTo(@180);
                make.height.mas_equalTo(@40);
            }];
            
        } else {
            
            YYAnimatedImageView *imageView = [YYAnimatedImageView new];
            imageView.image = [UIImage imageNamed:@"following_air_blank"];
            [customView addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(customView.mas_centerY);
                make.centerX.mas_equalTo(customView.mas_centerX);
            }];
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.text = ZFLocalizedString(@"VideoViewViewModel_NoData_Title",nil);
            [customView addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(imageView.mas_bottom).offset(25);
                make.centerX.mas_equalTo(customView.mas_centerX);
            }];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = ZFMAIN_COLOR;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
            [button setTitle:ZFLocalizedString(@"VideoViewViewModel_Refresh",nil) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(reloadVideoListInfo) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 3;
            [customView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(titleLabel.mas_bottom).offset(33);
                make.centerX.mas_equalTo(customView.mas_centerX);
                make.width.mas_equalTo(@180);
                make.height.mas_equalTo(@40);
            }];
        }
        return customView;
    } normalBlock:^(UITableView * _Nonnull sender) {
        @strongify(self);
        self.tableView.scrollEnabled = YES;
    }];
}


#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.title = ZFLocalizedString(@"VideoList_VC_Title", nil);
    self.view.backgroundColor = ZFCOLOR_WHITE;
    [self.view addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - getter
- (ZFCommunityMoreHotVideosViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityMoreHotVideosViewModel alloc] init];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZFCommunityMoreHotVideoListCell class] forCellReuseIdentifier:kZFCommunityMoreHotVideoListCellIdentifier];
        [_tableView registerClass:[ZFCommunityHotMoreVideoBannerCell class] forCellReuseIdentifier:kZFCommunityHotMoreVideoBannerCellIdentifier];
        
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:Refresh completion:^(id obj) {
                @strongify(self);
                self.listModel = obj;
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                self.tableView.mj_footer.hidden = NO;
            } failure:^(id obj) {
                [self.tableView.mj_header endRefreshing];
            }];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:LoadMore completion:^(id obj) {
                @strongify(self);
                self.tableView.scrollEnabled = YES;
                if ([obj isEqual: NoMoreToLoad]) {
                    [self.tableView.mj_footer endRefreshing];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.tableView.mj_footer.hidden = YES;
                    }];
                } else {
                    self.listModel = obj;
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

