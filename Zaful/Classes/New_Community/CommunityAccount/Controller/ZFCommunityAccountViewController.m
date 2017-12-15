

//
//  ZFCommunityAccountViewController.m
//  Zaful
//
//  Created by liuxi on 2017/7/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityAccountViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityAccountInfoView.h"
#import "ZFCommunityAccountSelectView.h"
#import "ZFCommunityAccountViewModel.h"

#import "ZFCommunityAccountLikeView.h"
#import "ZFCommunityAccountShowView.h"
#import "ZFCommunityAccountOutfitsView.h"

#import "ZFCommunityMessageViewController.h"
#import "ZFCommunityFollowersViewController.h"
#import "ZFCommunityFollowingViewController.h"
#import "ZFWebViewViewController.h"
#import "ZFCommunityTopicListViewController.h"
#import "ZFCommunityAccountShowsModel.h"
#import "ZFCommunityAccountLikesModel.h"
#import "ZFShare.h"
#import "ZFCommunityAccountInfoModel.h"
#import "ZFLoginViewController.h"
#import "CommunityDetailViewController.h"

typedef NS_ENUM(NSInteger, ZFCommunityAccountViewType) {
    ZFCommunityAccountViewTypeShow = 0,
    ZFCommunityAccountViewTypeOutfits,
    ZFCommunityAccountViewTypeLike,
};

static NSString *const kZFCommunityAccountLikeViewIdentifier = @"kZFCommunityAccountLikeViewIdentifier";
static NSString *const kZFCommunityAccountShowViewIdentifier = @"kZFCommunityAccountShowViewIdentifier";
static NSString *const kZFCommunityAccountOutfitsViewIdentifier = @"kZFCommunityAccountOutfitsViewIdentifier";

@interface ZFCommunityAccountViewController () <ZFInitViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource,ZFShareViewDelegate>

@property (nonatomic, strong) ZFCommunityAccountInfoView            *infoView;
@property (nonatomic, strong) ZFCommunityAccountSelectView          *selectView;

@property (nonatomic, strong) UICollectionViewFlowLayout            *flowLayout;
@property (nonatomic, strong) UICollectionView                      *collectionView;

@property (nonatomic, strong) ZFCommunityAccountViewModel           *viewModel;

@property (nonatomic, strong) ZFShareView                           *shareView;
@property (nonatomic, strong) ZFCommunityAccountShowsModel          *shareShowModel;
@property (nonatomic, strong) ZFCommunityAccountLikesModel          *shareLikeModel;
@property (nonatomic, assign) BOOL                                  isLike; // 是否为 ZFCommunityAccountLikesModel

@end

@implementation ZFCommunityAccountViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
        self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification methods
- (void)followStatusChangeValue:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    BOOL isFollow = [dict[@"isFollow"] boolValue];
    NSString *followedUserId = dict[@"userId"];
    
    [self changeInfoViewFollowInfoWithFollow:isFollow andFollowId:followedUserId];
}

- (void)changeInfoViewFollowInfoWithFollow:(BOOL)isFollow andFollowId:(NSString *)followedUserId {
    ZFCommunityAccountInfoModel *userInfoModel = self.infoView.model;
    if ([USERID isEqualToString: self.userId])  // mystyle  只改变Following
    {
        if (isFollow) {
            userInfoModel.followingCount += 1;
        }else{
            userInfoModel.followingCount -= 1;
        }
    }
    else  // UserStyle  只改变Followers
    {
        if ([self.userId isEqualToString:followedUserId])
        {
            if (isFollow) {
                userInfoModel.followersCount += 1;
            }else{
                userInfoModel.followersCount -= 1;
            }
            userInfoModel.isFollow = isFollow;
        }
    }
    self.infoView.model = userInfoModel;

}

#pragma mark - privtate methods
- (void)jumpToTopicListViewControllerWithTitle:(NSString *)title {
    ZFCommunityTopicListViewController *topicListVC = [[ZFCommunityTopicListViewController alloc] init];
    topicListVC.topicTitle = title;
    [self.navigationController pushViewController:topicListVC animated:YES];
}

