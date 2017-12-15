

//
//  ZFCommunityTopicListViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityTopicListViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityTopicListViewModel.h"
#import "ZFCommunityTopicListCell.h"
#import "ZFCommunityTopicModel.h"
#import "ZFLoginViewController.h"
#import "PictureModel.h"
#import "ZFShare.h"
#import "CommunityDetailViewController.h"
#import "ZFCommunityAccountViewController.h"

static NSString *const kZFCommunityTopicListCellIdentifier = @"kZFCommunityTopicListCellIdentifier";

@interface ZFCommunityTopicListViewController () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource,ZFShareViewDelegate>
@property (nonatomic, strong) UITableView                               *tableView;
@property (nonatomic, strong) ZFCommunityTopicListViewModel             *viewModel;
@property (nonatomic, strong) NSMutableArray<ZFCommunityTopicModel *>   *dataArray;
@property (nonatomic, strong) ZFShareView                               *shareView;
@property (nonatomic, strong) ZFCommunityTopicModel                     *topicModel;
@end

@implementation ZFCommunityTopicListViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusChangeValue:) name:kLikeStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewCountsChangeValue:) name:kReviewCountsChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChangeValue:) name:kDeleteStatusChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification methods
- (void)deleteChangeValue:(NSNotification *)nofi {
    [self.tableView.mj_header beginRefreshing];
}

- (void)reviewCountsChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    ZFCommunityTopicModel *reviewsModel = nofi.object;
    //遍历当前列表数组找到相同reviewId增加评论数
    [self.dataArray enumerateObjectsUsingBlock:^(ZFCommunityTopicModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewId isEqualToString:reviewsModel.reviewId]) {
            obj.replyCount = [NSString stringWithFormat:@"%d", [obj.replyCount intValue]+1];
        }
    }];
    [self.tableView reloadData];
}

- (void)likeStatusChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    ZFCommunityTopicModel *likesModel = nofi.object;
    //遍历当前列表数组找到相同reviewId改变点赞按钮状态并且增加或减少点赞数
    [self.dataArray enumerateObjectsUsingBlock:^(ZFCommunityTopicModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewId isEqualToString:likesModel.reviewId]) {
            if (likesModel.isLiked) {
                obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]+1];
            }else{
                obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]-1];
            }
            obj.isLiked = likesModel.isLiked;
            *stop = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
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
        [self.tableView.mj_header beginRefreshing];
        return;
    }
    
    //遍历当前列表数组找到相同userId改变状态
    [self.dataArray enumerateObjectsUsingBlock:^(ZFCommunityTopicModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.userId isEqualToString:followedUserId]) {
            obj.isFollow = isFollow;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
    }];
}

#pragma mark - private methods
- (void)jumpToTopicListViewControllerWithTitle:(NSString *)title {
    if ([title isEqualToString:self.topicTitle]) {
        return ;
    }
    self.topicTitle = title;
}

- (void)jumpToCommunityDetailViewControllerWithUserId:(NSString *)userId reviewsId:(NSString *)reviewsId {
    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:reviewsId userId:userId];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)jumpToCommunityAccountViewControllerWithUserId:(NSString *)userId {
    ZFCommunityAccountViewController *accountVC = [[ZFCommunityAccountViewController alloc] init];
    accountVC.userId = userId;
    [self.navigationController pushViewController:accountVC animated:YES];
}

- (void)communityTopicListFollowUserWithModel:(ZFCommunityTopicModel *)model andIndexPath:(NSIndexPath *)indexPath {
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *signVC = [ZFLoginViewController new];
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
        [self.navigationController presentViewController:nav animated:YES completion:^{}];
        
        return ;
    }
    @weakify(self);
    [self.viewModel requestFollowNetwork:model completion:^(id obj) {
        @strongify(self);
        self.dataArray[indexPath.row].isFollow = YES;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(id obj) {
        [self.tableView reloadData];
    }];
}

- (void)communityTopicListLikeOptionWithModel:(ZFCommunityTopicModel *)model andIndexPath:(NSIndexPath *)indexPath {
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *signVC = [ZFLoginViewController new];
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
        [self.navigationController presentViewController:nav animated:YES completion:^{}];
        return ;
    }
    @weakify(self);
    [self.viewModel requestLikeNetwork:model completion:^(id obj) {
        @strongify(self);
        self.dataArray[indexPath.row].isLiked = !self.dataArray[indexPath.row].isLiked;
        self.dataArray[indexPath.row].likeCount = [NSString stringWithFormat:@"%lu", [self.dataArray[indexPath.row].likeCount integerValue] + (self.dataArray[indexPath.row].isLiked ? 1 : -1)];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(id obj) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)communityTopicListReviewOptionWithModel:(ZFCommunityTopicModel *)model {
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *signVC = [ZFLoginViewController new];
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
        [self.navigationController presentViewController:nav animated:YES completion:^{}];
        return ;
    }
    
    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:model.reviewId userId:model.userId];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (ZFShareTopView *)configureZFShareTopViewWithModel:(ZFCommunityTopicModel *)model {
    ZFShareTopView *shareTopView = [[ZFShareTopView alloc] init];
    PictureModel *imageModel = (PictureModel *)model.reviewPic.firstObject;
    shareTopView.imageName = imageModel.bigPic;
    shareTopView.title = model.content;
    return shareTopView;
}

