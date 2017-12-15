//
//  PopularViewController.m
//  Zaful
//
//  Created by huangxieyue on 16/11/24.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "PopularViewController.h"
#import "PopularViewModel.h"
#import "CommunityHeaderView.h"
#import "PopularCell.h"
#import "FavesItemsModel.h"
#import "StyleLikesModel.h"
#import "PopularModel.h"

@interface PopularViewController ()

@property (nonatomic, strong) PopularViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CommunityHeaderView *headerView;

@end

@implementation PopularViewController

/*========================================分割线======================================*/

- (PopularViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PopularViewModel alloc] init];
        _viewModel.controller = self;
        
        /*刷新页面*/
        @weakify(self)
        _viewModel.emptyOperationBlock = ^{
            @strongify(self)
            [self.tableView.mj_header beginRefreshing];
        };
        
    }
    return _viewModel;
}

/*========================================分割线======================================*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self requestPopularData];
    
    //接收关注状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
    //接收点赞状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusChangeValue:) name:kLikeStatusChangeNotification object:nil];
    //接收评论状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewCountsChangeValue:) name:kReviewCountsChangeNotification object:nil];
    //接收登录状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kLoginNotification object:nil];
    //接收登出状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutChangeValue:) name:kLogoutNotification object:nil];
    // 修改用户信息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kChangeUserInfoNotification object:nil];
    // 接收发送完照片刷新Popular数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPopularData:) name:kRefreshPopularNotification object:nil];
    //接收删除状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChangeValue:) name:kDeleteStatusChangeNotification object:nil];
}

/*========================================分割线======================================*/

- (void)initView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[PopularCell class] forCellReuseIdentifier:POPULAR_CELL_INENTIFIER];
    self.tableView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = NO;
    self.tableView.dataSource = self.viewModel;
    self.tableView.delegate = self.viewModel;
    self.tableView.emptyDataSetDelegate = self.viewModel;
    self.tableView.emptyDataSetSource = self.viewModel;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //头部Banner
    self.headerView = [CommunityHeaderView new];
    self.headerView.controller = self;
    
    /*
     *
     *
     *  这里的自动布局应该还是可以修改的 延后再看看怎么做
     *
     */
    self.headerView.size = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.tableView.tableHeaderView = self.headerView;
}

/*========================================分割线======================================*/

#pragma mark - 请求Popular数据
- (void)requestPopularData {
    @weakify(self)
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.viewModel requestNetwork:LoadMore completion:^(id obj) {
            @strongify(self)
            [self.tableView reloadData];
            
            if([obj isEqual: NoMoreToLoad]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.tableView.mj_footer.hidden = YES;
                }];
                
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
            
        } failure:^(id obj) {
            @strongify(self)
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.viewModel requestNetwork:Refresh completion:^(PopularModel *obj) {
            @strongify(self)
            if (obj != nil) {
                float height = 40;
                
                if (![NSArrayUtils isEmptyArray:obj.bannerlist]) {
                    height += 190 + 10;
                }
                
                if (![NSArrayUtils isEmptyArray:obj.video]) {
                    height += 165 + 10;
                }
                
                if (![NSArrayUtils isEmptyArray:obj.topicList]) {
                    height += 165 + 10;
                }
                
                self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
                self.tableView.tableHeaderView = self.headerView;
                self.headerView.model = obj;
            }else {
                self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
                self.tableView.tableHeaderView = self.headerView;
            }
            
            [self.tableView reloadData];
            
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
            }
            
            [self.tableView.mj_header endRefreshing];
            
        } failure:^(id obj) {
            @strongify(self)
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

/*========================================分割线======================================*/
#pragma mark - 接收删除通知
- (void)deleteChangeValue:(NSNotification *)nofi {
    [self requestPopularData];
}


/*========================================分割线======================================*/

#pragma mark - 接收关注通知
- (void)followStatusChangeValue:(NSNotification *)noti {
    
    //接收通知传过来的两个值 dict[@"isFollow"],dict[@"userId"]
    NSDictionary *dict = noti.object;
    BOOL isFollow = [dict[@"isFollow"] boolValue];
    NSString *followedUserId = dict[@"userId"];
    
    //遍历当前列表数组找到相同userId改变关注按钮状态
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(FavesItemsModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.userId isEqualToString:followedUserId]) {
            obj.isFollow = isFollow;
        }
    }];
    [self.tableView reloadData];
}

/*========================================分割线======================================*/

#pragma mark - 接收点赞通知
- (void)likeStatusChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    StyleLikesModel *likesModel = nofi.object;
    //遍历当前列表数组找到相同reviewId改变点赞按钮状态并且增加或减少点赞数
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(FavesItemsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

/*========================================分割线======================================*/

#pragma mark - 接收评论通知
- (void)reviewCountsChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    StyleLikesModel *reviewsModel = nofi.object;
    //遍历当前列表数组找到相同reviewId增加评论数
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(FavesItemsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewId isEqualToString:reviewsModel.reviewId]) {
            obj.replyCount = [NSString stringWithFormat:@"%d", [obj.replyCount intValue]+1];
        }
    }];
    [self.tableView reloadData];
}

/*========================================分割线======================================*/

#pragma mark - 接收登录通知
- (void)loginChangeValue:(NSNotification *)nofi {
    [self requestPopularData];
}

/*========================================分割线======================================*/

#pragma mark - 接收登出通知
- (void)logoutChangeValue:(NSNotification *)nofi {
    [self requestPopularData];
}

/*========================================分割线======================================*/

#pragma mark - 接收发送完照片刷新popular数据通知
- (void)refreshPopularData:(NSNotification *)nofi {
    self.tableView.hidden = NO;
    [self.tableView.mj_header beginRefreshing];
}

/*========================================分割线======================================*/

#pragma mark - 清除所有通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