- (ZFShareTopView *)configureZFShareTopViewWithModel:(id )model {
    ZFShareTopView *shareTopView = [[ZFShareTopView alloc] init];
    PictureModel *imageModel = nil;
    if (self.isLike) {
        ZFCommunityAccountLikesModel *likeModel = [ZFCommunityAccountLikesModel yy_modelWithJSON:model];
        imageModel = (PictureModel *)likeModel.reviewPic.firstObject;
        shareTopView.title = likeModel.content;
    } else {
        ZFCommunityAccountShowsModel *showModel = [ZFCommunityAccountShowsModel yy_modelWithJSON:model];
        imageModel = (PictureModel *)showModel.reviewPic.firstObject;
        shareTopView.title = showModel.content;
    }
    shareTopView.imageName = imageModel.bigPic;
    
    return shareTopView;
}

- (NativeShareModel *)adjustNativeShareModel {
    NativeShareModel *model = [[NativeShareModel alloc] init];
    NSString *nicknameStr;
    NSString *reviewID;
    NSString *userID;
    if (self.isLike) {
        nicknameStr = [NSString stringWithFormat:@"%@",self.shareLikeModel.nickName];
        reviewID = self.shareLikeModel.reviewId;
        userID = self.shareLikeModel.userId;
    } else {
        nicknameStr = [NSString stringWithFormat:@"%@",self.shareShowModel.nickName];
        reviewID = self.shareShowModel.reviewId;
        userID = self.shareShowModel.userId;
    }
    NSRange range = [nicknameStr rangeOfString:@" "];
    if (range.location != NSNotFound) {
        nicknameStr = [nicknameStr stringByReplacingOccurrencesOfString:@" " withString:@"_"]; //有空格
    }
    model.share_url =  [NSString stringWithFormat:@"%@?actiontype=6&url=2,%@,%@&name=%@&source=sharelink&lang=%@",CommunityShareURL,reviewID,userID,nicknameStr,[ZFLocalizationString shareLocalizable].nomarLocalizable];
    model.fromviewController = self;
    return model;
}

