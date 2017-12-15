//
//  LikesViewController.m
//  Yoshop
//
//  Created by huangxieyue on 16/8/18.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "LikesViewController.h"

#import "StyleLikesCell.h"

/*当前ViewModel*/
#import "LikesViewModel.h"

/*数据模型*/
#import "StyleLikesModel.h"//Like列表数据
#import "StyleLikesListModel.h"//Show列表数据
#import "FavesItemsModel.h"//评论数据模型

/*MyStyle控制器*/
#import "ZFCommunityAccountViewController.h"

/*帖子详情控制器*/
#import "CommunityDetailViewController.h"
#import "LabelDetailViewController.h"

#import "ZFLoginViewController.h"

@interface LikesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LikesViewModel *viewModel;

@property (nonatomic, strong) NSMutableArray *likesList; //列表数据

@property (nonatomic, strong) StyleLikesListModel *likesListModel; //模型数据

@end

@implementation LikesViewController

/*========================================分割线======================================*/

- (instancetype)initUserId:(NSString *)userid {
    if (self = [super init]) {
        _userid = userid;
    }
    return self;
}

- (NSMutableArray *)likesList {
    if (!_likesList) {
        _likesList = [NSMutableArray array];
    }
    return _likesList;
}

- (LikesViewModel*)viewModel {
    @weakify(self)
    if (!_viewModel) {
        _viewModel = [[LikesViewModel alloc] init];
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
    // Do any additional setup after loading the view.
    [self setNavagationBarTranslucent];
    [self initView];
    [self requesData];
    [self notification];
    
}

/*========================================分割线======================================*/

#pragma mark - 接收通知
- (void)notification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusChangeValue:) name:kLikeStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewCountsChangeValue:) name:kReviewCountsChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin:) name:kLoginNotification object:nil];
}

/*========================================分割线======================================*/

#pragma mark - 初始化界面
- (void)initView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[StyleLikesCell class] forCellReuseIdentifier:STYLE_LIKES_CELL_INENTIFIER];
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetSource = self.viewModel;
    _tableView.emptyDataSetDelegate = self.viewModel;
    
    _tableView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    [_tableView setContentInset:UIEdgeInsetsMake(2*DSCREEN_HEIGHT_SCALE, 0, 0, 0)];
}

/*========================================分割线======================================*/

#pragma mark - 请求数据
- (void)requesData {
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.viewModel requestNetwork:@[self.userid,@(1)] completion:^(StyleLikesListModel *obj) {
            if (obj) {
                self.likesListModel = obj;
                if (self.likesListModel.curPage == 1) {
                    [self.likesList removeAllObjects];
                }
                [self.likesList addObjectsFromArray:obj.list];
                if (self.likesListModel.curPage >= self.likesListModel.pageCount) {
//                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                    _tableView.mj_footer.hidden = YES;
                }
            }
            [_tableView.mj_header endRefreshing];
            [_tableView reloadData];
        } failure:^(id obj) {
            [_tableView.mj_header endRefreshing];
        }];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.viewModel requestNetwork:@[self.userid,@(self.likesListModel.curPage + 1)] completion:^(StyleLikesListModel *obj) {
                if (obj) {
                    self.likesListModel = obj;
                    [self.likesList addObjectsFromArray:obj.list];
                    [_tableView reloadData];
                    if (self.likesListModel.curPage >= self.likesListModel.pageCount) {
//                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                        _tableView.mj_footer.hidden = YES;
                    }
                }
                [_tableView.mj_footer endRefreshing];
            } failure:^(id obj) {
                [_tableView.mj_header endRefreshing];
            }];
    }];
    [_tableView.mj_header beginRefreshing];
}

