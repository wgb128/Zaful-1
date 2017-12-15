

//
//  ZFCommunityExploreListView.m
//  Zaful
//
//  Created by liuxi on 2017/7/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityExploreListView.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityExploreBannersCell.h"
#import "ZFCommunityExploreVideosCell.h"
#import "ZFCommunityExploreHotTopicsCell.h"
#import "ZFCommunityExploreRecentPostsCell.h"
#import "ZFCommunityExploreViewModel.h"
#import "ZFCommunityFavesItemModel.h"
#import "ZFCommunityExploreModel.h"
#import "ZFCommunityFavesItemModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZFLoginViewController.h"

#import "TopicViewController.h"
#import "CommunityDetailViewController.h"

static NSString *const kZFCommunityExploreBannersCellIdentifier = @"kZFCommunityExploreBannersCellIdentifier";
static NSString *const kZFCommunityExploreVideosCellIdentifier = @"kZFCommunityExploreVideosCellIdentifier";
static NSString *const kZFCommunityExploreHotTopicsCellIdentifier = @"kZFCommunityExploreHotTopicsCellIdentifier";
static NSString *const kZFCommunityExploreRecentPostsCellIdentifier = @"kZFCommunityExploreRecentPostsCellIdentifier";

@interface ZFCommunityExploreListView () <ZFInitViewProtocol, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView                   *tableView;

@property (nonatomic, strong) ZFCommunityExploreViewModel   *viewModel;

@property (nonatomic, strong) ZFCommunityExploreModel       *model;
@end

@implementation ZFCommunityExploreListView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        [self.tableView.mj_header beginRefreshing];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadExploreData) name:kRefreshPopularNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusChangeValue:) name:kLikeStatusChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewCountsChangeValue:) name:kReviewCountsChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChangeValue:) name:kDeleteStatusChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kLoginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kChangeUserInfoNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutChangeValue:) name:kLogoutNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification methods
- (void)deleteChangeValue:(NSNotification *)nofi {
    [self.tableView.mj_header beginRefreshing];
}

- (void)loginChangeValue:(NSNotification *)nofi {
    [self.tableView.mj_header beginRefreshing];
}

- (void)logoutChangeValue:(NSNotification *)nofi {
    [self.tableView.mj_header beginRefreshing];
}

- (void)reviewCountsChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    ZFCommunityFavesItemModel *reviewsModel = nofi.object;
    //遍历当前列表数组找到相同reviewId增加评论数
    [self.model.list enumerateObjectsUsingBlock:^(ZFCommunityFavesItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewId isEqualToString:reviewsModel.reviewId]) {
            obj.replyCount = [NSString stringWithFormat:@"%d", [obj.replyCount intValue]+1];
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:idx inSection:3];
            *stop = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
    }];
}

- (void)likeStatusChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    ZFCommunityFavesItemModel *likesModel = nofi.object;
    //遍历当前列表数组找到相同reviewId改变点赞按钮状态并且增加或减少点赞数
    [self.model.list enumerateObjectsUsingBlock:^(ZFCommunityFavesItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewId isEqualToString:likesModel.reviewId]) {
            if (likesModel.isLiked) {
                obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]+1];
            }else{
                obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]-1];
            }
            obj.isLiked = likesModel.isLiked;
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:idx inSection:3];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
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
    if (self.model.list.count == 0) {
        [self.tableView.mj_header beginRefreshing];
        return;
    }
    
    //遍历当前列表数组找到相同userId改变状态
    __block NSIndexPath *reloadIndexPath;
    [self.model.list enumerateObjectsUsingBlock:^(ZFCommunityFavesItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.userId isEqualToString:followedUserId]) {
            obj.isFollow = isFollow;
            reloadIndexPath = [NSIndexPath indexPathForRow:idx inSection:3];
            *stop = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
    }];
    
}