- (void)communityAccountFollowWithModel:(ZFCommunityAccountInfoModel *)model {
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *loginVC = [[ZFLoginViewController alloc] init];
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        return ;
    }
    
    if (model.isFollow) {
        @weakify(self)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:ZFLocalizedString(@"MyStylePage_Unfollow_Tip",nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *unfollow = [UIAlertAction actionWithTitle:ZFLocalizedString(@"Cancel",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:ZFLocalizedString(@"MyStylePage_Unfollow",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self.viewModel requestFollowNetwork:model completion:^(id obj) {
            } failure:^(id obj) {}];
        }];
        
        [alert addAction:cancel];
        [alert addAction:unfollow];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        // 关注/取消关注
        
        [self.viewModel requestFollowNetwork:model completion:^(id obj) {
        } failure:^(id obj) {}];
    }

}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ZFCommunityAccountViewTypeShow) {
        ZFCommunityAccountShowView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFCommunityAccountShowViewIdentifier forIndexPath:indexPath];
        cell.userId = self.userId;
        cell.controller = self;
        @weakify(self);
        cell.communityAccountShowTopicCompletionHandler = ^(NSString *topic) {
            @strongify(self);
            [self jumpToTopicListViewControllerWithTitle:topic];
        };
        
        cell.communityAccountShowShareCompletionHandler = ^(ZFCommunityAccountShowsModel *showModel) {
            @strongify(self);
            self.shareShowModel = showModel;
            self.shareView.topView = [self configureZFShareTopViewWithModel:[showModel yy_modelToJSONObject]];
            self.isLike = NO;
            [self.shareView open];
        };
        
        cell.communityAccountShowDetailCompletionHandler = ^(NSString *userId, NSString *reviewsId) {
            @strongify(self);
            [self jumpToCommunityDetailWithUserId:userId reviewsId:reviewsId andTitle:@""];
        };
        
        cell.communityAccountShowUserAccountCompletionHandler = ^(NSString *userId) {
            @strongify(self);
            [self jumpToCommunityUserAccountWithUserId:userId];
        };
        
        return cell;
    } else if (indexPath.section == ZFCommunityAccountViewTypeOutfits) {
        ZFCommunityAccountOutfitsView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFCommunityAccountOutfitsViewIdentifier forIndexPath:indexPath];
        cell.userId = self.userId;
        cell.controller = self;
        @weakify(self);
        cell.communityAccountOutfitsDetailCompletionHandler = ^(NSString *userId, NSString *reviewsId, NSString *title) {
            @strongify(self);
            [self jumpToCommunityDetailWithUserId:userId reviewsId:reviewsId andTitle:title];
        };
        return cell;
    } else if (indexPath.section == ZFCommunityAccountViewTypeLike) {
        ZFCommunityAccountLikeView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFCommunityAccountLikeViewIdentifier forIndexPath:indexPath];

        cell.userId = self.userId;
        cell.controller = self;
        @weakify(self);
        cell.communityAccountLikeTopicCompletionHandler = ^(NSString *topic) {
            @strongify(self);
            [self jumpToTopicListViewControllerWithTitle:topic];
        };
        
        cell.communityAccountLikeDetailCompletionHandler = ^(NSString *userId, NSString *reviewsId) {
            @strongify(self);
            [self jumpToCommunityDetailWithUserId:userId reviewsId:reviewsId andTitle:@""];
        };
        
        cell.communityAccountLikeUserAccountCompletionHandler = ^(NSString *userId) {
            @strongify(self);
            [self jumpToCommunityUserAccountWithUserId:userId];
        };
        
        cell.communityAccountLikeShareCompletionHandler = ^(ZFCommunityAccountLikesModel *likeModel) {
            @strongify(self);
            self.shareLikeModel = likeModel;
            self.shareView.topView = [self configureZFShareTopViewWithModel:[likeModel yy_modelToJSONObject]];
            self.isLike = YES;
            [self.shareView open];
        };
        
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 208);
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /*
     *  滑动过程中，对比初始位置，如果到了边界，则停止滑动。
     *  判断content offset
     */
    //先处理边界条件，即保证视图不划出屏幕。
    if (scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= SCREEN_WIDTH * 2) {
        CGFloat cannotMoveX = scrollView.contentOffset.x <= 0 ? 0 : SCREEN_WIDTH * 2;
        [scrollView setContentOffset:CGPointMake(cannotMoveX, scrollView.contentOffset.y)];
        NSInteger index = ![SystemConfigUtils  isRightToLeftShow] ? (cannotMoveX / SCREEN_WIDTH) : (2 - (cannotMoveX / SCREEN_WIDTH));
        self.selectView.currentType = index;
        return ;
    }
    NSInteger index = ![SystemConfigUtils  isRightToLeftShow] ? (scrollView.contentOffset.x / SCREEN_WIDTH) : (2 - (scrollView.contentOffset.x / SCREEN_WIDTH));
    self.selectView.currentType = index;
}

#pragma mark - action methods 
- (void)jumpToMessageViewController {
    ZFCommunityMessageViewController *messageVC = [[ZFCommunityMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)jumpToTipsWebViewController {
    ZFWebViewViewController *webViewVC = [[ZFWebViewViewController alloc] init];
    webViewVC.link_url = [NSString stringWithFormat:@"%@?lang=%@",CommunityIntroURL, [ZFLocalizationString shareLocalizable].nomarLocalizable];
    [self.navigationController pushViewController:webViewVC animated:YES];
}

- (void)jumpToFollowingViewController {
    ZFCommunityFollowingViewController *followingVC = [[ZFCommunityFollowingViewController alloc] init];
    followingVC.userId = self.userId;
    [self.navigationController pushViewController:followingVC animated:YES];
}

- (void)jumpToFollowerViewController {
    ZFCommunityFollowersViewController *follwerVC = [[ZFCommunityFollowersViewController alloc] init];
    follwerVC.userId = self.userId;
    [self.navigationController pushViewController:follwerVC animated:YES];
}

- (void)jumpToCommunityDetailWithUserId:(NSString *)userId reviewsId:(NSString *)reviewsId andTitle:(NSString *)title{
    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:reviewsId userId:userId];
    detailVC.title = title;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)jumpToCommunityUserAccountWithUserId:(NSString *)userId {
    if ([userId isEqualToString:USERID]) {
        return ;
    }
    ZFCommunityAccountViewController *accountVC = [[ZFCommunityAccountViewController alloc] init];
    accountVC.userId = userId;
    [self.navigationController pushViewController:accountVC animated:YES];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = ZFLocalizedString(@"Tabbar_Z-Me", nil);
    self.view.backgroundColor = ZFCOLOR(245, 245, 245, 1.f);
    [self.view addSubview:self.infoView];
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.collectionView];
}