- (NativeShareModel *)adjustNativeShareModel {
    NativeShareModel *model = [[NativeShareModel alloc] init];
    NSString *nicknameStr = [NSString stringWithFormat:@"%@",self.topicModel.nickname];
    NSRange range = [nicknameStr rangeOfString:@" "];
    if (range.location != NSNotFound) {
        //有空格
        nicknameStr = [nicknameStr stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    }
    model.share_url =  [NSString stringWithFormat:@"%@?actiontype=6&url=2,%@,%@&name=%@&source=sharelink&lang=%@",CommunityShareURL,self.topicModel.reviewId,self.topicModel.userId,nicknameStr, [ZFLocalizationString shareLocalizable].nomarLocalizable];
    model.fromviewController = self;
    return model;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFCommunityTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityTopicListCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    @weakify(self);
    cell.communityTopicListTopicCompletionHandler = ^(NSString *topic) {
        @strongify(self);
        [self jumpToTopicListViewControllerWithTitle:topic];
    };
    
    cell.communityTopicListFollowCompletionHandler = ^(ZFCommunityTopicModel *model) {
        @strongify(self);
        [self communityTopicListFollowUserWithModel:model andIndexPath:indexPath];
    };
    
    cell.communityTopicListLikeCompletionHandler = ^(ZFCommunityTopicModel *model) {
        @strongify(self);
        [self communityTopicListLikeOptionWithModel:model andIndexPath:indexPath];
    };
    
    cell.communityTopicListShareCompletionHandler = ^(ZFCommunityTopicModel *model) {
        @strongify(self);
        self.topicModel = model;
        self.shareView.topView = [self configureZFShareTopViewWithModel:model];
        [self.shareView open];
    };
    
    cell.communityTopicListAccountCompletionHandler = ^(ZFCommunityTopicModel *model) {
        @strongify(self);
        [self jumpToCommunityAccountViewControllerWithUserId:model.userId];
    };
    
    cell.communityTopicListReviewCompletionHandler = ^{
        @strongify(self);
        [self communityTopicListReviewOptionWithModel:self.dataArray[indexPath.row]];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kZFCommunityTopicListCellIdentifier configuration:^(ZFCommunityTopicListCell *cell) {
        cell.model = self.dataArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZFCommunityTopicModel *model = self.dataArray[indexPath.row];
    [self jumpToCommunityDetailViewControllerWithUserId:model.userId reviewsId:model.reviewId];
}

#pragma mark - ZFShareViewDelegate
- (void)zfShsreView:(ZFShareView *)shareView didSelectItemAtIndex:(NSUInteger)index {
    [ZFShareManager shareManager].model = [self adjustNativeShareModel];
    switch (index) {
        case ZFShareTypeFacebook:
        {
            [[ZFShareManager shareManager] shareToFacebook];
        }
            break;
        case ZFShareTypeMessenger:
        {
            [[ZFShareManager shareManager] shareToMessenger];
        }
            break;
        case ZFShareTypeCopy:
        {
            [[ZFShareManager shareManager] copyLinkURL];
        }
            break;
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.view.backgroundColor = ZFCOLOR_WHITE;
    [self.view addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - setter
- (void)setTopicTitle:(NSString *)topicTitle {
    _topicTitle = topicTitle;
    self.title = _topicTitle;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - getter
- (ZFCommunityTopicListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityTopicListViewModel alloc] init];
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
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[ZFCommunityTopicListCell class] forCellReuseIdentifier:kZFCommunityTopicListCellIdentifier];
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:@[Refresh, self.topicTitle] completion:^(id obj) {
                @strongify(self);
                self.dataArray = obj;
                self.tableView.mj_footer.hidden = NO;
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            } failure:^(id obj) {
                [self.tableView.mj_header endRefreshing];
            }];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:@[LoadMore, self.topicTitle] completion:^(id obj) {
                @strongify(self);
                if ([obj isEqual:NoMoreToLoad]) {
                    [self.tableView.mj_footer endRefreshing];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.tableView.mj_footer.hidden = YES;
                    }];
                    
                } else {
                    self.dataArray = obj;
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                }
                
            } failure:^(id obj) {
                [self.tableView.mj_footer endRefreshing];
            }];
        }];
        
    }
    return _tableView;
}

- (ZFShareView *)shareView {
    if (!_shareView) {
        _shareView = [[ZFShareView alloc] init];
        
        ZFShareButton *facebookButton = [ZFShareButton buttonWithImage:@"Facebook" Title:@"FaceBook" TransitionType:ZFShareButtonTransitionTypeCircle];
        ZFShareButton *messengerButton = [ZFShareButton buttonWithImage:@"Messenger" Title:@"Messenger" TransitionType:ZFShareButtonTransitionTypeCircle];
        ZFShareButton *copyButton = [ZFShareButton buttonWithImage:@"Link" Title:@"Copy Link" TransitionType:ZFShareButtonTransitionTypeWave];
        
        _shareView.dataSource = @[facebookButton,messengerButton,copyButton];
        _shareView.popMenuSpeed = 8.0f;
        _shareView.delegate = self;
    }
    return _shareView;
}

@end