- (void)reloadExploreData {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - private methods

- (void)communityExploreFollowUserWithModel:(ZFCommunityFavesItemModel *)model andIndexPath:(NSIndexPath *)indexPath {
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *signVC = [ZFLoginViewController new];
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
        [self.controller.navigationController presentViewController:nav animated:YES completion:nil];
        return ;
    }
    @weakify(self);
    [self.viewModel requestFollowNetwork:model completion:^(id obj) {
        @strongify(self);
        self.model.list[indexPath.row].isFollow = YES;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(id obj) {
    }];
}

- (void)communityExploreLikeOptionWithModel:(ZFCommunityFavesItemModel *)model andIndexPath:(NSIndexPath *)indexPath {
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *signVC = [ZFLoginViewController new];
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
        [self.controller.navigationController presentViewController:nav animated:YES completion:nil];
        return ;
    }
    @weakify(self);
    [self.viewModel requestLikeNetwork:model completion:^(id obj) {
        @strongify(self);
        self.model.list[indexPath.row].isLiked = !self.model.list[indexPath.row].isLiked;
        self.model.list[indexPath.row].likeCount = [NSString stringWithFormat:@"%lu", [self.model.list[indexPath.row].likeCount integerValue] + (self.model.list[indexPath.row].isLiked ? 1 : -1)];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(id obj) {
    }];
}

- (void)communityExploreReviewOptionWithModel:(ZFCommunityFavesItemModel *)model {
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *signVC = [ZFLoginViewController new];
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
        [self.controller.navigationController presentViewController:nav animated:YES completion:nil];
        return ;
    }
    if (self.communityExploreDetailCompletionHandler) {
        self.communityExploreDetailCompletionHandler(model.userId, model.reviewId);
    }
}

- (void)jumpToCommunityExploreHotVideoDetailWithTopicId:(NSString *)topicId {
    TopicViewController *topicVC = [[TopicViewController alloc] init];
    topicVC.topicId = topicId;
    topicVC.sort = @"1";
    [self.controller.navigationController pushViewController:topicVC animated:YES];
}


