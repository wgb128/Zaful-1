//
//  CategoryVirtualViewController.m
//  ListPageViewController
//
//  Created by TsangFa on 5/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryVirtualViewController.h"
#import "CategoryDropDownMenu.h"
#import "CategorySelectView.h"
#import "CategoryListPageCell.h"
#import "ZFCategoryCODGuideView.h"
#import "CategoryListPageViewModel.h"
#import "TLYShyNavBarManager.h"
#import "CategoryRefineContainerView.h"
#import "CategoryRefineSectionModel.h"
#import "CategoryNewModel.h"
#import "ZFGoodsDetailViewController.h"
#import "ZFCartViewController.h"
#import "PYSearchViewController.h"
#import "SearchResultViewController.h"

static CGFloat const KMenuHeight = 44.0f;
static NSString * const kIsShowCODGuideView = @"kIsShowCODGuideView";

@interface CategoryVirtualViewController () {
    
    BOOL _isFromHome;
}

@property (nonatomic, strong) CategoryDropDownMenu        *menu;
@property (nonatomic, strong) CategorySelectView          *selectView;
@property (nonatomic, strong) CategoryListPageViewModel   *viewModel;
@property (nonatomic, strong) UICollectionView            *listPageView;
@property (nonatomic, strong) NSMutableArray              *menuTitles;
@property (nonatomic, strong) NSArray<NSString *>         *sortRequests;
@property (nonatomic, strong) NSArray<CategoryNewModel *>    *virtualArray;
@property (nonatomic, strong) NSArray<CategoryPriceListModel *>  *priceListArray;
@property (nonatomic, copy)   NSString                    *navTitle;
@property (nonatomic, strong) UIView                      *againRequestView;
@property (nonatomic, strong) JSBadgeView                 *badgeView;
@property (nonatomic, strong) CategoryPriceListModel      *virtualPriceModel;
@property (nonatomic, copy)   NSString                    *categoryID;
@property (nonatomic, copy)   NSString                    *sortType;
@property (nonatomic, copy) NSString *tabType; // 配合WMPageViewController使用的（必须的）

@end

@implementation CategoryVirtualViewController

- (instancetype)initInHome {
    if (self = [super init]) {
        _isFromHome = YES;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavgationItem];
    [self configureSubViews];
    [self autoLayoutSubViews];
    [self configureNavgationBar];
    [self loadAllData];
    
    // 汇率改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurrency) name:kCurrencyNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /**
     *  此方法是为了防止控制器的title发生偏移，造成这样的原因是因为返回按钮的文字描述占位
     */
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    
    if ([viewControllerArray containsObject:self]) {
        long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
        UIViewController *previous;
        if (previousViewControllerIndex >= 0) {
            previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
            previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:nil];
        }
    }
    
    NSNumber *badgeNum = [[NSUserDefaults standardUserDefaults] valueForKey:kCollectionBadgeKey];
    NSString * numberIndex = @"";
    if ([badgeNum integerValue] == 0) {
        self.badgeView.badgeText = nil;
        return;
    }
    numberIndex = [badgeNum integerValue] > 99 ? @"99+" :[NSString stringWithFormat:@"%ld",(long)[badgeNum integerValue]];
    self.badgeView.badgeText = numberIndex;

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([SystemConfigUtils isRightToLeftShow]
        && !_isFromHome) {
        [self showCODGuideWithIsCategory:NO];
    }
}

#pragma mark - Init Methods
- (void)configureSubViews{
    [self.view addSubview:self.listPageView];
    if (!_isFromHome) {
        [self.view addSubview:self.selectView];
        [self.view addSubview:self.menu];
        self.menu.hidden = NO;
    } else {
        self.menu.height = 0.0;
        self.menu.hidden = YES;
    }
}

- (void)autoLayoutSubViews {
    if (!_isFromHome) {
        [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.menu.mas_bottom);
            make.leading.trailing.bottom.equalTo(self.view);
        }];
        
        [self.listPageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.menu.mas_bottom);
            make.leading.trailing.bottom.equalTo(self.view);
        }];
    } else {
        [self.listPageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.leading.trailing.bottom.equalTo(self.view);
        }];
    }
}

