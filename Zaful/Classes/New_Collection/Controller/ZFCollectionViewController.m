//
//  ZFCollectionViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCollectionViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFCollectionSingleColumnCell.h"
#import "ZFCollectionMultipleColumnCell.h"
#import "ZFGoodsDetailViewController.h"
#import "ZFCollectionModel.h"
#import "ZFCollectionViewModel.h"
#import "ZFCollectionListModel.h"
#import "PYSearchViewController.h"
#import "SearchResultViewController.h"
#import "ZFCartViewController.h"

static NSString *const kZFCollectionSingleColumnCellIdentifier = @"kZFCollectionSingleColumnCellIdentifier";
static NSString *const kZFCollectionMultipleColumnCellIdentifier = @"kZFCollectionMultipleColumnCellIdentifier";

@interface ZFCollectionViewController () <ZFInitViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionViewFlowLayout            *flowLayout;
@property (nonatomic, strong) UICollectionView                      *collectionView;
@property (nonatomic, assign) BOOL                                  isSingleColumn;
@property (nonatomic, strong) ZFCollectionViewModel                 *viewModel;
@property (nonatomic, strong) ZFCollectionListModel                 *listModel;
@property (nonatomic, strong) JSBadgeView                           *badgeView;
@end

@implementation ZFCollectionViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self zfInitView];
    [self zfAutoLayoutView];
    [self.collectionView.mj_header beginRefreshing];
    // 汇率改变的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCurrency) name:kCurrencyNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCollectionInfo) name:kCollectionGoodsNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginChangeCollectionRefresh) name:kLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginChangeCollectionRefresh) name:kLogoutNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNumber *badgeNum = [[NSUserDefaults standardUserDefaults] valueForKey:kCollectionBadgeKey];
    NSString * numberIndex = @"";
    if ([badgeNum integerValue] == 0) {
        self.badgeView.badgeText = nil;
        return;
    }
    if ([badgeNum integerValue]>99) {
        numberIndex = @"99+";
    } else
        numberIndex = [NSString stringWithFormat:@"%ld",(long)[badgeNum integerValue]];
    self.badgeView.badgeText = numberIndex;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification methods
- (void)changeCurrency {
    [self.collectionView reloadData];
}

- (void)refreshCollectionInfo {
    if (self.listModel.data.count == 0) {
        [self loginChangeCollectionRefresh];
        return ;
    }
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loginChangeCollectionRefresh {
    self.listModel = nil;
    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - private methods
- (void)configNavigationBar {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0],NSForegroundColorAttributeName:ZFCOLOR(51, 51, 51, 1.0)}];
    self.navigationItem.title = [NSString stringWithFormat:@"%@(0)",ZFLocalizedString(@"Collection_VC_Title",nil)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonAction:)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0,24,24)];
    [btn setImage:[UIImage imageNamed:@"bag"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showCartButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    UIBarButtonItem *listItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list1"] style:UIBarButtonItemStylePlain target:self action:@selector(changeLayoutButtonAction:)];
    
    self.navigationItem.rightBarButtonItems = @[listItem, negativeSpacer, buttonItem];
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.badgeView = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentTopLeft];
        self.badgeView.badgePositionAdjustment = CGPointMake(0, 5);
    } else {
        self.badgeView = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentTopRight];
        self.badgeView.badgePositionAdjustment = CGPointMake(15, -8);
    }
    self.badgeView.badgeBackgroundColor = BADGE_BACKGROUNDCOLOR;

}

- (void)deleteCollectionOptionWithModel:(ZFCollectionModel *)model andIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    [self.viewModel requestDeleteCollectionNetwork:model.goods_id completion:^(id obj) {
        @strongify(self);
        self.listModel.total = [NSString stringWithFormat:@"%ld",self.listModel.total.integerValue - 1];
        self.navigationItem.title = [NSString stringWithFormat:@"%@(%ld)",ZFLocalizedString(@"Collection_VC_Title",nil),(long)self.listModel.total.integerValue];
        [self.listModel.data removeObjectAtIndex:indexPath.row];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            if (self.listModel.data.count == 0) {
                [self emptyNoDataOption];
            }
            [self.collectionView reloadData];
        }];
        
    } failure:^(id obj) {
        [self.collectionView reloadData];
    }];

}

#pragma mark - action methods
- (void)searchButtonAction:(UIButton *)sender {
    // 谷歌统计
    [ZFAnalytics clickButtonWithCategory:@"Search" actionName:@"Search" label:@"Search"];
    [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Seach" itemName:@"Seach" ContentType:@"Search" itemCategory:@"Search"];
    
    NSArray *hotwordSearchArray = [[NSUserDefaults standardUserDefaults] valueForKey:KHotwordSearchKey];
    NSString *placeHolder = ZFLocalizedString(@"Search_PlaceHolder_Search",nil);
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotwordSearchArray searchBarPlaceholder:placeHolder didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        SearchResultViewController * searchResult = [[SearchResultViewController alloc]init];
        searchResult.searchString = searchText;
        searchResult.hidesBottomBarWhenPushed = YES;
        [searchViewController.navigationController pushViewController:searchResult animated:YES];
    }];
    [searchViewController.searchBar showCurrentViewBorder:1.0 color:[UIColor lightGrayColor]];
    searchViewController.hotSearchStyle = PYHotSearchStyleBorderTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleBorderTag;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];

}

- (void)changeLayoutButtonAction:(UIButton *)sender {
    self.isSingleColumn = !self.isSingleColumn;
}

