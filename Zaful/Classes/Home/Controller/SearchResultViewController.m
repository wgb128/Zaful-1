//
//  SearchResultViewController.m
//  Dezzal
//
//  Created by Y001 on 16/8/10.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchResultViewModel.h"
#import "ZFCartViewController.h"
#import "JSBadgeView.h"

@interface SearchResultViewController ()
@property (nonatomic, strong) SearchResultViewModel                 *viewModel;
@property (nonatomic, assign) LoadingViewShowType                   loadingViewShowType;
@property (nonatomic, strong) UITableView                           *tableView;
@property (nonatomic, strong) JSBadgeView                           *badgeView;
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout      *waterFallLayout;
@property (nonatomic, strong) UICollectionView                      *collectionView;
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchString = self.searchString == nil ? @"": self.searchString;
    [self setUI];
    [self initViews];
    [self requestListData];
    [self.collectionView.mj_header beginRefreshing];
    
    // 统计
    [ZFAnalytics appsFlyerTrackEvent:@"af_search" withValues:@{
                                                               @"af_content_type" : self.searchString
                                                               }];
    [ZFFireBaseAnalytics searchResultWithTerm:self.searchString];
    [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"SearchResult_KeyWords_%@", self.searchString] itemName:self.searchString ContentType:@"SearchKeyWords" itemCategory:@"Goods"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     
    [ZFAnalytics screenViewQuantityWithScreenName:[NSString stringWithFormat:@"Search - %@",self.searchString]];
    NSNumber *badgeNum = [[NSUserDefaults standardUserDefaults] valueForKey:kCollectionBadgeKey];
    NSString * numberIndex = @"";
    if ([badgeNum integerValue] == 0) {
        self.badgeView.badgeText = nil;
        return;
    }
    if ([badgeNum integerValue]>99) {
        numberIndex = @"99+";
    }
    else
        numberIndex = [NSString stringWithFormat:@"%ld",(long)[badgeNum integerValue]];
    self.badgeView.badgeText = numberIndex;
}

- (void)loadHead {
    @weakify(self)
    // 谷歌统计
    [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kStartLoadingSearchList];
    [self.viewModel requestNetwork:@[Refresh,_searchString] completion:^(id obj) {
        @strongify(self)
        // 谷歌统计
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingSearchList];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        self.collectionView.mj_footer.hidden = NO;
    } failure:^(id obj) {
        @strongify(self)
        // 谷歌统计
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingSearchList];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadFoot {
    @weakify(self)
    // 谷歌统计
    [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kStartLoadingSearchList];
    [self.viewModel requestNetwork:@[LoadMore,_searchString]  completion:^(id obj) {
        //self.viewModel.showErrorEmpty = NO;
        @strongify(self)
        // 谷歌统计
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingSearchList];
        [self.collectionView reloadData];
        if([obj isEqual: NoMoreToLoad]) {
            // 无法加载更多的时候
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            self.collectionView.mj_footer.hidden = YES;
        }else {
            [self.collectionView.mj_footer endRefreshing];
        }
    } failure:^(id obj) {
        @strongify(self)
        // 谷歌统计
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingSearchList];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - requestMethod

- (void)requestListData {
    @weakify(self)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self loadHead];
    }];
    self.collectionView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [self loadFoot];
    }];
    self.collectionView.mj_footer = footer;
}

#pragma mark 布局
- (void)setUI {
    self.navigationItem.title = _searchString;
    [self.view setBackgroundColor:ZFCOLOR(245, 245, 245, 1.0)];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0,24,24)];
    [btn setImage:[UIImage imageNamed:@"bag"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cartIconClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, buttonItem];

    if ([SystemConfigUtils isRightToLeftShow]) {
        self.badgeView = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentTopLeft];
        self.badgeView.badgePositionAdjustment = CGPointMake(0, 5);
    } else {
        self.badgeView = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentTopRight];
        self.badgeView.badgePositionAdjustment = CGPointMake(15, -8);
    }
    
    self.badgeView.badgeBackgroundColor = BADGE_BACKGROUNDCOLOR;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cartIconClick)];
    [self.badgeView addGestureRecognizer:tapGesture];
}

- (void)initViews {
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
}

#pragma mark - Action
/**
 *  购物车
 */
- (void)cartIconClick {
    // 统计
    [ZFFireBaseAnalytics selectContentWithItemId:@"Click_bag" itemName:@"SearchResult - bag" ContentType:@"Bag" itemCategory:@"Bag"];
    ZFCartViewController *cartVC = [[ZFCartViewController alloc] init];
    
    [self.navigationController pushViewController:cartVC animated:YES];
}

#pragma mark - 懒加载
- (CHTCollectionViewWaterfallLayout *)waterFallLayout {
    if (!_waterFallLayout) {
        _waterFallLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        _waterFallLayout.columnCount = 2;
        _waterFallLayout.minimumColumnSpacing = 10;
        _waterFallLayout.minimumInteritemSpacing = 10;
        _waterFallLayout.sectionInset = UIEdgeInsetsMake(0,12 , 0, 12);
    }
    return _waterFallLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        _waterFallLayout.headerHeight = 74;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.waterFallLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self.viewModel;
        _collectionView.delegate = self.viewModel;
        _collectionView.emptyDataSetDelegate = self.viewModel;
        _collectionView.emptyDataSetSource = self.viewModel;
        _collectionView.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
    }
    return _collectionView;
}

- (SearchResultViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SearchResultViewModel alloc]init];
        _viewModel.viewController = self;
        _viewModel.searchTitle = _searchString;
        @weakify(self);
        _viewModel.searchResultReloadDataCompletionHandler = ^{
            @strongify(self);
            [self.collectionView.mj_header beginRefreshing];
        };
    }
    return _viewModel;
}

@end
