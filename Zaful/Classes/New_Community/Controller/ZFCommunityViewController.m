

//
//  ZFCommunityViewController.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityViewModel.h"
#import "ZFCommunityHomeSelectView.h"
#import "ZFCommunityOutfitsListView.h"
#import "ZFCommunityExploreListView.h"
#import "ZFCommunityFavesListView.h"

#import "ZFCommunitySearchFriendsViewController.h"
#import "ZFCommunityAccountViewController.h"
#import "ZFCommunityMoreHotTopicsViewController.h"
#import "ZFCommunityMoreVideosViewController.h"
#import "ZFLoginViewController.h"
#import "ZFCommunityTopicListViewController.h"
#import "VideoViewController.h"
#import "ZFCommunityDetailViewController.h"
#import "ZFShare.h"
#import "ZFCommunityFavesItemModel.h"
#import "ZFCommunityAccountViewController.h"
#import "CommunityDetailViewController.h"
#import "UIButton+YYWebImage.h"
#import "UIView+GBGesture.h"
#import "ZFCommunityPostSuccessView.h"

typedef NS_ENUM(NSInteger, ZFCommunityListViewType) {
    ZFCommunityListViewTypeExplore = 0,
    ZFCommunityListViewTypeOutfits,
    ZFCommunityListViewTypeFaves
};

static NSString *const kZFCommunityOutfitsListViewIdentifier = @"kZFCommunityOutfitsListViewIdentifier";
static NSString *const kZFCommunityExploreListViewIdentifier = @"kZFCommunityExploreListViewIdentifier";
static NSString *const kZFCommunityFavesListViewIdentifier = @"kZFCommunityFavesListViewIdentifier";


@interface ZFCommunityViewController () <ZFInitViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource,ZFShareViewDelegate> {
    NSInteger       _currentIndex;
    NSString        *_messageCount;
    BOOL            _isFirstAraboEnter;
}
@property (nonatomic, strong) ZFCommunityViewModel              *viewModel;
@property (nonatomic, strong) JSBadgeView                       *badgeView;
@property (nonatomic, strong) ZFCommunityHomeSelectView         *selectView;
@property (nonatomic, strong) UICollectionView                  *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout        *flowLayout;
@property (nonatomic, strong) ZFShareView                       *shareView;
@property (nonatomic, strong) ZFCommunityFavesItemModel         *favesItemModel;
@property (nonatomic, strong) ZFCommunityPostSuccessView        *postSuccessView;
@end

@implementation ZFCommunityViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zfInitView];
    [self zfAutoLayoutView];
    [self requestMessageCountInfo];
    self->_currentIndex = [SystemConfigUtils isRightToLeftShow] ? 2 : 0;
    self.selectView.currentType = self->_currentIndex;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(communityPostSuccessAction:) name:kCommunityPostSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutChangeValue:) name:kLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kChangeUserInfoNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self->_isFirstAraboEnter = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification methods
- (void)communityPostSuccessAction:(NSNotification *)notification {
    NSString *msg = notification.object;
    self.postSuccessView.postSuccessMessage = msg;
    self.postSuccessView.hidden = NO;
    
}

- (void)loginChangeValue:(NSNotification *)nofi {
    
    [self refreshAccountAvatorView];
}

- (void)logoutChangeValue:(NSNotification *)nofi {
    self->_messageCount = @"";
    self->_currentIndex = 0;
    self.selectView.currentType = self->_currentIndex;
    [self refreshAccountAvatorView];
}

#pragma mark - private methods
- (void)requestMessageCountInfo {
    @weakify(self);
    [self.viewModel requestMessageCountNetwork:nil completion:^(id obj) {
        @strongify(self);
        if ([obj integerValue] > 0 && [obj integerValue] < 100) {
            self->_messageCount = obj;
        }else if ([obj integerValue] > 100) {
            self->_messageCount = @"99+";
        } else{
            self->_messageCount = nil;
        }
        self.badgeView.badgeText = self->_messageCount;
    } failure:^(id obj) {
        @strongify(self);
        self->_messageCount = nil;
        self.badgeView.badgeText = self->_messageCount;
    }];

}

- (void)jumpToMoreVideoViewController {
    ZFCommunityMoreVideosViewController *moreVideoVC = [[ZFCommunityMoreVideosViewController alloc] init];
    [self.navigationController pushViewController:moreVideoVC animated:YES];
}

- (void)jumpToMoreTopicViewController {
    ZFCommunityMoreHotTopicsViewController *moreTopicVC = [[ZFCommunityMoreHotTopicsViewController alloc] init];
    [self.navigationController pushViewController:moreTopicVC animated:YES];
}

