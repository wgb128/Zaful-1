



//
//  ZFCommunityFavesListView.m
//  Zaful
//
//  Created by liuxi on 2017/7/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityFavesListView.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityFavesListCell.h"
#import "ZFCommunityFavesViewModel.h"
#import "ZFCommunityFavesItemModel.h"
#import "ZFLoginViewController.h"

static NSString *const kZFCommunityFavesListCellIdentifier = @"kZFCommunityFavesListCellIdentifier";

@interface ZFCommunityFavesListView () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView                       *favesListView;

@property (nonatomic, strong) ZFCommunityFavesViewModel         *viewModel;

@property (nonatomic, strong) NSMutableArray<ZFCommunityFavesItemModel *>       *dataArray;

@end


@implementation ZFCommunityFavesListView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        [self.favesListView.mj_header beginRefreshing];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFavesData) name:kRefreshPopularNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusChangeValue:) name:kLikeStatusChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChangeValue:) name:kDeleteStatusChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kLoginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewCountsChangeValue:) name:kReviewCountsChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kChangeUserInfoNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification methods
- (void)loginChangeValue:(NSNotification *)nofi {
    [self.favesListView.mj_header beginRefreshing];
}

- (void)deleteChangeValue:(NSNotification *)nofi {
    [self.favesListView.mj_header beginRefreshing];
}

- (void)reviewCountsChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    ZFCommunityFavesItemModel *reviewsModel = nofi.object;
    //遍历当前列表数组找到相同reviewId增加评论数
    [self.dataArray enumerateObjectsUsingBlock:^(ZFCommunityFavesItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewId isEqualToString:reviewsModel.reviewId]) {
            obj.replyCount = [NSString stringWithFormat:@"%d", [obj.replyCount intValue]+1];
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.favesListView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
            *stop = YES;
        }
    }];
}

- (void)likeStatusChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    ZFCommunityFavesItemModel *likesModel = nofi.object;
    //遍历当前列表数组找到相同reviewId改变点赞按钮状态并且增加或减少点赞数
    [self.dataArray enumerateObjectsUsingBlock:^(ZFCommunityFavesItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewId isEqualToString:likesModel.reviewId]) {
            if (likesModel.isLiked) {
                obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]+1];
            }else{
                obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]-1];
            }
            obj.isLiked = likesModel.isLiked;
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.favesListView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
            *stop = YES;
        }
    }];
}

- (void)followStatusChangeValue:(NSNotification *)noti {
    //接收通知传过来的两个值 dict[@"isFollow"],dict[@"userId"]
    NSDictionary *dict = noti.object;
    BOOL isFollow = [dict[@"isFollow"] boolValue];
    NSString *followedUserId = dict[@"userId"];
    // 当 FaversList 为空的时候，第一次去关注时自动刷新，避免手动刷新（球）
    if (self.dataArray.count == 0) {
        [self.favesListView.mj_header beginRefreshing];
        return;
    }
    
    //遍历当前列表数组找到相同userId改变状态
    [self.dataArray enumerateObjectsUsingBlock:^(ZFCommunityFavesItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.userId isEqualToString:followedUserId]) {
            obj.isFollow = isFollow;
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.favesListView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
            *stop = YES;
        }
    }];
}

- (void)reloadFavesData {
    [self.favesListView.mj_header beginRefreshing];
}

