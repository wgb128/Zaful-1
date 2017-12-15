//
//  VideoViewController.m
//  Zaful
//
//  Created by huangxieyue on 16/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoViewModel.h"
#import "CommentsCell.h"
#import "InputTextView.h"
#import "VideoDetailModel.h"
#import "VideoHeaderView.h"
#import "CommentsCell.h"
#import "RecommendCell.h"
#import "ZFCommunityAccountViewController.h"
#import "ZFGoodsDetailViewController.h"

#import "CommunityDetailReviewsModel.h"
#import "CommunityDetailReviewsListMode.h"

#import "VideoDetailModel.h"
#import "VideoDetailInfoModel.h"//视频详情页头部数据model
#import "NSString+Extended.h"
#import "ZFLoginViewController.h"

#import "ZFShare.h"

@interface VideoViewController ()<UITableViewDataSource, UITableViewDelegate,ZFShareViewDelegate>

/*作为加载时展现的空白页面*/
@property (nonatomic,weak) UIView *alphaView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) VideoViewModel *viewModel;

@property (nonatomic, strong) InputTextView *inputTextView;

@property (nonatomic, strong) VideoDetailModel *infoModel;

@property (nonatomic,strong) CommunityDetailReviewsModel *reviewsModel;

@property (nonatomic, strong) NSMutableArray *goodArray;

@property (nonatomic, strong) NSMutableArray *reviewArray;

/*提交回复评论的参数*/
@property (nonatomic, strong) NSMutableDictionary *replyDict;
@property (nonatomic, strong) VideoHeaderView *headerView;

@property (nonatomic, strong) ZFShareView      *shareView;

@end

@implementation VideoViewController

- (NSMutableDictionary *)replyDict {
    if (!_replyDict) {
        _replyDict = [NSMutableDictionary dictionary];
    }
    return _replyDict;
}

- (NSMutableArray *)reviewArray {
    if (!_reviewArray) {
        _reviewArray = [NSMutableArray array];
    }
    return _reviewArray;
}

- (NSMutableArray *)goodArray {
    if (!_goodArray) {
        _goodArray = [NSMutableArray array];
    }
    return _goodArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self configureRightBarItem];
    [self initView];
    /*上拉加载数据*/
    [self setTableViewFooterLoadRequset];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)requestData {
    
    NSString *test = [NSString stringWithFormat:@"%@?actiontype=6&url=4,%@&name=@""&source=sharelink&lang=%@",CommunityShareURL,self.videoId,[ZFLocalizationString shareLocalizable].nomarLocalizable];
    ZFLog(@"%@",test);
    
    
    @weakify(self)
    /*请求视频详情页头部数据*/
    [self.viewModel requestNetwork:self.videoId completion:^(NSArray *objs) {
        @strongify(self)
        VideoDetailModel *infoModel = objs[0];
        CommunityDetailReviewsModel *reviewsModel = objs[1];
        /*请求评论列表数据*/
        
        /*请求完成后才将空白页面隐藏*/
        self.alphaView.hidden = YES;
        
        /*取出头部数据外部赋值*/
        self.infoModel = infoModel;
        
        self.headerView = [self addHeaderView];
        CGRect rect = CGRectZero;
        rect.size = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.headerView.frame = rect;
        @weakify(self)
        self.headerView.refreshHeadViewBlock = ^(){
            @strongify(self)
            CGRect rect = CGRectZero;
            rect.size = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            self.headerView.frame = rect;
            self.tableView.tableHeaderView = self.headerView;
        };

        /*视频详情页头部数据*/
        self.headerView.infoModel = infoModel.videoInfo;
        
        [self.goodArray addObjectsFromArray:infoModel.goodsList];
        
        /*===================*/
        
        /*赋值外部变量->评论列表数据*/
        self.reviewsModel = reviewsModel;
        
        /*先清空之前的数据->这样不会导致数据重复*/
        [self.reviewArray removeAllObjects];
        [self.reviewArray addObjectsFromArray:reviewsModel.list];
        
        self.tableView.tableHeaderView = self.headerView;
        //刷新列表
        [self.tableView reloadData];
    } failure:^(id obj) {
        
    }];
    
}

- (void)configureRightBarItem {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(64, 2,20,19)];
    [btn setImage:[UIImage imageNamed:@"community_share"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(shareHandle) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 84, 24)];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:btn];
    
    UIBarButtonItem *accountItme = [[UIBarButtonItem alloc]initWithCustomView:containerView];
    self.navigationItem.rightBarButtonItem = accountItme;
    
}

