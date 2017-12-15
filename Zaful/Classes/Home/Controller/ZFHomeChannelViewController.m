//
//  ZFHomeChannelViewController.m
//  Zaful
//
//  Created by QianHan on 2017/10/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomeChannelViewController.h"
#import "ZFGoodsDetailViewController.h"

#import "HomeBannerCell.h"
#import "HomeAndCategoryCell.h"
#import "HomeBannerCell.h"
#import "HomeCategoryCell.h"
#import "HomeSpecialCell.h"
#import "HomeGoodsHeadView.h"

#import "ZFHomeChannelViewModel.h"

static NSString *const kBannerIdentifer          = @"kBannerIdentifer";
static NSString *const kNewGoodsIdentifer        = @"kNewGoodsIdentifer";
static NSString *const kHomeGoodsHeaderIdentifer = @"kHomeGoodsHeaderIdentifer";

@interface ZFHomeChannelViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSString *tabType;
@property (nonatomic, copy) NSString *pageNO;
@property (nonatomic, strong) UICollectionView *homeCollectionView;
@property (nonatomic, strong) ZFHomeChannelViewModel *viewModel;

@end

@implementation ZFHomeChannelViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self initData];
    [self requestHomeChannel];
    [self requestRefresh];
    
    // 汇率改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurrency) name:kCurrencyNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [ZFAnalytics screenViewQuantityWithScreenName:[NSString stringWithFormat:@"%@ Channel", self.title]];
}

#pragma mark - init
- (void)setupView {
    [self.view addSubview:self.homeCollectionView];
}

- (void)initData {
    self.viewModel = [[ZFHomeChannelViewModel alloc] init];
    self.pageNO    = [NSString stringWithFormat:@"%d", 1];
}

#pragma mark - request
- (void)requestHomeChannel {
    
    if ([NoNetworkReachabilityManager shareManager].networkStatus == AFNetworkReachabilityStatusNotReachable) {
        [self.view zf_showNetworkBlankViewWithAction:^(NSInteger index) {
            [self requestHomeChannel];
        }];
        return;
    }
    
    if ([self.pageNO integerValue] <= 1) {
        [MBProgressHUD showLoadingView:nil];
    }
    
    NSDictionary *params = @{
                             @"channel_id": self.tabType,
                             @"page": self.pageNO
                             };
    [self.viewModel requestHomeChannelWithParam:params completeHandler:^{
        
        [self.homeCollectionView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        if (!self.viewModel.isSuccess) {
            
            [self.homeCollectionView.mj_footer endRefreshing];
            if ([self.viewModel.message length] > 0) {
                [MBProgressHUD showMessage:self.viewModel.message];
            }
            
            if ([self.pageNO integerValue] > 1) {
                self.pageNO = [NSString stringWithFormat:@"%ld", [self.pageNO integerValue] - 1];
            }
            [self emptyData];
            return;
        }
        
        [self.homeCollectionView reloadData];
        
        // 是否可以加载更多
        if ([self.pageNO integerValue] == 1
            && self.viewModel.totalPage > 1) {
            self.homeCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                self.pageNO    = [NSString stringWithFormat:@"%ld", self.viewModel.currentPage + 1];
                [self requestHomeChannel];
            }];
        }
        
        if ([self.pageNO integerValue] == self.viewModel.totalPage) {
            [self.homeCollectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.homeCollectionView.mj_footer endRefreshing];
        }
        
        [self emptyData];
    }];
}

#pragma mark - event
- (void)requestRefresh {
    
    self.homeCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNO = [NSString stringWithFormat:@"%d", 1];
        [self requestHomeChannel];
    }];
}

- (void)changeCurrency {
    
    [self requestRefresh];
}

