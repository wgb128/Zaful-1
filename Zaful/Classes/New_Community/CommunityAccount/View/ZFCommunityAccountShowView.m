

//
//  ZFCommunityAccountShowView.m
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityAccountShowView.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityAccountShowCell.h"
#import "ZFCommunityShowViewModel.h"
#import "ZFCommunityAccountShowsListModel.h"
#import "ZFCommunityAccountShowsModel.h"
#import "ZFLoginViewController.h"

static NSString *const kZFCommunityAccountShowCellIdentifier = @"kZFCommunityAccountShowCellIdentifier";

@interface ZFCommunityAccountShowView () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    __block NSIndexPath *_currentIndexPath;
}

@property (nonatomic, strong) UITableView                       *tableView;
@property (nonatomic, strong) ZFCommunityShowViewModel          *viewModel;
@property (nonatomic, strong) ZFCommunityAccountShowsListModel  *showsListModel;
@property (nonatomic, strong) ZFCommunityAccountShowsModel      *deleteModel;
@property (nonatomic, strong) NSMutableArray<ZFCommunityAccountShowsModel *> *dataArray;
@end

@implementation ZFCommunityAccountShowView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
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
- (void)loginChangeValue:(NSNotification *)nofi {
    [self.tableView.mj_header beginRefreshing];
}

- (void)logoutChangeValue:(NSNotification *)nofi {
    [self.tableView.mj_header beginRefreshing];
}

- (void)deleteChangeValue:(NSNotification *)nofi {
    [self.tableView.mj_header beginRefreshing];
}

- (void)reviewCountsChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    ZFCommunityAccountShowsModel *reviewsModel = nofi.object;
    //遍历当前列表数组找到相同reviewId增加评论数
    [self.dataArray enumerateObjectsUsingBlock:^(ZFCommunityAccountShowsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewId isEqualToString:reviewsModel.reviewId]) {
            obj.replyCount = [NSString stringWithFormat:@"%d", [obj.replyCount intValue]+1];
        }
    }];
    [self.tableView reloadData];
}