- (void)zfAutoLayoutView {
    
    CGFloat offsetY = IPHONE_X_5_15 ? 24.0f : 0.0f;
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.view);
        make.height.mas_equalTo(232 + offsetY);
    }];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.infoView.mas_bottom);
        make.height.mas_equalTo(44);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectView.mas_bottom).offset(8);
        make.leading.trailing.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - setter
- (void)setUserId:(NSString *)userId {
    _userId = userId;
    @weakify(self);
    [self.viewModel requestNetwork:_userId completion:^(id obj) {
        @strongify(self);
        self.infoView.model = obj;
    } failure:^(id obj) {
        ZFLog(@"debug");
    }];
    
    [self.viewModel requestMessageCountNetwork:nil completion:^(id obj) {
        @strongify(self);
        if ([obj integerValue] > 0 && [obj integerValue] < 100) {
            self.infoView.messageCount = obj;
        }else if ([obj integerValue] > 100) {
            self.infoView.messageCount = @"99+";
        } else{
            self.infoView.messageCount = nil;
        }
    } failure:^(id obj) {
        @strongify(self);
        self.infoView.messageCount = nil;
    }];
}

#pragma mark - getter
- (ZFCommunityAccountViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityAccountViewModel alloc] init];
    }
    return _viewModel;
}

- (ZFCommunityAccountInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[ZFCommunityAccountInfoView alloc] initWithFrame:CGRectZero];
        @weakify(self);
        _infoView.backButtonActionCompletionHandler = ^{
            @strongify(self);
            if (self.isDeeplink) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
        
        _infoView.messageButtonActionCompletionHandler = ^{
            @strongify(self);
            [self jumpToMessageViewController];
        };
        
        _infoView.tipsButtonActionCompletionHandler = ^{
            @strongify(self);
            [self jumpToTipsWebViewController];
        };
        
        _infoView.followingButtonActionCompletionHandler = ^{
            @strongify(self);
            [self jumpToFollowingViewController];
        };
        
        _infoView.followerButtonActionCompletionHandler = ^{
            @strongify(self);
            [self jumpToFollowerViewController];
        };
        
        _infoView.communityAccountFollowCompletionHandler = ^(ZFCommunityAccountInfoModel *model) {
            @strongify(self);
            [self communityAccountFollowWithModel:model];
        };
        
        
    }
    return _infoView;
}

- (ZFCommunityAccountSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[ZFCommunityAccountSelectView alloc] initWithFrame:CGRectZero];
        @weakify(self);
        _selectView.communityAccountSelectCompletionHandler = ^(ZFCommunityAccountSelectType type) {
            @strongify(self);
            [self.collectionView scrollRectToVisible:CGRectMake(![SystemConfigUtils isRightToLeftShow] ? type * SCREEN_WIDTH : (2 - type) * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 208) animated:NO];
        };
    }
    return _selectView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ZFCommunityAccountShowView class] forCellWithReuseIdentifier:kZFCommunityAccountShowViewIdentifier];
        [_collectionView registerClass:[ZFCommunityAccountLikeView class] forCellWithReuseIdentifier:kZFCommunityAccountLikeViewIdentifier];
        [_collectionView registerClass:[ZFCommunityAccountOutfitsView class] forCellWithReuseIdentifier:kZFCommunityAccountOutfitsViewIdentifier];
    }
    return _collectionView;
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
