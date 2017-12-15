//
//  ShowsViewController.m
//  Yoshop
//
//  Created by huangxieyue on 16/8/18.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "ShowsViewController.h"

/*模型数据*/
#import "StyleLikesModel.h"//Like列表数据
#import "StyleShowsModel.h"//Show列表数据
#import "StyleShowsListModel.h"
#import "FavesItemsModel.h"//评论数据模型

/*Show Cell*/
#import "StyleShowsCell.h"

/*当前ViewModel*/
#import "ShowsViewModel.h"

/*MyStyle控制器*/
#import "MyStylePageViewController.h"

/*帖子详情控制器*/
#import "CommunityDetailViewController.h"
#import "LabelDetailViewController.h"
#import "ZFLoginViewController.h"

@interface ShowsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ShowsViewModel *viewModel;

@property (nonatomic, strong) NSMutableArray *showsList; //列表数据

@property (nonatomic, strong) StyleShowsListModel *showsListModel; //模型数据

@property (nonatomic, strong) StyleShowsModel *reviewsModels;
@end

@implementation ShowsViewController

/*========================================分割线======================================*/

- (instancetype)initUserId:(NSString *)userid {
    if (self = [super init]) {
        _userid = userid;
    }
    return self;
}

- (NSMutableArray *)showsList {
    if (!_showsList) {
        _showsList = [NSMutableArray array];
    }
    return _showsList;
}

- (ShowsViewModel*)viewModel {
    if (!_viewModel) {
        _viewModel = [ShowsViewModel new];
        
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
    // Do any additional setup after loading the view.
    [self setNavagationBarTranslucent];
    [self initView];
    [self requesData];
    [self notification];
}

/*========================================分割线======================================*/

#pragma mark - 接收通知
- (void)notification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusChangeValue:) name:kLikeStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewCountsChangeValue:) name:kReviewCountsChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin:) name:kLoginNotification object:nil];
    //接收删除状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChangeValue:) name:kDeleteStatusChangeNotification object:nil];
    
}

/*========================================分割线======================================*/

#pragma mark - 初始化界面
- (void)initView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[StyleShowsCell class] forCellReuseIdentifier:STYLE_SHOWS_CELL_INENTIFIER];
    
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
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    [_tableView setContentInset:UIEdgeInsetsMake(2*DSCREEN_HEIGHT_SCALE, 0, 0, 0)];
}

/*========================================分割线======================================*/

