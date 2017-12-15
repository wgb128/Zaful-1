//
//  CategoryParentViewController.m
//  ListPageViewController
//
//  Created by TsangFa on 26/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryParentViewController.h"
#import "CategoryParentViewModel.h"
#import "CategorySubLevelController.h"
#import "CategoryListPageViewController.h"
#import "ZFCartViewController.h"
#import "PYSearchViewController.h"
#import "SearchResultViewController.h"

@interface CategoryParentViewController ()
@property (nonatomic, strong) UICollectionView          *categoryView;
@property (nonatomic, strong) CategoryParentViewModel   *viewModel;
@property (nonatomic, strong) JSBadgeView               *badgeView;
@property (nonatomic, strong) UIView                    *againRequestView;
@end

@implementation CategoryParentViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavgationItem];
    [self configureSubViews];
    [self autoLayoutSubViews];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    //谷歌统计
     [ZFAnalytics screenViewQuantityWithScreenName:@"Category"];
    
    NSNumber *badgeNum = [[NSUserDefaults standardUserDefaults] valueForKey:kCollectionBadgeKey];
    NSString * numberIndex = @"";
    if ([badgeNum integerValue] == 0) {
        self.badgeView.badgeText = nil;
        return;
    }
    numberIndex = [badgeNum integerValue] > 99 ? @"99+" :[NSString stringWithFormat:@"%ld",(long)[badgeNum integerValue]];
    self.badgeView.badgeText = numberIndex;
}

#pragma mark - Initialize
-(void)configureSubViews {
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ZFCOLOR(51, 51, 51, 1);
    [self.view addSubview:self.categoryView];
}

-(void)autoLayoutSubViews {
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - Private Methods
- (void)loadData {
    [MBProgressHUD showLoadingView:nil];
    @weakify(self)
    [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kStartLoadingCategories];
    [self.viewModel requestParentsDataCompletion:^{
        [MBProgressHUD hideHUD];
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingCategories];
        [self.categoryView.mj_header endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            [self.categoryView reloadData];
        });
    } failure:^(id obj) {
        @strongify(self)
        [self.categoryView.mj_header endRefreshing];
        [self showAgainRequest];
        // 谷歌统计
        [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLoadingCategories];
    }];
}

- (void)configureNavgationItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
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

- (void)showAgainRequest {
    _againRequestView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_againRequestView setBackgroundColor:ZFCOLOR(245, 245, 245, 1.0)];
    [self.view addSubview:_againRequestView];
    
    UIView * groundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 241)];
    [groundView setCenter:CGPointMake(self.view.center.x, self.view.center.y - 65)];
    [_againRequestView addSubview:groundView];
    
    YYAnimatedImageView * img = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, 0, 80, 117)];
    [img setImage:[UIImage imageNamed:@"wifi"]];
    [groundView addSubview:img];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+20, SCREEN_WIDTH, 55)];
    label.text = ZFLocalizedString(@"Global_NO_NET_404",nil);
    [label setTextColor:[UIColor lightGrayColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setFont:[UIFont systemFontOfSize:14.0f]];
    [groundView addSubview:label];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, CGRectGetMaxY(label.frame)+20, 200, 45)];
    titleLabel.text = ZFLocalizedString(@"Base_VC_ShowAgain_TitleLabel",nil);
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [titleLabel setBackgroundColor:[UIColor blackColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer * gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(againRequest)];
    [titleLabel addGestureRecognizer:gest];
    [groundView addSubview:titleLabel];
}

- (void)againRequest {
     [_againRequestView removeFromSuperview];
    [self loadData];
}

#pragma mark - Target Action
- (void)searchClick {
    // 谷歌统计
    [ZFAnalytics clickButtonWithCategory:@"Category" actionName:@"Cate - Search" label:@"Cate - Search icon"];
    [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Seach" itemName:@"Seach" ContentType:@"Search" itemCategory:@"Search"];
    
    NSArray *hotwordSearchArray = [[NSUserDefaults standardUserDefaults] valueForKey:KHotwordSearchKey];
    NSString *placeHolder = ZFLocalizedString(@"Search_PlaceHolder_Search",nil);
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotwordSearchArray searchBarPlaceholder:placeHolder didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        SearchResultViewController * searchResult = [[SearchResultViewController alloc]init];
        searchResult.searchString = searchText;
        searchResult.hidesBottomBarWhenPushed = YES;
        [searchViewController.navigationController pushViewController:searchResult animated:YES];
        // 谷歌统计
        [ZFAnalytics clickButtonWithCategory:@"Search" actionName:@"Search keyword" label:searchText];
    }];
    [searchViewController.searchBar showCurrentViewBorder:1.0 color:[UIColor lightGrayColor]];
    
    searchViewController.hotSearchStyle = PYHotSearchStyleBorderTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleBorderTag;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}

- (void)cartIconClick {
    ZFCartViewController *cartVC = [[ZFCartViewController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
    
    // 统计
    [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Bag" itemName:@"CategoryParent_bag" ContentType:@"Bag" itemCategory:@"Bag"];
    [ZFAnalytics clickButtonWithCategory:@"bag" actionName:@"Click_bag" label:@"Click_bag"];
}

#pragma mark - Getter
-(UICollectionView *)categoryView {
    if (!_categoryView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 7;
        layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
        CGFloat itemWidth = (KScreenWidth - 12 - 12 - 7) / 2;
        layout.itemSize = CGSizeMake(itemWidth, 120 * SCREEN_WIDTH_SCALE);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _categoryView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _categoryView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
        [_categoryView registerClass:[CategoryParentCell class] forCellWithReuseIdentifier:[CategoryParentCell setIdentifier]];
        _categoryView.delegate = self.viewModel;
        _categoryView.dataSource = self.viewModel;
        _categoryView.alwaysBounceVertical = YES;
        @weakify(self)
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self loadData];
        }];
        header.stateLabel.hidden = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _categoryView.mj_header = header;


    }
    return _categoryView;
}

-(CategoryParentViewModel *)viewModel {
    if (!_viewModel) {
        @weakify(self)
        _viewModel = [[CategoryParentViewModel alloc] init];
        _viewModel.handler = ^(CategoryNewModel *model) {
            @strongify(self)
            // firebase统计
            [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_Category_Item_%@", model.cat_name] itemName:model.cat_name ContentType:@"Category_List" itemCategory:@"List"];
            
            if ([model.is_child integerValue]) {
                CategorySubLevelController *subLevelVC = [[CategorySubLevelController alloc] init];
                subLevelVC.model = model;
                [self.navigationController pushViewController:subLevelVC animated:YES];
                // 谷歌统计
                [ZFAnalytics clickButtonWithCategory:@"Category" actionName:[NSString stringWithFormat:@"Cate - %@/Cate",model.cat_name] label:[NSString stringWithFormat:@"Cate - %@/Cate",model.cat_name]];
            }else{ // 三级作为一级的
                
                CategoryListPageViewController *listPageVC = [[CategoryListPageViewController alloc] init];
                listPageVC.model = model;
                [self.navigationController pushViewController:listPageVC animated:YES];
            }
            
        };
    }
    return _viewModel;
}


@end