#pragma mark - private methods
- (void)communityFavesLikeOptionWithModel:(ZFCommunityFavesItemModel *)model andIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    [self.viewModel requestLikeNetwork:model completion:^(id obj) {
        @strongify(self);
        self.dataArray[indexPath.row].isLiked = !self.dataArray[indexPath.row].isLiked;
        ZFCommunityFavesItemModel *model = self.dataArray[indexPath.row];
        model.likeCount = [NSString stringWithFormat:@"%lu", [model.likeCount integerValue] + (model.isLiked ? 1 : -1)];
        self.dataArray[indexPath.row] = model;
        [self.favesListView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(id obj) {
    }];
}

- (void)addMoreFriendToSeeMoreFavesInfo {
    if (self.communityFavesAddMoreFriendsCompletionHandler) {
        self.communityFavesAddMoreFriendsCompletionHandler();
    }
}

- (void)commmunityFavesReviewOptionWithModel:(ZFCommunityFavesItemModel *)model {
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *signVC = [ZFLoginViewController new];
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
        [self.controller.navigationController presentViewController:nav animated:YES completion:nil];
        return ;
    }
    
    if (self.communityFavesListDetailCompletionHandler) {
        self.communityFavesListDetailCompletionHandler(model.userId, model.reviewId);
    }
    
    
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFCommunityFavesListCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityFavesListCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    @weakify(self);
    cell.communityFavesTopicDetailCompletionHandler = ^(NSString *topic) {
        @strongify(self);
        if (self.communityFavesListTopicCompletionHandler) {
            self.communityFavesListTopicCompletionHandler(topic);
        }
    };
    cell.communityFavesShareCompletionHandler = ^(ZFCommunityFavesItemModel *model) {
        @strongify(self);
        if (self.communityFavesListShareCompletionHandler) {
            self.communityFavesListShareCompletionHandler(model);
        }
    };

    cell.communityFavesLikeCompletionHandler = ^(ZFCommunityFavesItemModel *model) {
        @strongify(self);
        [self communityFavesLikeOptionWithModel:model andIndexPath:indexPath];
    };
    
    cell.communityFavesUserAccountCompletionHandler = ^(NSString *userId) {
        @strongify(self);
        if (self.communityFavesUserAccountCompletionHandler) {
            self.communityFavesUserAccountCompletionHandler(userId);
        }
    };
    
    cell.communityFavesReviewCompletionHandler = ^{
        @strongify(self);
        [self commmunityFavesReviewOptionWithModel:self.dataArray[indexPath.row]];
    };
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [tableView fd_heightForCellWithIdentifier:kZFCommunityFavesListCellIdentifier configuration:^(ZFCommunityFavesListCell *cell) {
        cell.model = self.dataArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZFCommunityFavesItemModel *model = self.dataArray[indexPath.row];
    if (self.communityFavesListDetailCompletionHandler) {
        self.communityFavesListDetailCompletionHandler(model.userId, model.reviewId);
    }
}

- (void)emptyNoDataOption {
    @weakify(self);
    [self.favesListView zf_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
        @strongify(self);
        self.favesListView.scrollEnabled = NO;
        UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
        
        YYAnimatedImageView *imageView = [YYAnimatedImageView new];
        imageView.image = [UIImage imageNamed:@"followed-1"];
        [customView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(customView.mas_top).mas_offset(160 * DSCREEN_HEIGHT_SCALE);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.numberOfLines = 2;
        titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 40;
        titleLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = ZFLocalizedString(@"FavesViewModel_NoData_Title",nil);
        [customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(18);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = ZFCOLOR(255, 168, 0, 1);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:ZFCOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
        [button setTitle:ZFLocalizedString(@"FavesViewModel_NoData_AddMoreFriends",nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addMoreFriendToSeeMoreFavesInfo) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 2;
        [customView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(18);
            make.centerX.mas_equalTo(customView.mas_centerX);
            make.height.mas_equalTo(@34);
        }];
        
        return customView;
    } normalBlock:^(UITableView * _Nonnull sender) {
        @strongify(self);
        self.favesListView.scrollEnabled = YES;
    }];
}

#pragma mark -<ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.favesListView];
}

- (void)zfAutoLayoutView {
    [self.favesListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - getter
- (ZFCommunityFavesViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityFavesViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)favesListView {
    if (!_favesListView) {
        _favesListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _favesListView.delegate = self;
        _favesListView.dataSource = self;
        _favesListView.showsHorizontalScrollIndicator = NO;
        _favesListView.showsVerticalScrollIndicator = NO;
        _favesListView.estimatedRowHeight = 0;
        _favesListView.estimatedSectionFooterHeight = 0;
        _favesListView.estimatedSectionHeaderHeight = 0;
        _favesListView.tableFooterView = [UIView new];
        _favesListView.contentInset = UIEdgeInsetsMake(60, 0, 50, 0);
        [_favesListView registerClass:[ZFCommunityFavesListCell class] forCellReuseIdentifier:kZFCommunityFavesListCellIdentifier];
        @weakify(self);
        _favesListView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:Refresh completion:^(id obj) {
                @strongify(self);
                self.dataArray = obj;
                if (self.dataArray.count == 0) {
                    [self emptyNoDataOption];
                }
                [self.favesListView reloadData];
                self.favesListView.mj_footer.hidden = NO;
                [self.favesListView.mj_header endRefreshing];
            } failure:^(id obj) {
                @strongify(self);
                if (self.dataArray.count == 0) {
                    [self emptyNoDataOption];
                }
                [self.favesListView reloadData];
                [self.favesListView.mj_header endRefreshing];
            }];
        }];
        
        _favesListView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:LoadMore completion:^(id obj) {
                @strongify(self);
                if ([obj isEqual:NoMoreToLoad]) {
                    [self.favesListView.mj_footer endRefreshing];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.favesListView.mj_footer.hidden = YES;
                    }];
                } else {
                    self.dataArray = obj;
                    [self.favesListView reloadData];
                    [self.favesListView.mj_footer endRefreshing];
                }
            } failure:^(id obj) {
                @strongify(self);
                [self.favesListView.mj_footer endRefreshing];
            }];
            
        }];
        
    }
    return _favesListView;
}

@end