#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.list.count > 0 ? 4 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section < 3 ? 1 : self.model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZFCommunityExploreBannersCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityExploreBannersCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        @weakify(self);
        cell.jumpToBannerCompletionHandler = ^(BannerModel *model) {
            @strongify(self);
            if (self.communityExploreBannerCompletionHandler) {
                self.communityExploreBannerCompletionHandler(model);
            }
        };
        cell.model = self.model;
        return cell;
    } else if (indexPath.section == 1) {
        ZFCommunityExploreVideosCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityExploreVideosCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model;
        @weakify(self);
        cell.communityMoreVideoCompletionHandler = ^{
            @strongify(self);
            if (self.communityExploreMoreVideoCompletionHandler) {
                self.communityExploreMoreVideoCompletionHandler();
            }
        };
        
        cell.communityMoreVideoSeeAllCompletionHandler = ^{
            @strongify(self);
            if (self.communityExploreMoreVideoCompletionHandler) {
                self.communityExploreMoreVideoCompletionHandler();
            }
        };
        
        cell.communityMoreVideoDetailCompletionHandler = ^(NSString *videoId) {
            @strongify(self);
            if (self.communityExploreMoreVideoDetailCompletionHandler) {
                self.communityExploreMoreVideoDetailCompletionHandler(videoId);
            }
        };
        
        return cell;
    } else if (indexPath.section == 2) {
        ZFCommunityExploreHotTopicsCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityExploreHotTopicsCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model;
        @weakify(self);
        cell.communityMoreTopicsCompletionHandler = ^{
            @strongify(self);
            if (self.communityExploreMoreTopicCompletionHandler) {
                self.communityExploreMoreTopicCompletionHandler();
            }
        };
        
        cell.communityExploreHotTopicDetailCompletionHandler = ^(NSString *topicId) {
            @strongify(self);
            [self jumpToCommunityExploreHotVideoDetailWithTopicId:topicId];
        };
        
        return cell;
    } else if (indexPath.section == 3) {
        ZFCommunityExploreRecentPostsCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityExploreRecentPostsCellIdentifier];
        cell.model = self.model.list[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        @weakify(self);
        cell.communityExploreTopicDetailCompletionHandler = ^(NSString *topic) {
            @strongify(self);
            if (self.communityExploreTopicCompletionHandler) {
                self.communityExploreTopicCompletionHandler(topic);
            }
        };
        
        cell.communityExploreShareCompletionHandler = ^(ZFCommunityFavesItemModel *model) {
            @strongify(self);
            if (self.communityExploreShareCompletionHandler) {
                self.communityExploreShareCompletionHandler(model);
            }
        };
        
        cell.communityExploreFollowCompletionHandler = ^(ZFCommunityFavesItemModel *model) {
            @strongify(self);
            [self communityExploreFollowUserWithModel:model andIndexPath:indexPath];
        };
        
        cell.communityExploreLikeCompletionHandler = ^(ZFCommunityFavesItemModel *model) {
            @strongify(self);
            [self communityExploreLikeOptionWithModel:model andIndexPath:indexPath];
        };
        
        cell.communityExploreUserAccountCompletionHandler = ^(NSString *userId) {
            @strongify(self);
            if (self.communityExploreUserAccountCompletionHandler) {
                self.communityExploreUserAccountCompletionHandler(userId);
            }
        };
        
        cell.communityExploreReviewCompletionHandler = ^{
            @strongify(self);
            [self communityExploreReviewOptionWithModel:self.model.list[indexPath.row]];
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 198.0;
    } else if (indexPath.section == 1 || indexPath.section == 2) {
        return 168.0;
    }
    return [tableView fd_heightForCellWithIdentifier:kZFCommunityExploreRecentPostsCellIdentifier configuration:^(ZFCommunityExploreRecentPostsCell *cell) {
        cell.model = self.model.list[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 3) {
        return ;
    }
    ZFCommunityFavesItemModel *model = self.model.list[indexPath.row];
    if (self.communityExploreDetailCompletionHandler) {
        self.communityExploreDetailCompletionHandler(model.userId, model.reviewId);
    }
}

- (void)emptyNoDataOption {
    @weakify(self);
    [self.tableView zf_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
        @strongify(self);
        self.tableView.scrollEnabled = NO;
        UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
        
        
        YYAnimatedImageView *imageView = [YYAnimatedImageView new];
        imageView.image = [UIImage imageNamed:@"photo"];
        [customView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(customView.mas_top).mas_offset(170 * DSCREEN_HEIGHT_SCALE);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"Posts from your Popular \n will appear here";
        [customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(20);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = ZFCOLOR(51, 51, 51, 1);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"Refresh" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(reloadExploreData) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 3;
        [customView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(33);
            make.centerX.mas_equalTo(customView.mas_centerX);
            make.width.mas_equalTo(@180);
            make.height.mas_equalTo(@40);
        }];
        
        return customView;
    } normalBlock:^(UITableView * _Nonnull sender) {
        @strongify(self);
        self.tableView.scrollEnabled = YES;
    }];
    
}

#pragma mark -<ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
    [self addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - getter
- (ZFCommunityExploreViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityExploreViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = ZFCOLOR_WHITE;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(60, 0, 50, 0);
        [_tableView registerClass:[ZFCommunityExploreBannersCell class] forCellReuseIdentifier:kZFCommunityExploreBannersCellIdentifier];
        [_tableView registerClass:[ZFCommunityExploreVideosCell class] forCellReuseIdentifier:kZFCommunityExploreVideosCellIdentifier];
        [_tableView registerClass:[ZFCommunityExploreHotTopicsCell class] forCellReuseIdentifier:kZFCommunityExploreHotTopicsCellIdentifier];
        [_tableView registerClass:[ZFCommunityExploreRecentPostsCell class] forCellReuseIdentifier:kZFCommunityExploreRecentPostsCellIdentifier];
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:Refresh completion:^(id obj) {
                @strongify(self);
                self.model = obj;
                if (!self.model) {
                    [self emptyNoDataOption];
                }
                [self.tableView reloadData];
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_header endRefreshing];
            } failure:^(id obj) {
                @strongify(self);
                if (!self.model) {
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
                if ([obj isEqual:NoMoreToLoad]) {
                    [self.tableView.mj_footer endRefreshing];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.tableView.mj_footer.hidden = YES;
                    }];
                } else {
                    self.model = obj;
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
