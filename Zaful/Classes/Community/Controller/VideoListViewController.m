//
//  VideoListViewController.m
//  Zaful
//
//  Created by zhaowei on 2016/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoListViewModel.h"
#import "SDCycleScrollView.h"
#import "BannerModel.h"

@interface VideoListViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) VideoListViewModel *viewModel;

@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) NSArray *bannerArray;

@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ZFLocalizedString(@"VideoList_VC_Title",nil);
    [self initView];
    [self requesData];
}

#pragma mark - 初始化界面
- (void)initView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    
    _tableView.rowHeight = 120;
    _tableView.delegate = self.viewModel;
    _tableView.dataSource = self.viewModel;
    _tableView.emptyDataSetSource = self.viewModel;
    _tableView.emptyDataSetDelegate = self.viewModel;
    
    _tableView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)
                                                              delegate:self
                                                              placeholderImage:[UIImage imageNamed:@"community_index_banner_loading"]];
    _bannerView.autoScrollTimeInterval = 3.0; // 间隔时间
    _bannerView.currentPageDotColor = ZFCOLOR(51, 51, 51, 1.0);
    _bannerView.pageDotColor = ZFCOLOR(241, 241, 241, 1.0);
    _tableView.tableHeaderView = _bannerView;
}

/*========================================分割线======================================*/

#pragma mark - 请求数据
- (void)requesData {
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.viewModel requestNetwork:Refresh completion:^(NSArray *banners) {
            self.bannerArray = banners;
            
            if (![NSArrayUtils isEmptyArray:banners]) {
                
                CGRect rect = _bannerView.frame;
                rect.size.height =190;
                _bannerView.frame = rect;
                
                NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:banners.count];
                [banners enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [imageArray addObject:obj.image];
                }];
                _bannerView.imageURLStringsGroup = imageArray;
                _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
                
                if (imageArray.count == 1) {
                    _bannerView.autoScroll = NO;
                }
            }else {
                CGRect rect = _bannerView.frame;
                rect.size.height =0;
                _bannerView.frame = rect;
            }
            _tableView.tableHeaderView = _bannerView;
            [_tableView.mj_header endRefreshing];
            [_tableView reloadData];
        } failure:^(id obj) {
            [_tableView.mj_header endRefreshing];
        }];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.viewModel requestNetwork:LoadMore completion:^(BannerModel *banners) {
            
                [_tableView.mj_footer endRefreshing];
                [UIView animateWithDuration:0.3 animations:^{
                    _tableView.mj_footer.hidden = YES;
                }];
            
        } failure:^(id obj) {
            [_tableView.mj_header endRefreshing];
        }];
    }];
    [_tableView.mj_header beginRefreshing];
}

- (VideoListViewModel*)viewModel {
    if (!_viewModel) {
        _viewModel = [[VideoListViewModel alloc] init];
        _viewModel.controller = self;
        
        @weakify(self)
        _viewModel.emptyOperationBlock = ^{
            @strongify(self)
        
            [self.tableView.mj_header beginRefreshing];
        };
    }
    return _viewModel;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    BannerModel *bannerModel = self.bannerArray[index];
    [BannerManager doBannerActionTarget:self withBannerModel:bannerModel];
}

@end