- (void)shareHandle {
    [self.shareView open];
}

#pragma mark - ZFShareViewDelegate
- (void)zfShsreView:(ZFShareView *)shareView didSelectItemAtIndex:(NSUInteger)index {
    NativeShareModel *model = [[NativeShareModel alloc] init];
    model.share_url = [NSString stringWithFormat:@"%@?actiontype=6&url=4,%@&name=@""&source=sharelink&lang=%@",CommunityShareURL,self.videoId,[ZFLocalizationString shareLocalizable].nomarLocalizable];
    model.fromviewController = self;
    [ZFShareManager shareManager].model = model;
    switch (index) {
        case ZFShareTypeFacebook:
        {
            [[ZFShareManager shareManager] shareToFacebook];
        }
            break;
        case ZFShareTypeMessenger:
        {
            [[ZFShareManager shareManager] shareToMessenger];
        }
            break;
        case ZFShareTypeCopy:
        {
            [[ZFShareManager shareManager] copyLinkURL];
        }
            break;
    }
}

#pragma mark - 上拉加载更多
- (void)setTableViewFooterLoadRequset {
    @weakify(self)
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.viewModel requestReviewsListNetwork:@[@(self.reviewsModel.curPage + 1), self.videoId] completion:^(CommunityDetailReviewsModel *obj) {
            @strongify(self)
            if (obj) {
                self.reviewsModel = obj;
                [self.reviewArray addObjectsFromArray:obj.list];
                [self.tableView reloadData];
                
                if (self.reviewsModel.curPage >= self.reviewsModel.pageCount) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.tableView.mj_footer.hidden = YES;
                    }];
                    return;
                }
            }else {
                [self.tableView.mj_footer endRefreshing];
                [UIView animateWithDuration:0.3 animations:^{
                    self.tableView.mj_footer.hidden = YES;
                }];
            }
            
        } failure:^(id obj) {
            @strongify(self)
            [self.tableView.mj_footer endRefreshing];
        }];
    }];
}

- (void)initView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    [_tableView registerClass:[CommentsCell class] forCellReuseIdentifier:VIDEO_COMMENTS_CELL_INENTIFIER];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 49, 0));
    }];
    
    _inputTextView = [[InputTextView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49-64, SCREEN_WIDTH, 49)];
    _inputTextView.backgroundColor = [UIColor colorWithWhite:255 alpha:0];
    [_inputTextView setPlaceholderText:ZFLocalizedString(@"Video_VC_TextView_Placeholder",nil)];
    
    @weakify(self)
    _inputTextView.InputTextViewBlock = ^(NSString *input){
        @strongify(self)
        /*判断是否登录*/
        if ([AccountManager sharedManager].isSignIn) {
            [MBProgressHUD showLoadingView:nil];
            
            /*********************将数据装成字典进行请求*******************/
            /*为0的情况下是给自己的帖子评论,非0得情况是给他人回复评论*/
            self.replyDict[@"replyId"] = self.replyDict[@"replyId"] ? self.replyDict[@"replyId"] : @"0"; // 晒图回复的id,如果当前回复是对评论的回复则这个值传0
            self.replyDict[@"reviewId"] = self.videoId; // 当前晒图的id
            self.replyDict[@"replyUserId"] = self.replyDict[@"replyUserId"] ? self.replyDict[@"replyUserId"] : @"0"; // 晒图回复人的用户id,如果当前回复是对评论的回复则这个值传0
            self.replyDict[@"content"] = input; // 评论内容
            self.replyDict[@"isSecondFloorReply"] = self.replyDict[@"isSecondFloorReply"] ? self.replyDict[@"isSecondFloorReply"] : @"0"; // 1表示这条回复是对回复的回复，0表是这条回复是对晒图的回复
            /********************************************************************/
            
            [self.viewModel requestReplyNetwork:self.replyDict completion:^(id obj) {
                
                [self.viewModel requestReviewsListNetwork:@[Refresh, self.videoId] completion:^(CommunityDetailReviewsModel *reviewsModel) {
                    @strongify(self)
                    
                    /*赋值外部变量->评论列表数据*/
                    self.reviewsModel = reviewsModel;
                    
                    /*先清空之前的数据->这样不会导致数据重复*/
                    [self.reviewArray removeAllObjects];
                    [self.reviewArray addObjectsFromArray:reviewsModel.list];
                    
                    //刷新列表
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    /*回复完成后清空数据->不清空的话会导致评论下个人的时候还是上一次的数据*/
                    [self.replyDict removeAllObjects];
                    
                    [MBProgressHUD hideHUD];
                } failure:^(id obj) {
                    [MBProgressHUD hideHUD];
                }];
            } failure:^(id obj) {
               [MBProgressHUD hideHUD];
            }];
            
            
        }else {
            /*未登录情况下先登录操作*/
            ZFLoginViewController *signVC = [ZFLoginViewController new];
            
            @weakify(self)
            signVC.successBlock = ^{
                @strongify(self)
                [MBProgressHUD showLoadingView:nil];
                
                /*********************将数据装成字典进行请求*******************/
                self.replyDict[@"replyId"] = self.replyDict[@"replyId"] ? self.replyDict[@"replyId"] : @"0";
                self.replyDict[@"reviewId"] = self.videoId;
                self.replyDict[@"replyUserId"] = self.replyDict[@"replyUserId"] ? self.replyDict[@"replyUserId"] : @"0";
                self.replyDict[@"content"] = input;
                self.replyDict[@"isSecondFloorReply"] = self.replyDict[@"isSecondFloorReply"] ? self.replyDict[@"isSecondFloorReply"] : @"0";
                /********************************************************************/
                
                
                [self.viewModel requestReplyNetwork:self.replyDict completion:^(id obj) {
                    
                    /*指定刷新组*/
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    [MBProgressHUD hideHUD];
                    
                    
                    /*评论完成将PlaceholderText设置回*/
                    [self.inputTextView setPlaceholderText:ZFLocalizedString(@"Video_VC_TextView_Placeholder",nil)];
                    /*回复完成后清空数据->不清空的话会导致评论下个人的时候还是上一次的数据*/
                    [self.replyDict removeAllObjects];
                    
                } failure:^(id obj) {
                    [MBProgressHUD hideHUD];
                }];
            };
            ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
            [self.navigationController  presentViewController:nav animated:YES completion:^{
            }];
        }
    };
    
    [self.view addSubview:_inputTextView];
    
    /*进入详情页的时候展示的空白页面*/
    UIView *alphaView = [UIView new];
    alphaView.hidden = NO;
    alphaView.backgroundColor = ZFCOLOR_WHITE;
    [self.view addSubview:alphaView];
    
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.alphaView = alphaView;
}