- (void)jumpToBannerFromExploreBannerListWithBanner:(BannerModel *)bannerModel {
    [BannerManager doBannerActionTarget:self withBannerModel:bannerModel];
}

- (void)jumpToTopicListViewControllerWithTitle:(NSString *)title {
    ZFCommunityTopicListViewController *topicListVC = [[ZFCommunityTopicListViewController alloc] init];
    topicListVC.topicTitle = title;
    [self.navigationController pushViewController:topicListVC animated:YES];
}

- (void)jumpToVideoDetailViewControllerWithVideoId:(NSString *)videoId {
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    videoVC.videoId = videoId;
    [self.navigationController pushViewController:videoVC animated:YES];
}

- (void)jumpToCommunityDetailViewControllerWithUserId:(NSString *)userId reviewsId:(NSString *)rid {
    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] init];
    detailVC.reviewsId = rid;
    detailVC.userId = userId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)jumpToCommunityAccountViewControllerWithUserId:(NSString *)userId {
    ZFCommunityAccountViewController *accountVC = [[ZFCommunityAccountViewController alloc] init];
    accountVC.userId = userId;
    [self.navigationController pushViewController:accountVC animated:YES];
}

- (ZFShareTopView *)configureZFShareTopViewWithModel:(ZFCommunityFavesItemModel *)model {
    ZFShareTopView *shareTopView = [[ZFShareTopView alloc] init];
    PictureModel *imageModel = (PictureModel *)model.reviewPic.firstObject;
    shareTopView.imageName = imageModel.bigPic;
    shareTopView.title = ZFLocalizedString(@"ZFShare_Community_post", nil);
    return shareTopView;
}

- (NativeShareModel *)adjustNativeShareModel {
    NativeShareModel *model = [[NativeShareModel alloc] init];
    NSString *nicknameStr = [NSString stringWithFormat:@"%@",self.favesItemModel.nickname];
    NSRange range = [nicknameStr rangeOfString:@" "];
    if (range.location != NSNotFound) {
        //有空格
        nicknameStr = [nicknameStr stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    }
    model.share_url =  [NSString stringWithFormat:@"%@?actiontype=6&url=2,%@,%@&name=%@&source=sharelink&lang=%@",CommunityShareURL,self.favesItemModel.reviewId,self.favesItemModel.userId,nicknameStr, [ZFLocalizationString shareLocalizable].nomarLocalizable];
    model.fromviewController = self;
    return model;
}

- (void)refreshAccountAvatorView {

    UIImageView *avatorView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 0, 24, 24)];
    avatorView.userInteractionEnabled = YES;
    avatorView.layer.cornerRadius = 12;
    avatorView.contentMode = UIViewContentModeScaleToFill;
    avatorView.clipsToBounds = YES;
    [avatorView yy_setImageWithURL:[NSURL URLWithString:[AccountManager sharedManager].account.avatar]
                      processorKey:NSStringFromClass([self class])
                       placeholder:[UIImage imageNamed:@"Account"]
                           options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                         transform:^UIImage *(UIImage *image, NSURL *url) {
                             return image;
                         }
                        completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                        }];
    [avatorView addTapGestureWithComplete:^(UIView * _Nonnull view) {
        [self accountButtonAction:nil];
    }];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 84, 24)];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:avatorView];
    
    UIBarButtonItem *accountItme = [[UIBarButtonItem alloc]initWithCustomView:containerView];
    self.navigationItem.rightBarButtonItem = accountItme;
    
}

#pragma mark - action methods
- (void)searchFriendsButtonAction:(UIButton *)sender {
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *signVC = [ZFLoginViewController new];
        @weakify(self);
        signVC.successBlock = ^{
            @strongify(self);
            [self refreshAccountAvatorView];
            ZFCommunitySearchFriendsViewController *friendVc = [[ZFCommunitySearchFriendsViewController alloc] init];
            [self.navigationController pushViewController:friendVc animated:YES];
        };
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
        [self.navigationController presentViewController:nav animated:YES completion:^{
        }];
        return ;
    }
    
    
    ZFCommunitySearchFriendsViewController *friendVc = [[ZFCommunitySearchFriendsViewController alloc] init];
    [self.navigationController pushViewController:friendVc animated:YES];
}