- (void)configureNavgationItem {
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

#pragma mark - Target Action
- (void)cartIconClick {
    ZFCartViewController *cartVC = [[ZFCartViewController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
    
    // 统计
    [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Bag" itemName:@"CategoryVirtual_bag" ContentType:@"Bag" itemCategory:@"Bag"];
    [ZFAnalytics clickButtonWithCategory:@"bag" actionName:@"Click_bag" label:@"Click_bag"];
}

- (void)changeCurrency {
    
    [self loadAllData];
}

#pragma mark - Private Methods
- (void)loadAllData{
    [self loadVirtualData];
    self.navTitle = self.virtualTitle;
    self.title = self.navTitle;
    self.menu.titles = self.menuTitles;
}

- (NSArray *)loadCategoryData {
    NSArray *categoryArray;
    if ([self.virtualType isEqualToString:@"deals"]) {
        categoryArray = self.priceListArray;
        self.selectView.isPriceList = YES;
    }else{
        categoryArray = self.virtualArray;
    }
    return categoryArray;
}

- (void)loadVirtualData {
    NSDictionary *parmaters = @{
                                @"page"      : Refresh,
                                @"cat_id"    : self.categoryID == nil ? @"" : self.categoryID,
                                @"order_by"  : self.sortType == nil ? @"" : self.sortType,
                                @"type"      : self.virtualType == nil ? @"" : self.virtualType,
                                @"price_min" : self.virtualPriceModel ? [@(self.virtualPriceModel.price_min) stringValue] : @"",
                                @"price_max" : self.virtualPriceModel ? [@(self.virtualPriceModel.price_max) stringValue] : @""
                                };
    @weakify(self)
    [self.viewModel requestVirtualDataWithParmaters:parmaters completion:^(id obj) {
        @strongify(self)
        [ZFFireBaseAnalytics scanGoodsListWithCategory:(self.categoryID == nil ? @"" : self.categoryID)];
        if ([obj isEqual:@(LoadingViewNoDataType)]) {
            [self showAgainRequest:obj];
        }
        [self reloadListPageItem];
    } failure:^(id obj) {
        [self showAgainRequest:obj];
    }];
}

- (void)loadMoreVirtualData:(id)parmaters {
    @weakify(self)
    [self.viewModel requestVirtualDataWithParmaters:parmaters completion:^(id obj) {
        @strongify(self)
        [self reloadListPageItem];
        if ([obj  isEqual: NoMoreToLoad]) {
            [self.listPageView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
    } failure:^(id obj) {
        @strongify(self)
        [self.listPageView.mj_footer endRefreshing];
    }];
}

- (void)reloadListPageItem{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView performWithoutAnimation:^{
            [self.listPageView reloadData];
        }];
    });
    [self.listPageView.mj_footer endRefreshing];
}

- (void)configureSelectDataType:(NSInteger)dataType select:(BOOL)isSelect {
    if (!isSelect) {
        [self.selectView dismiss];
        return;
    }
    self.selectView.dataType = dataType;
    if (dataType == SelectViewDataTypeCategory) {
        self.selectView.currentCategory = self.selectView.currentCategory ? self.selectView.currentCategory : @"";
        self.selectView.categoryArray = [self loadCategoryData];
    }else{
        NSString *defaultSort = [self.virtualType isEqualToString:@"new"] ? @"New Arrivals" : @"Recommend";
        self.selectView.currentSortType = self.selectView.currentSortType.length > 0 ? self.selectView.currentSortType : defaultSort;
        if ([SystemConfigUtils isRightToLeftShow]) {
            self.selectView.sortArray = @[ZFLocalizedString(@"GoodsSortViewController_Type_Recommend", nil),
                                          ZFLocalizedString(@"GoodsSortViewController_Type_COD", nil),
                                          ZFLocalizedString(@"GoodsSortViewController_Type_New", nil),
                                          ZFLocalizedString(@"GoodsSortViewController_Type_LowToHigh", nil),
                                          ZFLocalizedString(@"GoodsSortViewController_Type_HighToLow", nil)
                                          ];
            
        } else {
            self.selectView.sortArray = @[ZFLocalizedString(@"GoodsSortViewController_Type_Recommend", nil),
                                          ZFLocalizedString(@"GoodsSortViewController_Type_New", nil),
                                          ZFLocalizedString(@"GoodsSortViewController_Type_LowToHigh", nil),
                                          ZFLocalizedString(@"GoodsSortViewController_Type_HighToLow", nil)
                                          ];
        }
    }
    
    [self.selectView showCompletion:^{
        
    }];
}

- (void)configureNavgationBar {
    self.view.backgroundColor = ZFCOLOR(51, 51, 51, 1);
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    // 配置上滑隐藏导航栏.下滑显示
    if (!_isFromHome
        && !IPHONE_X_5_15) {
        self.shyNavBarManager.scrollView = self.listPageView;
        [self.shyNavBarManager setExtensionView:self.menu];
        self.shyNavBarManager.expansionResistance = 100;
        self.shyNavBarManager.contractionResistance = 50;
    }
}

- (void)showAgainRequest:(id)state {
    _againRequestView = [[UIView alloc]initWithFrame:CGRectZero];
    [_againRequestView setBackgroundColor:ZFCOLOR(245, 245, 245, 1.0)];
    [self.view addSubview:_againRequestView];
    [_againRequestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menu.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    NSString *title;
    if ([state isEqual:@(LoadingViewNoDataType)]) {
        title = [NSString stringWithFormat:ZFLocalizedString(@"CategoryNoDate",nil),self.navTitle] ;
    }else{
        title = ZFLocalizedString(@"Global_NO_NET_404",nil);
    }
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.text = title;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [titleLabel setBackgroundColor:ZFCOLOR(245, 245, 245, 1)];
    [titleLabel setTextColor:ZFCOLOR(51, 51, 51, 1)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setUserInteractionEnabled:YES];
    titleLabel.numberOfLines = 0;
    titleLabel.preferredMaxLayoutWidth = KScreenWidth - 10;
    
    [_againRequestView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_againRequestView);
        make.width.mas_equalTo(KScreenWidth - 20);
    }];
    
    UITapGestureRecognizer * gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(againRequest)];
    [titleLabel addGestureRecognizer:gest];
    [_againRequestView addSubview:titleLabel];
}

- (void)againRequest {
    [_againRequestView removeFromSuperview];
    [self loadVirtualData];
}

- (void)showCODGuideWithIsCategory:(BOOL)isCategory {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isShowCODGuide = [userDefault boolForKey:kIsShowCODGuideView];
    if (!isShowCODGuide) {
        ZFCategoryCODGuideView *codGuideView = [[ZFCategoryCODGuideView alloc] initWithGuideAreas:[self codGuideAreasWithIsCategory:isCategory]];
        [codGuideView show];
        if (isCategory) {
            [self.menu animateIndicatorWithIndex:1];
        } else {
            if ([SystemConfigUtils isRightToLeftShow]) {
                [self.menu animateIndicatorWithIndex:0];
            } else {
                [self.menu animateIndicatorWithIndex:1];
            }
        }
        [userDefault setBool:YES forKey:kIsShowCODGuideView];
        [userDefault synchronize];
    }
}

- (NSArray <NSValue *> *)codGuideAreasWithIsCategory:(BOOL)isCategory {
    if (isCategory) {
        CGRect rect1 = CGRectMake(self.menu.width / 3 + 4.0, 2.0, self.menu.width / 3 - 8.0, self.menu.height - 4.0);
        return [self guideRectsWithSortRect:rect1];
    } else {
        if ([SystemConfigUtils isRightToLeftShow]) {
            CGRect rect1 = CGRectMake(4.0, 2.0, self.menu.width / 2 - 8.0, self.menu.height - 4.0);
            return [self guideRectsWithSortRect:rect1];
        } else {
            CGRect rect1 = CGRectMake(self.menu.width / 2 + 4.0, 2.0, self.menu.width / 2 - 8.0, self.menu.height - 4.0);
            return [self guideRectsWithSortRect:rect1];
        }
    }
    return nil;
}

- (NSArray *)guideRectsWithSortRect:(CGRect)sortRect {
    
    NSMutableArray *array = [NSMutableArray new];
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect windowRect1  = CGRectMake(sortRect.origin.x, sortRect.origin.y + self.navigationController.navigationBar.height + rectStatus.size.height, sortRect.size.width, sortRect.size.height);
    NSValue *valueRect1 = [NSValue valueWithCGRect:windowRect1];
    [array addObject:valueRect1];
    
    CGRect windowRect2  = CGRectMake(10.0, windowRect1.origin.y + windowRect1.size.height + 44.0f, self.menu.width - 20.0, 44.0f);
    NSValue *valueRect2 = [NSValue valueWithCGRect:windowRect2];
    [array addObject:valueRect2];
    
    return array;
}

#pragma mark - Getter
- (CategoryDropDownMenu *)menu {
    if (!_menu) {
        _menu = [[CategoryDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:KMenuHeight];
        @weakify(self)
        _menu.chooseCompletionHandler = ^(NSInteger tapIndex, BOOL isSelect) {
            @strongify(self)
            [self.againRequestView removeFromSuperview];
            NSString *title = self.menu.titles[tapIndex];
            if ([title isEqualToString:ZFLocalizedString(@"Category_Item_Segmented_Category", nil)]) {
                [self configureSelectDataType:SelectViewDataTypeCategory select:isSelect];
            } else if ([title isEqualToString:ZFLocalizedString(@"Category_Item_Segmented_Sort", nil)]) {
                [self configureSelectDataType:SelectViewDataTypeSort select:isSelect];
            }
        };
    }
    return _menu;
}

- (CategorySelectView *)selectView {
    if (!_selectView) {
        _selectView = [[CategorySelectView alloc] init];
        @weakify(self)
        _selectView.selectCompletionHandler = ^(NSInteger tag, SelectViewDataType type) {
            @strongify(self)
            [self.menu restoreIndicator:type];

            if (type == SelectViewDataTypeCategory) {
                if ([self.virtualType isEqualToString:@"deals"]) {
                    self.virtualPriceModel = self.priceListArray[tag];
                    [self loadVirtualData];
                }else{
                     CategoryNewModel *model = self.selectView.categoryArray[tag];
                    self.categoryID = model.cat_id;
                    self.viewModel.lastCategoryID = @"";
                    self.selectView.currentSortType = @"";
                    self.selectView.currentCategory = model.cat_name;
                    self.navTitle = model.cat_name;
                    [self loadVirtualData];
                    self.title = self.navTitle;
                }
            }else if (type == SelectViewDataTypeSort) {
                self.sortType = self.sortRequests[tag];
                self.viewModel.lastCategoryID = @"1-s";
                [self loadVirtualData];
            }
            
            [self.listPageView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];

        };
        
        _selectView.maskTapCompletionHandler = ^(NSInteger index) {
            @strongify(self)
            [self.menu restoreIndicator:index];
        };
        
        _selectView.selectSubCellHandler = ^(CategoryNewModel *model, SelectViewDataType type) {
            @strongify(self)
            [self.menu restoreIndicator:SelectViewDataTypeCategory];
            // 这个属性是用来清空原有数据的,只要前后两个 ID 不一样即可,所以这里传空
            self.categoryID = model.cat_id;
            self.viewModel.lastCategoryID = @"";
            self.selectView.currentSortType = @"";
            self.selectView.currentCategory = model.cat_name;
            self.navTitle = model.cat_name;
            [self loadVirtualData];
            self.title = self.navTitle;
            [self.listPageView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        };
        
        _selectView.selectAnimationStopCompletionHandler = ^{
            @strongify(self);
            self.menu.isDropAnimation = NO;
        };

    }
    return _selectView;
}

- (UICollectionView *)listPageView {
    if (!_listPageView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 11;
        layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
        CGFloat itemWidth = (KScreenWidth - 12 - 12 - 11) * 0.5;
        layout.itemSize = CGSizeMake(itemWidth, 226 * SCREEN_WIDTH_SCALE + 50 + 8);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _listPageView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _listPageView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
        [_listPageView registerClass:[CategoryListPageCell class] forCellWithReuseIdentifier:[CategoryListPageCell setIdentifier]];
        _listPageView.delegate = self.viewModel;
        _listPageView.dataSource = self.viewModel;
        _listPageView.alwaysBounceVertical = YES;
        
        if (@available(iOS 11.0, *)) {
            _listPageView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        @weakify(self)
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            NSDictionary *parmaters = @{
                                        @"page"         : LoadMore,
                                        @"cat_id"       : self.categoryID == nil ? @"" : self.categoryID,
                                        @"order_by"     : self.sortType == nil ? @"" : self.sortType,
                                        @"type"         : self.virtualType == nil ? @"" : self.virtualType,
                                        @"price_min"    : self.virtualPriceModel ? [@(self.virtualPriceModel.price_min) stringValue] : @"",
                                        @"price_max"    : self.virtualPriceModel ? [@(self.virtualPriceModel.price_max) stringValue] : @"",
                                        };
            if ([NSStringUtils isEmptyString:self.categoryID]) {
                self.viewModel.lastCategoryID = @"";
            }else{
                self.viewModel.lastCategoryID = self.categoryID;
            }
            [self loadMoreVirtualData:parmaters];

        }];
        footer.triggerAutomaticallyRefreshPercent = -28; // 预加载数据
        footer.automaticallyChangeAlpha = YES;
        footer.refreshingTitleHidden = YES;
        _listPageView.mj_footer = footer;
        
    }
    return _listPageView;
}

- (CategoryListPageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[CategoryListPageViewModel alloc] init];
        _viewModel.cateName = NullFilter(self.virtualTitle);
        @weakify(self)
        _viewModel.handler = ^(CategoryGoodsModel *model) {
             @strongify(self)
            
            [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_Virtual_Category_%@_Goods_%@", [self.virtualTitle length] > 0 ? self.virtualTitle : model.cat_id, model.goods_id] itemName:model.goodsName ContentType:@"Goods" itemCategory:@"Goods"];
            
             ZFGoodsDetailViewController *detailVC = [[ZFGoodsDetailViewController alloc] init];
             detailVC.goodsId = model.goods_id;
             [self.navigationController pushViewController:detailVC animated:YES];
        };
        _viewModel.virtualHandler = ^(NSArray<CategoryNewModel *> *virtual, NSArray<CategoryPriceListModel *> *pricelists) {
            @strongify(self)
            self.virtualArray = virtual;
            self.priceListArray = pricelists;
        };
        
    }
    return _viewModel;
}

- (NSMutableArray *)menuTitles {
    if (!_menuTitles) {
        if ([SystemConfigUtils isRightToLeftShow]) {
            _menuTitles = [NSMutableArray arrayWithObjects:
                           ZFLocalizedString(@"Category_Item_Segmented_Sort", nil),
                           ZFLocalizedString(@"Category_Item_Segmented_Category", nil),
                           nil];
        }else{
            _menuTitles = [NSMutableArray arrayWithObjects:
                           ZFLocalizedString(@"Category_Item_Segmented_Category", nil),
                           ZFLocalizedString(@"Category_Item_Segmented_Sort", nil),
                           nil];
        }
    }
    return _menuTitles;
}

- (NSArray *)virtualArray {
    if (!_virtualArray) {
        _virtualArray = [NSArray array];
    }
    return _virtualArray;
}

- (NSArray *)priceListArray {
    if (!_priceListArray) {
        _priceListArray = [NSArray array];
    }
    return _priceListArray;
}

- (NSArray<NSString *> *)sortRequests {
    if (!_sortRequests) {
        if (![SystemConfigUtils isRightToLeftShow]) {
            _sortRequests = [NSArray arrayWithObjects:@"recommend", @"new_arrivals",@"price_low_to_high",@"price_high_to_low",nil];
        } else {
            _sortRequests = [NSArray arrayWithObjects:@"recommend", @"cod", @"new_arrivals",@"price_low_to_high",@"price_high_to_low",nil];
        }
    }
    return _sortRequests;
}

@end