#pragma mark - Delegate
#pragma mark - UICollectionDelegate/UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.channelItems.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ZFHomeChannelBaseViewModel *rowViewModel = self.viewModel.channelItems[section];
    return rowViewModel.rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFHomeChannelBaseViewModel *rowViewModel = self.viewModel.channelItems[indexPath.section];
    
    switch (rowViewModel.type) {
        case ZFHomeChannelBanner: {
            
            ZFHomeChannelBannerViewModel *bannerViewModel = (ZFHomeChannelBannerViewModel *)rowViewModel;
            HomeSpecialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerIdentifer
                                                                              forIndexPath:indexPath];
            cell.homeBannerModel   = bannerViewModel.banners[indexPath.row];
            cell.specialClick = ^(BannerModel * homeBannerModel) {
                [BannerManager doBannerActionTarget:self withBannerModel:homeBannerModel];
                
                NSString *GABannerId = homeBannerModel.key;
                NSString *GABannerName = [NSString stringWithFormat:@"ChannelBannerSession - %@",homeBannerModel.title];
                NSString *position = [NSString stringWithFormat:@"ChannelBannerSession - P%ld",(long)(indexPath.row + 1)];
                [ZFAnalytics clickAdvertisementWithId:GABannerId name:GABannerName position:position];
                // 统计
                [ZFAnalytics appsFlyerTrackEvent:@"af_view_list" withValues:@{
                                                                              @"af_content_type" : [NSString stringWithFormat:@"ChannelBanner/%@", homeBannerModel.title]
                                                                              }];
                
                // firebase 统计
                NSString *itemId = [NSString stringWithFormat:@"Click_Channel_%@_Banner%ld_%@", self.title, (indexPath.row + 1), homeBannerModel.title];
                [ZFFireBaseAnalytics selectContentWithItemId:itemId itemName:homeBannerModel.title ContentType:@"Home - Banner" itemCategory:@"channel_banner"];
                [ZFAnalytics clickButtonWithCategory:@"Channel" actionName:itemId label:itemId];
            };
            return cell;
            break;
        }
        case ZFHomeChannelNewGoods: {
            ZFHomeChannelNewGoodsViewModel *newGoodsViewModel = (ZFHomeChannelNewGoodsViewModel *)rowViewModel;
            HomeAndCategoryCell *cell = [HomeAndCategoryCell homeAndCategoryCollectionViewWith:collectionView
                                                                                  forIndexPath:indexPath
                                                                                        forRow:indexPath.row];
            cell.goodsModel = newGoodsViewModel.goodsArray[indexPath.row];
            cell.goodsClick = ^(GoodsModel * goodsModel) {
                
                ZFGoodsDetailViewController *vc = [ZFGoodsDetailViewController new];
                vc.goodsId = [NSString stringWithFormat:@"%ld",(long)goodsModel.goods_id];
                [self.navigationController pushViewController:vc animated:YES];
                //谷歌统计
                [ZFAnalytics clickProductWithProduct:goodsModel position:1 actionList:[NSString stringWithFormat:@"Channel - %@ - List", self.title]];
                [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_Channel_%@_Goods_%ld", self.title, goodsModel.goods_id] itemName:goodsModel.goods_title ContentType:@"Goods" itemCategory:@"Goods"];
            };
            return cell;
            break;
        }
        default:
            break;
    }
    return [UICollectionViewCell new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel rowSizeAtIndexPath:indexPath];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    ZFHomeChannelBaseViewModel *rowViewModel = self.viewModel.channelItems[section];
    return rowViewModel.minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    ZFHomeChannelBaseViewModel *rowViewModel = self.viewModel.channelItems[section];
    return rowViewModel.minimumInteritemSpacing;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    ZFHomeChannelBaseViewModel *rowViewModel = self.viewModel.channelItems[indexPath.section];
    HomeGoodsHeadView * headView;
    headView = [HomeGoodsHeadView homeGoodsHeadViewWithCollectionView:collectionView Kind:kind IndexPath:indexPath];
    if ([kind isEqualToString: UICollectionElementKindSectionHeader] ) {
        if (rowViewModel.type == ZFHomeChannelNewGoods
            && self.viewModel.channelItems.count > 1) {
            
            headView.titleLabel.hidden = NO;
            headView.titleLabel.text   = rowViewModel.headerTitle;
            headView.titleLabel.adjustsFontSizeToFitWidth = YES;
            return headView;
        } else {
            
            headView.titleLabel.hidden = YES;
            return headView;
        }
    } else if ([kind isEqualToString: UICollectionElementKindSectionFooter]) {
        
        headView.titleLabel.hidden = YES;
        return headView;
    }
    return headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    ZFHomeChannelBaseViewModel *rowViewModel = self.viewModel.channelItems[section];
    return rowViewModel.headerSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    ZFHomeChannelBaseViewModel *rowViewModel = self.viewModel.channelItems[section];
    return rowViewModel.edgeInsets;
}

#pragma mark - private
- (void)emptyData {
    if (self.viewModel.channelItems.count <= 0) {
        [self.view zf_showRequestBlankViewWithAction:^(NSInteger index) {
            [self requestHomeChannel];
        }];
    }
}

#pragma mark - getter/setter
- (UICollectionView *)homeCollectionView {
    if (!_homeCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _homeCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _homeCollectionView.delegate   = self;
        _homeCollectionView.dataSource = self;
        _homeCollectionView.showsVerticalScrollIndicator   = NO;
        _homeCollectionView.showsHorizontalScrollIndicator = NO;
        _homeCollectionView.alwaysBounceVertical           = YES;
        _homeCollectionView.backgroundColor                = [UIColor clearColor];
        _homeCollectionView.autoresizingMask               = UIViewAutoresizingFlexibleHeight;
        
        [_homeCollectionView registerClass:[HomeSpecialCell class] forCellWithReuseIdentifier:kBannerIdentifer];
        [_homeCollectionView registerClass:[HomeAndCategoryCell class] forCellWithReuseIdentifier:kNewGoodsIdentifer];
        
        [_homeCollectionView registerClass:[HomeGoodsHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeGoodsHeaderIdentifer];
    }
    return _homeCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