- (void)showCartButtonAction:(UIButton *)sender {
    ZFCartViewController *cartVC = [[ZFCartViewController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
    
    // 统计
    [ZFFireBaseAnalytics selectContentWithItemId:@"Click_bag" itemName:@"Collection_bag" ContentType:@"Bag" itemCategory:@"Bag"];
    [ZFAnalytics clickButtonWithCategory:@"bag" actionName:@"Click_bag" label:@"Click_bag"];
}

- (void)reloadOutfitsData:(UIButton *)sender {
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listModel.data.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSingleColumn) {
        ZFCollectionSingleColumnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFCollectionSingleColumnCellIdentifier forIndexPath:indexPath];
        cell.model = self.listModel.data[indexPath.row];
        @weakify(self);
        cell.collectionDelectCompletionHandler = ^(ZFCollectionModel *model) {
            @strongify(self);
            [self deleteCollectionOptionWithModel:model andIndexPath:indexPath];
        };
        return cell;
    } else {
        ZFCollectionMultipleColumnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFCollectionMultipleColumnCellIdentifier forIndexPath:indexPath];
        cell.model = self.listModel.data[indexPath.row];
        @weakify(self);
        cell.collectionDelectCompletionHandler = ^(ZFCollectionModel *model) {
            @strongify(self);
            [self deleteCollectionOptionWithModel:model andIndexPath:indexPath];
        };
        return cell;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.isSingleColumn ? CGSizeMake(SCREEN_WIDTH, 120 * SCREEN_WIDTH_SCALE + 52) : CGSizeMake((collectionView.bounds.size.width - 48) / 2, 218 * SCREEN_WIDTH_SCALE + 58);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.isSingleColumn ? 0 : 16;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (!self.isSingleColumn) {
        return  UIEdgeInsetsMake(16, 16, 0, 16);
    } else {
        return  UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFCollectionModel *model = self.listModel.data[indexPath.row];
    ZFGoodsDetailViewController *detailVC = [[ZFGoodsDetailViewController alloc] init];
    detailVC.goodsId = model.goods_id;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    // 谷歌统计
    [ZFAnalytics clickCollectionProductWithProduct:model position:(int)self.listModel.page actionList:@"Wishlist"];
}

- (void)emptyNoDataOption {
    @weakify(self);
    [self.collectionView zf_configureWithPlaceHolderBlock:^UIView * _Nonnull(UICollectionView * _Nonnull sender) {
        @strongify(self);
        self.collectionView.scrollEnabled = NO;
        UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
        YYAnimatedImageView *imageView = [YYAnimatedImageView new];
        imageView.image = [UIImage imageNamed:@"favorites"];
        [customView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(customView.mas_top).mas_offset(105 * DSCREEN_HEIGHT_SCALE);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = ZFLocalizedString(@"CollectionViewModel_NoData_Tip",nil);;
        [customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(20);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = ZFCOLOR(51, 51, 51, 1);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:ZFLocalizedString(@"VideoViewViewModel_Refresh",nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(reloadOutfitsData:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 3;
        [customView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(33);
            make.centerX.mas_equalTo(customView.mas_centerX);
            make.width.mas_equalTo(@180);
            make.height.mas_equalTo(@40);
        }];
        return customView;
        
    } normalBlock:^(UICollectionView * _Nonnull sender) {
        @strongify(self);
        self.collectionView.scrollEnabled = YES;
    }];

}


#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    
    self.view.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    [self.view addSubview:self.collectionView];
}

- (void)zfAutoLayoutView {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - setter
- (void)setIsSingleColumn:(BOOL)isSingleColumn {
    _isSingleColumn = isSingleColumn;
    [self.collectionView reloadData];
    self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:_isSingleColumn ? @"list2" : @"list1"];
}

#pragma mark - getter
- (ZFCollectionViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCollectionViewModel alloc] init];
    }
    return _viewModel;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZFCollectionSingleColumnCell class] forCellWithReuseIdentifier:kZFCollectionSingleColumnCellIdentifier];
        [_collectionView registerClass:[ZFCollectionMultipleColumnCell class] forCellWithReuseIdentifier:kZFCollectionMultipleColumnCellIdentifier];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        @weakify(self);
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestCollectionNetwork:Refresh completion:^(id obj) {
                self.listModel = obj;
                if (self.listModel.data.count == 0) {
                    [self.collectionView reloadData];
                }
             
                self.navigationItem.title = [NSString stringWithFormat:@"%@(%ld)",ZFLocalizedString(@"Collection_VC_Title",nil),(long)self.listModel.total.integerValue];
                self.collectionView.mj_footer.hidden = NO;
                [self emptyNoDataOption];
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
            } failure:^(id obj) {
                @strongify(self);
                if (self.listModel.data.count == 0) {
                    [self emptyNoDataOption];
                }
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
            }];
        }];
        
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestCollectionNetwork:LoadMore completion:^(id obj) {
                @strongify(self);
                if ([obj isEqual:NoMoreToLoad]) {
                    [self.collectionView.mj_footer endRefreshing];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.collectionView.mj_footer.hidden = YES;
                    }];
                } else {
                    self.listModel = obj;
                    self.navigationItem.title = [NSString stringWithFormat:@"%@(%ld)",ZFLocalizedString(@"Collection_VC_Title",nil),(long)self.listModel.total.integerValue];
                    [self.collectionView reloadData];
                    [self.collectionView.mj_footer endRefreshing];
                }

            } failure:^(id obj) {
                @strongify(self);
                [self.collectionView.mj_footer endRefreshing];
            }];
        }];
    }
    return _collectionView;
} 
@end