- (void)likeStatusChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    ZFCommunityAccountShowsModel *likesModel = nofi.object;
    //遍历当前列表数组找到相同reviewId改变点赞按钮状态并且增加或减少点赞数
    [self.dataArray enumerateObjectsUsingBlock:^(ZFCommunityAccountShowsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewId isEqualToString:likesModel.reviewId]) {
            if (likesModel.isLiked) {
                obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]+1];
            }else{
                obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]-1];
            }
            obj.isLiked = likesModel.isLiked;
            *stop = YES;
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - private methods
- (void)communityAccountLikeWithModel:(ZFCommunityAccountShowsModel *)model andIndexPath:(NSIndexPath *)indexPath {
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *loginVC = [[ZFLoginViewController alloc] init];
        @weakify(self);
        loginVC.successBlock = ^{
            @strongify(self);
            [self.viewModel requestLikeNetwork:model completion:^(id obj) {
                @strongify(self);
                self.dataArray[indexPath.row].isLiked = !self.dataArray[indexPath.row].isLiked;
                self.dataArray[indexPath.row].likeCount = [NSString stringWithFormat:@"%lu", [self.dataArray[indexPath.row].likeCount integerValue] + (self.dataArray[indexPath.row].isLiked ? 1 : -1)];
                [self.tableView reloadData];
            } failure:^(id obj) {
                @strongify(self);
                [self.tableView reloadData];
            }];
        };
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:loginVC];
        [self.controller.navigationController presentViewController:nav animated:YES completion:nil];
        return ;
    }
    
    @weakify(self);
    [self.viewModel requestLikeNetwork:model completion:^(id obj) {
        @strongify(self);
        self.dataArray[indexPath.row].isLiked = !self.dataArray[indexPath.row].isLiked;
        self.dataArray[indexPath.row].likeCount = [NSString stringWithFormat:@"%lu", [self.dataArray[indexPath.row].likeCount integerValue] + (self.dataArray[indexPath.row].isLiked ? 1 : -1)];
        [self.tableView reloadData];
    } failure:^(id obj) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)communityAccountShowDeleteWithModel:(ZFCommunityAccountShowsModel *)model andIndexPath:(NSIndexPath *)indexPath {
    self.deleteModel = model;
    self->_currentIndexPath = indexPath;
    UIAlertController *alertController =  [UIAlertController
                                           alertControllerWithTitle: nil
                                           message:nil
                                           preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * DeleteAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"Address_List_Cell_Delete",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ZFLocalizedString(@"TopicLabelDeleteAlertView",nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:ZFLocalizedString(@"ZFPaymentView_Alert_Yes",nil)
                                              otherButtonTitles:ZFLocalizedString(@"Cancel",nil),nil];
        alert.tag = 1000;
        [alert show];
        
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:DeleteAction];
    [alertController addAction:cancelAction];
    [self.controller presentViewController:alertController animated:YES completion:nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            @weakify(self);
            [self.viewModel requestDeleteNetwork:self.deleteModel completion:^(id obj) {
                @strongify(self);
                if ([obj boolValue]) {
                    [self.dataArray removeObjectAtIndex:self->_currentIndexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[self->_currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            } failure:^(id obj) {
                @strongify(self);
                [self.tableView reloadData];
            }];
        }
    }
}

- (void)communityAccountShowsReviewOptionWithModel:(ZFCommunityAccountShowsModel *)model {
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *loginVC = [[ZFLoginViewController alloc] init];
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:loginVC];
        [self.controller.navigationController presentViewController:nav animated:YES completion:nil];
        return ;
    }
    if (self.communityAccountShowDetailCompletionHandler) {
        self.communityAccountShowDetailCompletionHandler(model.userId, model.reviewId);
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZFCommunityAccountShowsModel *model = self.dataArray[indexPath.row];
    if (self.communityAccountShowDetailCompletionHandler) {
        self.communityAccountShowDetailCompletionHandler(model.userId, model.reviewId);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFCommunityAccountShowCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityAccountShowCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    @weakify(self);
    cell.communityAccountShowsTopicCompletionHandler = ^(NSString *topic) {
        @strongify(self);
        if (self.communityAccountShowTopicCompletionHandler) {
            self.communityAccountShowTopicCompletionHandler(topic);
        }
    };
    
    cell.communityAccountShowsLikeCompletionHandler = ^(ZFCommunityAccountShowsModel *model) {
        @strongify(self);
        [self communityAccountLikeWithModel:model andIndexPath:indexPath];
    };
    
    
    cell.communityAccountShowsDeleteCompletionHandler = ^(ZFCommunityAccountShowsModel *model) {
        @strongify(self);
        [self communityAccountShowDeleteWithModel:model andIndexPath:indexPath];
    };
    
    
    cell.communityAccountShowsShareCompletionHandler = ^(ZFCommunityAccountShowsModel *model) {
        @strongify(self);
        if (self.communityAccountShowShareCompletionHandler) {
            self.communityAccountShowShareCompletionHandler(model);
        }
    };
    
    cell.communityAccountShowsUserAccountCompletionHandler = ^(NSString *userId) {
        @strongify(self);
        if (self.communityAccountShowUserAccountCompletionHandler) {
            self.communityAccountShowUserAccountCompletionHandler(userId);
        }
    };
    
    cell.communityAccountShowsReviewCompletionHandler = ^{
        @strongify(self);
        [self communityAccountShowsReviewOptionWithModel:self.dataArray[indexPath.row]];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kZFCommunityAccountShowCellIdentifier configuration:^(ZFCommunityAccountShowCell *cell) {
        cell.model = self.dataArray[indexPath.row];
    }];
}

- (void)emptyNoDataOption {
    @weakify(self);
    [self.tableView zf_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
        @strongify(self);
        self.tableView.scrollEnabled = NO;
        UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        [customView addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(44, 0, 0, 0));
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.text = ZFLocalizedString(@"ShowsViewModel_NoData_NotShowed", nil);
        [bottomView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bottomView.mas_top).offset(158*DSCREEN_HEIGHT_SCALE);
            make.centerX.mas_equalTo(bottomView.mas_centerX);
        }];
        
        return customView;
        
    } normalBlock:^(UITableView * _Nonnull sender) {
        @strongify(self);
        self.tableView.scrollEnabled = YES;
    }];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = [UIColor redColor];
    [self addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - setter
- (void)setUserId:(NSString *)userId {
    _userId = userId;
    
    if (self.dataArray.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        return ;
    }
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - getter
- (NSMutableArray<ZFCommunityAccountShowsModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (ZFCommunityShowViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityShowViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = ZFCOLOR(245, 245, 245, 1.f);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        if ([SystemConfigUtils isRightToLeftShow]) {
            _tableView.contentInset = UIEdgeInsetsMake(35, 0, 44, 0);
        } else {
            _tableView.contentInset = UIEdgeInsetsMake(44, 0, 44, 0);
        }
        
        [_tableView registerClass:[ZFCommunityAccountShowCell class] forCellReuseIdentifier:kZFCommunityAccountShowCellIdentifier];
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:@[self.userId ?: @"0", @(1)] completion:^(id obj) {
                @strongify(self);
                self.showsListModel = obj;
                self.dataArray = [NSMutableArray arrayWithArray:self.showsListModel.list];
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
            [self.viewModel requestNetwork:@[self.userId ?: @"0", @(self.showsListModel.curPage + 1)] completion:^(id obj) {
                @strongify(self);
                self.showsListModel = obj;
                if (self.showsListModel.list.count == 0) {
                    [self.tableView.mj_footer endRefreshing];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.tableView.mj_footer.hidden = YES;
                    }];
                } else {
                    [self.dataArray addObjectsFromArray:self.showsListModel.list];
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView reloadData];
                }
                
                
            } failure:^(id obj) {
                [self.tableView.mj_footer endRefreshing];
            }];
        }];
        
    }
    return _tableView;
}

@end