/*========================================分割线======================================*/

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.likesList.count < 5) {
        tableView.mj_footer.hidden = YES;
    } else {
        tableView.mj_footer.hidden = NO;
    }
    return self.likesList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StyleLikesCell *cell = [StyleLikesCell styleLikesCellWithTableView:tableView IndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /*-*-*-*-*-*-*-*-*-*cell获取数据源-*-*-*-*-*-*-*-*-*/
    StyleLikesModel *reviewsModel = self.likesList[indexPath.section];
    cell.reviewsModel =reviewsModel;
    /*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
    
    @weakify(self)
    /*-*-*-*-*-*-*-*-*-*点击头像判断是否要跳转-*-*-*-*-*-*-*-*-*/
    cell.communtiyMyStyleBlock = ^{
        @strongify(self)
        if ([reviewsModel.userId isEqualToString:self.userid]) return;
        ZFCommunityAccountViewController *myStyleVC = [ZFCommunityAccountViewController new];
        myStyleVC.userId = reviewsModel.userId;
        [self.navigationController pushViewController:myStyleVC animated:YES];
    };
    /*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
    
    cell.topicDetailBlock = ^(NSString *labName){
        @strongify(self)
        LabelDetailViewController *topic = [LabelDetailViewController new];
        topic.labelName = labName;
        [self.navigationController pushViewController:topic animated:YES];
    };
    
    /*-*-*-*-*-*-*-*-*-*点赞,评论,分享点击事件-*-*-*-*-*-*-*-*-*/
    cell.clickEventBlock = ^(PopularBtnTag tag) {
        @strongify(self)
        switch (tag) {
                //点赞
            case likeBtnTag:
            {
                if ([AccountManager sharedManager].isSignIn) {
                    [self.viewModel requestLikeNetwork:reviewsModel completion:^(id obj) {
                        
                    } failure:^(id obj) {
                        
                    }];
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    signVC.successBlock = ^{
                        @strongify(self)
                        [self.viewModel requestLikeNetwork:reviewsModel completion:^(id obj) {
                            
                        } failure:^(id obj) {
                            
                        }];
                    };
                    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                    [self.navigationController  presentViewController:nav animated:YES completion:^{
                    }];
                }
                
            }
                break;
                //评论
            case reviewBtnTag:
            {
                if ([AccountManager sharedManager].isSignIn) {
                    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:reviewsModel.reviewId userId:reviewsModel.userId];
                    [self.navigationController pushViewController:detailVC animated:YES];
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    signVC.successBlock = ^{
                        @strongify(self)
                        CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:reviewsModel.reviewId userId:reviewsModel.userId];
                        [self.navigationController pushViewController:detailVC animated:YES];
                    };
                    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                    [self.navigationController  presentViewController:nav animated:YES completion:^{
                    }];
                }
            }
                break;
            case shareBtnTag:
            {
               
            }
                break;
                //关注
            case followBtnTag:
            {
                if ([AccountManager sharedManager].isSignIn) {
                    [self.viewModel requestFollowedNetwork:reviewsModel completion:^(id obj) {
                        
                    } failure:^(id obj) {
                        
                    }];
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    signVC.successBlock = ^{
                        @strongify(self)
                        [self.viewModel requestFollowedNetwork:reviewsModel completion:^(id obj) {
                            
                        } failure:^(id obj) {
                            
                        }];
                    };
                    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                    [self.navigationController  presentViewController:nav animated:YES completion:^{
                    }];
                }
            }
                break;
            default:
                break;
        }
    };
    /*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
    return cell;
}

/*========================================分割线======================================*/

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:STYLE_LIKES_CELL_INENTIFIER cacheByIndexPath:indexPath configuration:^(StyleLikesCell *cell) {
        cell.reviewsModel = self.likesList[indexPath.section];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FavesItemsModel *reviewsModel = self.likesList[indexPath.section];
    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:reviewsModel.reviewId userId:reviewsModel.userId];
    [self.navigationController pushViewController:detailVC animated:YES];
}

/*========================================分割线======================================*/

#pragma mark - Notification
//点赞通知
- (void)likeStatusChangeValue:(NSNotification *)nofi {
    StyleLikesModel *reviewsModel = nofi.object;
    
    if ([USERID isEqualToString: self.userid]) {
        __block BOOL isExit = NO;
        [self.likesList enumerateObjectsUsingBlock:^(StyleLikesModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.reviewId isEqualToString:reviewsModel.reviewId]) {
                if (reviewsModel.isLiked) {
                    obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]+1];
                }else{
                    obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]-1];
                }
                obj.isLiked = reviewsModel.isLiked;
                isExit = YES;
                *stop = YES;
            }
        }];
        if (!isExit) {
            [self.tableView.mj_header beginRefreshing];
        }else{
            [_tableView reloadData];
        }
    }
    else {
        [self.likesList enumerateObjectsUsingBlock:^(StyleLikesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.reviewId isEqualToString:reviewsModel.reviewId]) {
                if (reviewsModel.isLiked) {
                    obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]+1];
                }else{
                    obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]-1];
                }
                obj.isLiked = reviewsModel.isLiked;
                *stop = YES;
            }
        }];
        [_tableView reloadData];
    }
}

/*========================================分割线======================================*/

//关注通知
- (void)followStatusChangeValue:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    BOOL isFollow = [dict[@"isFollow"] boolValue];
    NSString *followedUserId = dict[@"userId"];
    [self.likesList enumerateObjectsUsingBlock:^(StyleLikesModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.userId isEqualToString:followedUserId]) {
            obj.isFollow = isFollow;
        }
    }];
    [_tableView reloadData];
}

/*========================================分割线======================================*/

//评论通知
- (void)reviewCountsChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    StyleLikesModel *reviewsModel = nofi.object;
    //遍历当前列表数组找到相同reviewId增加评论数
    [self.likesList enumerateObjectsUsingBlock:^(StyleLikesModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewId isEqualToString:reviewsModel.reviewId]) {
            obj.replyCount = [NSString stringWithFormat:@"%d", [obj.replyCount intValue]+1];
        }
    }];
    [_tableView reloadData];
}

/*========================================分割线======================================*/

//登录通知
- (void)userLogin:(NSNotification *)nofi {
    [_tableView.mj_header beginRefreshing];
}

/*========================================分割线======================================*/

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*========================================分割线======================================*/

-(void)setNavagationBarTranslucent
{
    NSString *navArrowName = @"back_w_left";
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        navArrowName = @"back_w_right";
    }
    [self.navigationController.navigationBar setBackIndicatorImage:[[UIImage imageNamed:navArrowName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:navArrowName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

@end