#pragma mark - 请求数据
- (void)requesData {
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.viewModel requestNetwork:@[self.userid,@(1)] completion:^(StyleShowsListModel *obj) {
            if (obj) {
                self.showsListModel = obj;
                if (self.showsListModel.curPage == 1) {
                    [self.showsList removeAllObjects];
                }
                [self.showsList addObjectsFromArray:obj.list];
                if (self.showsListModel.curPage >= self.showsListModel.pageCount) {
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
        [self.viewModel requestNetwork:@[self.userid,@(self.showsListModel.curPage + 1)] completion:^(StyleShowsListModel *obj) {
            if (obj) {
                self.showsListModel = obj;
                [self.showsList addObjectsFromArray:obj.list];
                [_tableView reloadData];
                if (self.showsListModel.curPage >= self.showsListModel.pageCount) {
                    //                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    _tableView.mj_footer.hidden = YES;
                    return;
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

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.showsList.count < 5) {
        tableView.mj_footer.hidden = YES;
    } else {
        tableView.mj_footer.hidden = NO;
    }
    return self.showsList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StyleShowsCell *cell = [StyleShowsCell styleShowsCellWithTableView:tableView IndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /*-*-*-*-*-*-*-*-*-*cell获取数据源-*-*-*-*-*-*-*-*-*/
    StyleShowsModel *reviewsModel = self.showsList[indexPath.section];
    cell.reviewsModel =reviewsModel;
    self.reviewsModels = reviewsModel;
    /*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
    
    @weakify(self)
    /*-*-*-*-*-*-*-*-*-*点击头像判断是否要跳转-*-*-*-*-*-*-*-*-*/
    //    cell.communtiyMyStyleBlock = ^{
    //        @strongify(self)
    //        if ([reviewsModel.userId isEqualToString:self.userid]) return;
    //        MyStylePageViewController *myStyleVC = [MyStylePageViewController new];
    //        myStyleVC.userid = reviewsModel.userId;
    //        [self.navigationController pushViewController:myStyleVC animated:YES];
    //    };
    /*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
    
    cell.topicDetailBlock = ^(NSString *labName){
        @strongify(self)
        LabelDetailViewController *topic = [LabelDetailViewController new];
        topic.labelName = labName;
        [self.navigationController pushViewController:topic animated:YES];
    };
    
    /*-*-*-*-*-*-*-*-*-*点赞,评论,分享点击事件-*-*-*-*-*-*-*-*-*/
    @weakify(reviewsModel)
    cell.clickEventBlock = ^(PopularBtnTag tag) {
        @strongify(self)
        @strongify(reviewsModel)
        switch (tag) {
                //点赞
            case likeBtnTag:
            {
                @weakify(reviewsModel)
                if ([AccountManager sharedManager].isSignIn) {
                    @strongify(reviewsModel)
                    [self.viewModel requestLikeNetwork:reviewsModel completion:^(id obj) {
                        
                    } failure:^(id obj) {
                        
                    }];
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    signVC.successBlock = ^{
                        @strongify(self)
                        @strongify(reviewsModel)
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
                @weakify(reviewsModel)
                if ([AccountManager sharedManager].isSignIn) {
                    @strongify(reviewsModel)
                    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:reviewsModel.reviewId userId:reviewsModel.userId];
                    [self.navigationController pushViewController:detailVC animated:YES];
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    signVC.successBlock = ^{
                        @strongify(self)
                        @strongify(reviewsModel)
                        CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:reviewsModel.reviewId userId:reviewsModel.userId];
                        [self.navigationController pushViewController:detailVC animated:YES];
                    };
                    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                    [self.navigationController  presentViewController:nav animated:YES completion:^{
                    }];
                }
            }
                break;
                //分享
            case shareBtnTag:
            {
                
            }
                break;
            case deleteBtnTag:
            {
                UIAlertController *alertController =  [UIAlertController
                                                       alertControllerWithTitle: nil
                                                       message:nil
                                                       preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction * DeleteAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"Address_List_Cell_Delete",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ZFLocalizedString(@"TopicLabelDeleteAlertView",nil)
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:ZFLocalizedString(@"ZFPaymentView_Alert_Yes",nil)
                                                          otherButtonTitles:ZFLocalizedString(@"Cancel",nil),nil];
                    alert.tag = 100;
                    [alert show];
                    
                }];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                    
                }];
                [alertController addAction:DeleteAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    };
    /*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
    return cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100 ) {
        
        [self.viewModel requestDeleteNetwork:self.reviewsModels completion:^(id obj) {
            if ([obj boolValue])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteStatusChangeNotification object:nil];
            }
        } failure:^(id obj) {
            
        }];
    }
}
/*========================================分割线======================================*/

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:STYLE_SHOWS_CELL_INENTIFIER cacheByIndexPath:indexPath configuration:^(StyleShowsCell *cell) {
        cell.reviewsModel = self.showsList[indexPath.section];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FavesItemsModel *reviewsModel = self.showsList[indexPath.section];
    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:reviewsModel.reviewId userId:reviewsModel.userId];
    [self.navigationController pushViewController:detailVC animated:YES];
}

/*========================================分割线======================================*/

#pragma mark - Notification
//点赞通知
- (void)likeStatusChangeValue:(NSNotification *)nofi {
    StyleLikesModel *reviewsModel = nofi.object;
    
    if ([USERID isEqualToString: self.userid]) {
        [self.showsList enumerateObjectsUsingBlock:^(StyleShowsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    else {
        [self.showsList enumerateObjectsUsingBlock:^(StyleShowsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

//评论通知
- (void)reviewCountsChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    StyleLikesModel *reviewsModel = nofi.object;
    //遍历当前列表数组找到相同reviewId增加评论数
    [self.showsList enumerateObjectsUsingBlock:^(StyleShowsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
#pragma mark - 接收删除通知
- (void)deleteChangeValue:(NSNotification *)nofi {
    [self requesData];
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