- (void)accountButtonAction:(UIButton *)sender {
    
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *signVC = [ZFLoginViewController new];
        @weakify(self);
        signVC.successBlock = ^{
            @strongify(self);
            [self refreshAccountAvatorView];
            ZFCommunityAccountViewController *accountVc = [[ZFCommunityAccountViewController alloc] init];
            accountVc.userId = USERID;
            [self.navigationController pushViewController:accountVc animated:YES];
        };
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
        [self.navigationController presentViewController:nav animated:YES completion:^{
        }];
        return ;
    }
    
    ZFCommunityAccountViewController *accountVc = [[ZFCommunityAccountViewController alloc] init];
    accountVc.userId = USERID;
    [self.navigationController pushViewController:accountVc animated:YES];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ZFCommunityListViewTypeOutfits) {
        ZFCommunityOutfitsListView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFCommunityOutfitsListViewIdentifier forIndexPath:indexPath];
        cell.controller = self;
        return cell;
    } else if (indexPath.section == ZFCommunityHomeSelectTypeExplore) {
        ZFCommunityExploreListView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFCommunityExploreListViewIdentifier forIndexPath:indexPath];
        cell.controller = self;
        @weakify(self);
        cell.communityExploreMoreVideoCompletionHandler = ^{
            @strongify(self);
            [self jumpToMoreVideoViewController];
        };
        
        cell.communityExploreMoreTopicCompletionHandler = ^{
            @strongify(self);
            [self jumpToMoreTopicViewController];
        };
        
        cell.communityExploreTopicCompletionHandler = ^(NSString *topic) {
            @strongify(self);
            [self jumpToTopicListViewControllerWithTitle:topic];
        };
        
        cell.communityExploreMoreVideoDetailCompletionHandler = ^(NSString *videoId) {
            @strongify(self);
            [self jumpToVideoDetailViewControllerWithVideoId:videoId];
        };
        
        cell.communityExploreBannerCompletionHandler = ^(BannerModel *bannerModel) {
            @strongify(self);
            [self jumpToBannerFromExploreBannerListWithBanner:bannerModel];
        };
        
        cell.communityExploreShareCompletionHandler = ^(ZFCommunityFavesItemModel *model) {
            @strongify(self);
            self.favesItemModel = model;
            self.shareView.topView = [self configureZFShareTopViewWithModel:model];
            [self.shareView open];
        };
        
        cell.communityExploreDetailCompletionHandler = ^(NSString *userId, NSString *reviewId) {
            @strongify(self);
            [self jumpToCommunityDetailViewControllerWithUserId:userId reviewsId:reviewId];
        };
        
        cell.communityExploreUserAccountCompletionHandler = ^(NSString *userId) {
            @strongify(self);
            [self jumpToCommunityAccountViewControllerWithUserId:userId];
        };
        
        return cell;
    } else if (indexPath.section == ZFCommunityHomeSelectTypeFaves) {
        ZFCommunityFavesListView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFCommunityFavesListViewIdentifier forIndexPath:indexPath];
        cell.controller = self;
        
        @weakify(self);
        cell.communityFavesListTopicCompletionHandler = ^(NSString *topic) {
            @strongify(self);
            [self jumpToTopicListViewControllerWithTitle:topic];
        };
        
        cell.communityFavesListDetailCompletionHandler = ^(NSString *userId, NSString *reviewId) {
            @strongify(self);
            [self jumpToCommunityDetailViewControllerWithUserId:userId reviewsId:reviewId];
        };
        
        cell.communityFavesListShareCompletionHandler = ^(ZFCommunityFavesItemModel *model) {
            @strongify(self);
            self.favesItemModel = model;
            self.shareView.topView = [self configureZFShareTopViewWithModel:model];
            [self.shareView open];
        };
        
        cell.communityFavesUserAccountCompletionHandler = ^(NSString *userId) {
            @strongify(self);
            [self jumpToCommunityAccountViewControllerWithUserId:userId];
        };
        
        cell.communityFavesAddMoreFriendsCompletionHandler = ^{
            @strongify(self);
            ZFCommunitySearchFriendsViewController *friendVc = [[ZFCommunitySearchFriendsViewController alloc] init];
            [self.navigationController pushViewController:friendVc animated:YES];
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
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 44);
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
    
    if (![SystemConfigUtils isRightToLeftShow]) {
        if (![AccountManager sharedManager].isSignIn && scrollView.contentOffset.x > SCREEN_WIDTH) {
            //如果没有登陆，则不让用户滑动到Faves模块列表
            self->_currentIndex = (scrollView.contentOffset.x / SCREEN_WIDTH) < 0 ? 0 : scrollView.contentOffset.x / SCREEN_WIDTH;
            [scrollView setContentOffset:CGPointMake(self->_currentIndex * SCREEN_WIDTH, scrollView.contentOffset.y)];
            self.selectView.currentType = self->_currentIndex;
            ZFLoginViewController *signVC = [ZFLoginViewController new];
            @weakify(self);
            signVC.successBlock = ^{
                @strongify(self);
                [self refreshAccountAvatorView];
            };
            ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
            [self.navigationController presentViewController:nav animated:YES completion:^{
            }];
            
        }
        self->_currentIndex = (scrollView.contentOffset.x / SCREEN_WIDTH) < 0 ? 0 : scrollView.contentOffset.x / SCREEN_WIDTH;
        self.selectView.currentType = self->_currentIndex;
    
    } else {
        if (![AccountManager sharedManager].isSignIn && scrollView.contentOffset.x < SCREEN_WIDTH && !self->_isFirstAraboEnter) {
            
            //如果没有登陆，则不让用户滑动到Faves模块列表
            self->_currentIndex = 2 - ((scrollView.contentOffset.x / SCREEN_WIDTH) > 2 ? 2 : scrollView.contentOffset.x / SCREEN_WIDTH);
            [scrollView setContentOffset:CGPointMake((2 - self->_currentIndex) * SCREEN_WIDTH, scrollView.contentOffset.y)];
            self.selectView.currentType = self->_currentIndex;
            ZFLoginViewController *signVC = [ZFLoginViewController new];
            @weakify(self);
            signVC.successBlock = ^{
                @strongify(self);
                [self refreshAccountAvatorView];
            };
            ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
            [self.navigationController presentViewController:nav animated:YES completion:^{
            }];
            
        }
        self->_currentIndex = 2 - ((scrollView.contentOffset.x / SCREEN_WIDTH) > 2 ? 2 : scrollView.contentOffset.x / SCREEN_WIDTH);
        self.selectView.currentType = self->_currentIndex;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self->_isFirstAraboEnter = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self->_isFirstAraboEnter = NO;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    [self configNavigationBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.collectionView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.postSuccessView];
}

