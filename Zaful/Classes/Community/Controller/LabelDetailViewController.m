//
//  LabelDetailViewController.m
//  Zaful
//
//  Created by DBP on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//  标签详情

#import "LabelDetailViewController.h"
#import "LabelDetailViewModel.h"
#import "LabelDetailModel.h"
#import "TopicTableViewCell.h"
#import "TopicDetailListModel.h"
#import "StyleLikesModel.h"

@interface LabelDetailViewController ()
@property (nonatomic, strong) LabelDetailViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LabelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.labelName;
    [self initView];
    [self requestData];
    
    //接收关注状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
    //接收点赞状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusChangeValue:) name:kLikeStatusChangeNotification object:nil];
    //接收评论状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewCountsChangeValue:) name:kReviewCountsChangeNotification object:nil];
    //接收登录状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kLoginNotification object:nil];
    //接收删除状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChangeValue:) name:kDeleteStatusChangeNotification object:nil];
}

#pragma mark - requestApi
- (void)requestData {
    @weakify(self)
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.viewModel requestNetwork:@[LoadMore,self.labelName] completion:^(id obj) {
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
        //        self.headerView.userInteractionEnabled = NO;
        @strongify(self)
        [self.viewModel requestNetwork:@[Refresh,self.labelName] completion:^(id obj) {
            @strongify(self)
            
            if (![NSArrayUtils isEmptyArray:obj]) {

            }
            
            [self.tableView reloadData];
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
//                self.tableView.mj_footer.hidden = NO;
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

#pragma mark - initView
- (void) initView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[TopicTableViewCell class] forCellReuseIdentifier:TOPIC_LABEL_CELL_IDENTIFIER];
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = ZFCOLOR_WHITE;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = YES;
    self.tableView.dataSource = self.viewModel;
    self.tableView.delegate = self.viewModel;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

#pragma mark - LazyLoad
- (LabelDetailViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[LabelDetailViewModel alloc] init];
        _viewModel.controller = self;
        _viewModel.labelName = self.labelName;
    }
    return _viewModel;
}

#pragma mark - 接收关注通知
- (void)followStatusChangeValue:(NSNotification *)noti {
    //接收通知传过来的两个值 dict[@"isFollow"],dict[@"userId"]
    NSDictionary *dict = noti.object;
    BOOL isFollow = [dict[@"isFollow"] boolValue];
    NSString *followedUserId = dict[@"userId"];
    //遍历当前列表数组找到相同userId改变关注按钮状态
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(TopicDetailListModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.userId isEqualToString:followedUserId]) {
            obj.isFollow = isFollow;
        }
    }];
    [self.tableView reloadData];
}

/*========================================分割线======================================*/
#pragma mark - 接收删除通知
- (void)deleteChangeValue:(NSNotification *)nofi {
    [self requestData];
}

/*========================================分割线======================================*/
#pragma mark - 接收点赞通知
- (void)likeStatusChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    StyleLikesModel *likesModel = nofi.object;
    //遍历当前列表数组找到相同reviewId改变点赞按钮状态并且增加或减少点赞数
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(TopicDetailListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewsId isEqualToString:likesModel.reviewId]) {
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
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(TopicDetailListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewsId isEqualToString:reviewsModel.reviewId]) {
            obj.replyCount = [NSString stringWithFormat:@"%d", [obj.replyCount intValue]+1];
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - 接收登录通知
- (void)loginChangeValue:(NSNotification *)nofi {
    [self requestData];
}


@end