- (VideoHeaderView *)addHeaderView {
    VideoHeaderView *headerView = [[VideoHeaderView alloc] initWithFrame:CGRectZero];
    @weakify(self)
    @weakify(headerView)
    headerView.likeBlock = ^{
        @strongify(self)
        if ([AccountManager sharedManager].isSignIn) {
            @strongify(headerView)
            @weakify(headerView)
            [self.viewModel requestLikeNetwork:self.infoModel.videoInfo.videoId completion:^(VideoDetailInfoModel *obj) {
                @strongify(headerView)
                headerView.likeModel = obj;
            } failure:^(id obj) {
                
            }];
            
        }else {
            ZFLoginViewController *signVC = [ZFLoginViewController new];
            signVC.successBlock = ^{
                @strongify(headerView)
                @weakify(headerView)
                [self.viewModel requestLikeNetwork:self.infoModel.videoInfo.videoId completion:^(id obj) {
                    @strongify(headerView)
                    headerView.likeModel = obj;
                } failure:^(id obj) {
                    
                }];
            };
            ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
            [self.navigationController  presentViewController:nav animated:YES completion:^{
            }];
        }
    };
    
    return  headerView;
}

- (VideoViewModel*)viewModel {
    if (!_viewModel) {
        _viewModel = [VideoViewModel new];
        _viewModel.controller = self;
        
        @weakify(self)
        _viewModel.emptyOperationBlock = ^{
            @strongify(self)
            
            [self.tableView.mj_header beginRefreshing];
        };
    }
    return _viewModel;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.goodArray.count;
    }else {
        if (self.reviewArray.count < 15) {
            tableView.mj_footer.hidden = YES;
        } else {
            tableView.mj_footer.hidden = NO;
        }
        return self.reviewArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
        {
            RecommendCell *recommendCell = [RecommendCell recommendCellWithTableView:tableView IndexPath:indexPath];
            recommendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            recommendCell.data = self.goodArray[indexPath.row];
            
            @weakify(self)
            recommendCell.jumpBlock = ^{
                @strongify(self)
                NSDictionary *dict = self.goodArray[indexPath.row];
                
                ZFGoodsDetailViewController *detail = [ZFGoodsDetailViewController new];
                detail.goodsId = dict[@"goods_id"];
                [self.navigationController pushViewController:detail animated:YES];
            };
            
            cell = recommendCell;
        }
            break;
        case 1:
        {
            CommentsCell *commentsCell = [CommentsCell commentsCellWithTableView:tableView IndexPath:indexPath];
            commentsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            CommunityDetailReviewsListMode *model = self.reviewArray[indexPath.row];
            commentsCell.reviesModel = model;
            
            @weakify(self)
            commentsCell.jumpBlock = ^(NSString *userId){
                @strongify(self)
                ZFCommunityAccountViewController *mystyleVC = [ZFCommunityAccountViewController new];
                mystyleVC.userId = userId,
                [self.navigationController pushViewController:mystyleVC animated:YES];
            };
            
            commentsCell.replyBlock = ^{
                
                @strongify(self)
                if (![NSStringUtils isEmptyString:USERID] ) {
                    if ([model.userId isEqualToString: USERID]) {
                        /*如果点击的是自己则提示不能回复自己的评论*/
                         [MBProgressHUD showMessage:ZFLocalizedString(@"Video_VC_CannotPost_Message",nil)];
                    }else {
                        /*第一响应者*/
                        [self.inputTextView.textView becomeFirstResponder];
                        
                        /*点击回复他人评论时截取的数据*/
                        [self.inputTextView setPlaceholderText:[NSString stringWithFormat:@"Re %@",model.nickname]];
                        self.replyDict[@"replyId"] = model.replyId;
                        self.replyDict[@"reviewId"] = model.reviewId;
                        self.replyDict[@"replyUserId"] = model.userId;
                        self.replyDict[@"isSecondFloorReply"] = @"1";
                        /**************************************/
                    }
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    signVC.successBlock = ^{
                        @strongify(self)
                        if ([model.userId isEqualToString: USERID]) {
                             [MBProgressHUD showMessage:ZFLocalizedString(@"Video_VC_CannotPost_Message",nil)];
                        }else {
                            [self.inputTextView.textView becomeFirstResponder];
                            
                            /*点击回复他人评论时截取的数据*/
                            [self.inputTextView setPlaceholderText:[NSString stringWithFormat:@"Re %@",model.nickname]];
                            self.replyDict[@"replyId"] = model.replyId;
                            self.replyDict[@"reviewId"] = model.reviewId;
                            self.replyDict[@"replyUserId"] = model.userId;
                            self.replyDict[@"isSecondFloorReply"] = @"1";
                            /**************************************/
                        }
                    };
                    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                    [self.navigationController  presentViewController:nav animated:YES completion:^{
                    }];
                }
                
            };
            cell = commentsCell;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        titleView.backgroundColor = ZFCOLOR_WHITE;
        
        UIView *line = [UIView new];
        line.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        [titleView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(3);
            make.height.mas_equalTo(16);
            make.bottom.mas_equalTo(titleView.mas_bottom).mas_offset(-5);
            make.leading.mas_equalTo(titleView.mas_leading);
        }];
        
        NSInteger num = self.reviewArray.count > 0 ? self.reviewArray.count : 0;
        
        UILabel *titleLabel = [UILabel new];
        
        if ([SystemConfigUtils isRightToLeftShow]) {
            titleLabel.text = [NSString stringWithFormat:@"(%ld)%@",(long)num,ZFLocalizedString(@"VideoView_HeaderView_Title",nil)];
        } else {
            titleLabel.text = [NSString stringWithFormat:@"%@(%ld)",ZFLocalizedString(@"VideoView_HeaderView_Title",nil),(long)num];
        }
        
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        [titleView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(line.mas_centerY);
            make.leading.mas_equalTo(line.mas_trailing).mas_offset(5);
        }];
        
        return titleView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 114;
    }
    return [tableView fd_heightForCellWithIdentifier:VIDEO_COMMENTS_CELL_INENTIFIER cacheByIndexPath:indexPath configuration:^(CommentsCell *cell) {
        cell.reviesModel = self.reviewArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Getter
- (ZFShareView *)shareView {
    if (!_shareView) {
        _shareView = [[ZFShareView alloc] init];
        _shareView.delegate = self;
        
        ZFShareTopView *topView = [[ZFShareTopView alloc] init];
        topView.imageName = [NSString stringWithFormat:@"https://img.youtube.com/vi/%@/hqdefault.jpg",self.infoModel.videoInfo.videoUrl];
        topView.title = self.headerView.infoModel.videoDescription;
        _shareView.topView = topView;
    }
    return _shareView;
}

@end