- (void)zfAutoLayoutView {
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.view);
        make.height.mas_equalTo(@44);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectView.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(self.view);
    }];
    
    [self.postSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)configNavigationBar {
    self.title = ZFLocalizedString(@"Tabbar_Z-Me", nil);
    self.view.backgroundColor = ZFCOLOR_WHITE;
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(searchFriendsButtonAction:)];
    self.navigationItem.leftBarButtonItem = searchButton;
    [self refreshAccountAvatorView];
    
}

#pragma mark - getter
- (ZFCommunityViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityViewModel alloc] init];
    }
    return _viewModel;
}

- (ZFCommunityHomeSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[ZFCommunityHomeSelectView alloc] initWithFrame:CGRectZero];
        @weakify(self);
        _selectView.communityHomeSelectCompletionHandler = ^(ZFCommunityHomeSelectType type) {
            @strongify(self);
            [self.collectionView scrollRectToVisible:CGRectMake(![SystemConfigUtils isRightToLeftShow] ? type * SCREEN_WIDTH : (2 - type) * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) animated:NO];
            self->_isFirstAraboEnter = NO;
        };
        
        _selectView.communityLoginTipsCompletionHandler = ^{
            @strongify(self);
            ZFLoginViewController *signVC = [ZFLoginViewController new];
            signVC.successBlock = ^{
                @strongify(self);
                [self.collectionView reloadData];
                [self refreshAccountAvatorView];
            };
            ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
            [self.navigationController presentViewController:nav animated:YES completion:^{
            }];
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
        _collectionView.backgroundColor = ZFCOLOR_WHITE;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ZFCommunityOutfitsListView class] forCellWithReuseIdentifier:kZFCommunityOutfitsListViewIdentifier];
        [_collectionView registerClass:[ZFCommunityExploreListView class] forCellWithReuseIdentifier:kZFCommunityExploreListViewIdentifier];
        [_collectionView registerClass:[ZFCommunityFavesListView class] forCellWithReuseIdentifier:kZFCommunityFavesListViewIdentifier];
        
    }
    return _collectionView;
}

- (ZFShareView *)shareView {
    if (!_shareView) {
        _shareView = [[ZFShareView alloc] init];
        _shareView.delegate = self;
    }
    return _shareView;
}

- (ZFCommunityPostSuccessView *)postSuccessView {
    if (!_postSuccessView) {
        _postSuccessView = [[ZFCommunityPostSuccessView alloc] initWithFrame:CGRectZero];
        _postSuccessView.hidden = YES;
        @weakify(self);
        [_postSuccessView addTapGestureWithComplete:^(UIView * _Nonnull view) {
            @strongify(self);
            self.postSuccessView.hidden = YES;
        }];
    }
    return _postSuccessView;
}


@end
