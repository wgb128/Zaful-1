//
//  CommunityDetailViewController.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CommunityDetailViewController.h"

/*My Style 控制器*/
#import "ZFCommunityAccountViewController.h"

/*关注列表控制器*/
#import "FollowViewController.h"
#import "ZFCommunityLikesViewController.h"
/*评论输入框 头文件*/
#import "InputTextView.h"

/*数据模型*/
#import "StyleLikesModel.h"//点赞列表数据模型
#import "CommunityDetailModel.h"//帖子详情数据模型
#import "CommunityDetailReviewsModel.h"//评论数据模型
#import "CommunityDetailLikeUserModel.h"
#import "CommunityDetailReviewsListMode.h"//用户评论数据模型
#import "PictureModel.h"//评论图片数据模型

/*评论列表*/
#import "CommunityReviewsCell.h"

/*当前ViewModel*/
#import "CommunityDetailViewModel.h"

/*headerView*/
#import "CommunityDetailHeaderCell.h"
#import "LabelDetailViewController.h"

#import "YYPhotoBrowseView.h"

#import "ZFLoginViewController.h"

#import "ZFShare.h"
#import "PictureModel.h"

@interface CommunityDetailViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,ZFShareViewDelegate>

/*底层滚动*/
@property (nonatomic,weak) UITableView *tableView;

/*作为加载时展现的空白页面*/
@property (nonatomic,weak) UIView *alphaView;

/*详情页 ViewModel*/
@property (nonatomic,strong) CommunityDetailViewModel *viewModel;

/*评论输入框*/
@property (nonatomic,strong) InputTextView *inputTextView;

/*详情头部Model*/
@property (nonatomic,strong) CommunityDetailModel *detailModel;

/*评论列表Model*/
@property (nonatomic,strong) CommunityDetailReviewsModel *reviewsModel;

/*提交回复评论的参数*/
@property (nonatomic,strong) NSMutableDictionary *replyDict;

/*点赞头像列表*/
@property (nonatomic,strong) NSMutableArray *likeUsersList;

/*评论列表*/
@property (nonatomic,strong) NSMutableArray *reviewsList;

@property (nonatomic, strong) ZFShareView      *shareView;

@end

@implementation CommunityDetailViewController

/*========================================分割线======================================*/

#pragma mark - 创建时传进来的参数
- (instancetype)initWithReviewId:(NSString *)reviewId userId:(NSString *)userId {
    if (self = [super init]) {
        _reviewsId = reviewId;
        _userId = userId;
    }
    return self;
}

/*========================================分割线======================================*/

#pragma mark - View Did Load
- (void)viewDidLoad {
    [super viewDidLoad];
    /*初始化界面*/
    [self initView];;
    [self requestData];
    //接收点赞状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusChangeValue:) name:kLikeStatusChangeNotification object:nil];
    //接收评论状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewCountsChangeValue:) name:kReviewCountsChangeNotification object:nil];
    //接收关注状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
    //接收登录状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kLoginNotification object:nil];
    
    // 统计
    [ZFAnalytics appsFlyerTrackEvent:@"af_post_view" withValues:@{
                                                                  @"af_contentid" : self.reviewsId
                                                                  }];
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

/*========================================分割线======================================*/

#pragma mark - 懒加载
- (NSMutableArray *)likeUsersList {
    if (!_likeUsersList) {
        _likeUsersList = [NSMutableArray array];
    }
    return _likeUsersList;
}

- (NSMutableDictionary *)replyDict {
    if (!_replyDict) {
        _replyDict = [NSMutableDictionary dictionary];
    }
    return _replyDict;
}

- (NSMutableArray *)reviewsList {
    if (!_reviewsList) {
        _reviewsList = [NSMutableArray array];
    }
    return _reviewsList;
}

- (CommunityDetailViewModel*)viewModel {
    if (!_viewModel) {
        _viewModel = [[CommunityDetailViewModel alloc] init];
        _viewModel.controller = self;
    }
    return _viewModel;
}

/*========================================分割线======================================*/

#pragma mark - 创建UI
- (void)initView {
    __weak typeof(self.view) ws = self.view;
    
    CGFloat inputOffsetY = IPHONE_X_5_15 ? SCREEN_HEIGHT- 49 - 44.0 - 44.0 : SCREEN_HEIGHT- 49 - 64;
    /*底层*/
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, inputOffsetY) style:UITableViewStyleGrouped];
    tableView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = NO;
    
    [tableView registerClass:[CommunityReviewsCell class] forCellReuseIdentifier:COMMUNITY_REVIEWS_CELL_INENTIFIER];
    [tableView registerClass:[CommunityDetailHeaderCell class] forCellReuseIdentifier:COMMUNITY_DETAIL_INENTIFIER];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [ws addSubview:tableView];
    self.tableView = tableView;
    
    /*评论输入框*/
    self.inputTextView = [[InputTextView alloc]initWithFrame:CGRectMake(0, inputOffsetY, SCREEN_WIDTH, 49)];
    self.inputTextView.backgroundColor = [UIColor colorWithWhite:255 alpha:0];
    [self.inputTextView setPlaceholderText:ZFLocalizedString(@"CommunityDetail_VC_TextView_Placeholder",nil)];
    
    @weakify(self)
    self.inputTextView.InputTextViewBlock = ^(NSString *input){
        @strongify(self)
        /*判断是否登录*/
        if ([AccountManager sharedManager].isSignIn) {
            
            if([NSStringUtils isBlankString:input])  return;
            
            /*********************将数据装成字典进行请求*******************/
            /*为0的情况下是给自己的帖子评论,非0得情况是给他人回复评论*/
            self.replyDict[@"replyId"] = self.replyDict[@"replyId"] ? self.replyDict[@"replyId"] : @"0"; // 晒图回复的id,如果当前回复是对评论的回复则这个值传0
            self.replyDict[@"reviewId"] = self.reviewsId; // 当前晒图的id
            self.replyDict[@"replyUserId"] = self.replyDict[@"replyUserId"] ? self.replyDict[@"replyUserId"] : @"0"; // 晒图回复人的用户id,如果当前回复是对评论的回复则这个值传0
            self.replyDict[@"content"] = input; // 评论内容
            self.replyDict[@"isSecondFloorReply"] = self.replyDict[@"isSecondFloorReply"] ? self.replyDict[@"isSecondFloorReply"] : @"0"; // 1表示这条回复是对回复的回复，0表是这条回复是对晒图的回复
            /********************************************************************/
            
            [self.viewModel requestReplyNetwork:self.replyDict completion:^(id obj) {
                /*指定刷新组*/
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                
                /*评论完成将PlaceholderText设置回*/
                [self.inputTextView setPlaceholderText:ZFLocalizedString(@"CommunityDetail_VC_TextView_Placeholder",nil)];
                /*回复完成后清空数据->不清空的话会导致评论下个人的时候还是上一次的数据*/
                [self.replyDict removeAllObjects];
            } failure:^(id obj) {
                
            }];
        }else {
            /*未登录情况下先登录操作*/
            ZFLoginViewController *signVC = [ZFLoginViewController new];
            
            @weakify(self)
            signVC.successBlock = ^{
                @strongify(self);
                if([NSStringUtils isBlankString:input])  return;
                
                /*********************将数据装成字典进行请求*******************/
                self.replyDict[@"replyId"] = self.replyDict[@"replyId"] ? self.replyDict[@"replyId"] : @"0";
                self.replyDict[@"reviewId"] = self.reviewsId;
                self.replyDict[@"replyUserId"] = self.replyDict[@"replyUserId"] ? self.replyDict[@"replyUserId"] : @"0";
                self.replyDict[@"content"] = input;
                self.replyDict[@"isSecondFloorReply"] = self.replyDict[@"isSecondFloorReply"] ? self.replyDict[@"isSecondFloorReply"] : @"0";
                /********************************************************************/
                
                [self.viewModel requestReplyNetwork:self.replyDict completion:^(id obj) {
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                    [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                    [self.inputTextView setPlaceholderText:ZFLocalizedString(@"CommunityDetail_VC_TextView_Placeholder",nil)];
                    [self.replyDict removeAllObjects];
                    
                } failure:^(id obj) {
                }];
            };
            ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
            [self.navigationController presentViewController:nav animated:YES completion:^{
            }];
        }
    };
    [ws addSubview:self.inputTextView];
    
    /*进入订单详情页的时候展示的空白页面*/
    UIView *alphaView = [UIView new];
    alphaView.hidden = NO;
    alphaView.backgroundColor = ZFCOLOR_WHITE;
    [ws addSubview:alphaView];
    
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.alphaView = alphaView;
}

/*========================================分割线======================================*/

#pragma mark - 请求数据
- (void)requestData {
    @weakify(self)
    /*请求headerView数据*/
    if ([NSStringUtils isBlankString:self.reviewsId] || !self.viewModel) return;
    [MBProgressHUD showLoadingView:nil];
    [self.viewModel requestNetwork:self.reviewsId completion:^(NSArray *array) {
        @strongify(self)
        [MBProgressHUD hideHUD];
        dispatch_async(dispatch_get_main_queue(), ^{
            CommunityDetailModel *detailModels = array[0];
            CommunityDetailReviewsModel *reviewsModel = array[1];
            /*请求完成后才将空白页面隐藏*/
            self.alphaView.hidden = YES;
            
            /*赋值外部变量->headerView数据*/
            self.detailModel = detailModels;
            
            /*赋值外部变量->评论列表数据*/
            self.reviewsModel = reviewsModel;
            
            /*点赞头像数组*/
            [self.likeUsersList addObjectsFromArray:detailModels.likeUsers];
            
            /*先清空之前的数据->这样不会导致数据重复*/
            [self.reviewsList removeAllObjects];
            [self.reviewsList addObjectsFromArray:reviewsModel.list];
            
            //刷新列表
            [self.tableView reloadData];
            /*上拉加载数据*/
            [self setTableViewFooterLoadRequset];
        });
        
    } failure:^(id obj) {
        
    }];
}

/*========================================分割线======================================*/

#pragma mark - 上拉加载更多
- (void)setTableViewFooterLoadRequset {
    @weakify(self)
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (!self.reviewsId) {
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        @strongify(self)
        @weakify(self)
        [self.viewModel requestReviewsListNetwork:@[@(self.reviewsModel.curPage + 1), self.reviewsId] completion:^(CommunityDetailReviewsModel *obj) {
            @strongify(self)
            if (obj) {
                self.reviewsModel = obj;
                [self.reviewsList addObjectsFromArray:obj.list];
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

/*========================================分割线======================================*/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        if (self.reviewsList.count < 15) {
            tableView.mj_footer.hidden = YES;
        } else {
            tableView.mj_footer.hidden = NO;
        }
        return self.reviewsList.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CommunityDetailHeaderCell *cell = [CommunityDetailHeaderCell communityDetailHeaderCellWithTableView:tableView IndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.controller = self;
        /*将数据->Cell*/
        [cell initWithDetailModel:self.detailModel ListUser:self.likeUsersList];
        
        /*点击点赞头像列表进入到列表页*/
        @weakify(self)
        @weakify(tableView)
        cell.clickLikeListBlock = ^ {
            @strongify(self)
            ZFCommunityLikesViewController *likeVC = [ZFCommunityLikesViewController new];
            likeVC.rid = self.reviewsId;
            likeVC.userId = self.userId;
            [self.navigationController pushViewController:likeVC animated:YES];
        };
        
        cell.topicDetailBlock = ^(NSString *labName){
            @strongify(self)
            LabelDetailViewController *topic = [LabelDetailViewController new];
            topic.labelName = labName;
            [self.navigationController pushViewController:topic animated:YES];
        };
        
        /*点赞,评论,分享->分别点击事件*/
        cell.clickDetailBlock = ^(PopularBtnTag tag) {
            @strongify(self)
            switch (tag) {
#pragma mark - 点赞
                case likeBtnTag: {
                    if ([AccountManager sharedManager].isSignIn) {
                        /*需要这个参数->mystyle需要*/
                        self.detailModel.reviewsId = self.reviewsId;
                        [self.viewModel requestLikeNetwork:self.detailModel completion:^(CommunityDetailModel *obj) {
                            @strongify(tableView)
                            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        } failure:^(id obj) {
                        }];
                    }else {
                        ZFLoginViewController *signVC = [ZFLoginViewController new];
                        @weakify(self)
                        signVC.successBlock = ^{
                            @strongify(self)
                            self.detailModel.reviewsId = self.reviewsId;
                            [self.viewModel requestLikeNetwork:self.detailModel completion:^(id obj) {
                                @strongify(tableView)
                                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            } failure:^(id obj) {
                            }];
                        };
                        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                        [self.navigationController presentViewController:nav animated:YES completion:^{
                        }];
                    }
                }
                    break;
#pragma mark - 评论
                case reviewBtnTag: {
                    if ([AccountManager sharedManager].isSignIn) {
                        /*清除replyDict数据 防止再次点击时里面存在没必要的数据*/
                        [self.replyDict removeAllObjects];
                        /*评论完成将PlaceholderText设置回*/
                        [self.inputTextView setPlaceholderText:ZFLocalizedString(@"CommunityDetail_VC_TextView_Placeholder",nil)];
                        /*第一响应者*/
                        [self.inputTextView.textView becomeFirstResponder];
                    }else {
                        ZFLoginViewController *signVC = [ZFLoginViewController new];
                        @weakify(self)
                        signVC.successBlock = ^{
                            @strongify(self)
                            [self.replyDict removeAllObjects];
                            [self.inputTextView setPlaceholderText:ZFLocalizedString(@"CommunityDetail_VC_TextView_Placeholder",nil)];
                            [self.inputTextView.textView becomeFirstResponder];
                        };
                        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                        [self.navigationController presentViewController:nav animated:YES completion:^{
                        }];
                    }
                }
                    break;
                case shareBtnTag: {
                    [self.shareView open];
                }
                    break;
                case followBtnTag:
                {
                    if ([AccountManager sharedManager].isSignIn) {
                        [self.viewModel requestFollowNetwork:self.detailModel completion:^(id obj) {
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        } failure:^(id obj) {
                            
                        }];
                        
                    }else {
                        ZFLoginViewController *signVC = [ZFLoginViewController new];
                        @weakify(self)
                        signVC.successBlock = ^{
                            @strongify(self)
                            [self.viewModel requestFollowNetwork:self.detailModel completion:^(id obj) {
                                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            } failure:^(id obj) {
                                
                            }];
                        };
                        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                        [self.navigationController presentViewController:nav animated:YES completion:^{
                        }];
                    }
                }
                    break;
                case mystyleBtnTag:
                {
                    ZFCommunityAccountViewController *myStyleVC = [ZFCommunityAccountViewController new];
                    myStyleVC.userId = self.detailModel.userId;
                    [self.navigationController pushViewController:myStyleVC animated:YES];
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
                        alert.tag = 1000;
                        [alert show];
                        
                        
                    }];
                    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
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
        
        cell.imgTouchBlock = ^(NSArray *items,NSArray *imgViewArrays,NSInteger tag) {
            YYPhotoBrowseView *groupView = [[YYPhotoBrowseView alloc] initWithGroupItems:items];
            groupView.viewController = self;
            groupView.isSaveImage = YES;
            [groupView presentFromImageView:imgViewArrays[tag] toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
        };
        
        
        return cell;
    }else {
        CommunityReviewsCell *cell = [CommunityReviewsCell communityDetailCellWithTableView:tableView IndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CommunityDetailReviewsListMode *model = self.reviewsList[indexPath.row];
        cell.reviesModel = model;
        /*回复block*/
        @weakify(self)
        cell.replyBlock = ^{
            @strongify(self)
            if (![NSStringUtils isEmptyString:USERID] ) {
                if ([model.userId isEqualToString: USERID]) {
                    /*如果点击的是自己则提示不能回复自己的评论*/
                     [MBProgressHUD showMessage:ZFLocalizedString(@"CommunityDetail_VC_CannotPost_Message",nil)];
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
                         [MBProgressHUD showMessage:ZFLocalizedString(@"CommunityDetail_VC_CannotPost_Message",nil)];
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
                [self.navigationController presentViewController:nav animated:YES completion:^{
                }];
            }
        };
        /*进入My Style中心*/
        cell.jumpMyStyleBlock = ^{
            @strongify(self)
            ZFCommunityAccountViewController *mystyleVC = [ZFCommunityAccountViewController new];
            mystyleVC.userId = model.userId;
            [self.navigationController pushViewController:mystyleVC animated:YES];
        };
        return cell;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000 ) {
        if (buttonIndex == 0) {
            [self.viewModel requestDeleteNetwork:self.detailModel completion:^(id obj) {
                if ([obj boolValue])
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteStatusChangeNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(id obj) {
                
            }];
        }
    }
}

/*========================================分割线======================================*/

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:COMMUNITY_DETAIL_INENTIFIER cacheByIndexPath:indexPath configuration:^(CommunityDetailHeaderCell *cell) {
            [cell initWithDetailModel:self.detailModel ListUser:self.likeUsersList];
        }];
    }else {
        return [tableView fd_heightForCellWithIdentifier:COMMUNITY_REVIEWS_CELL_INENTIFIER cacheByIndexPath:indexPath configuration:^(CommunityReviewsCell *cell) {
            cell.reviesModel = self.reviewsList[indexPath.row];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
/*========================================分割线======================================*/

#pragma mark - 接收点赞通知
- (void)likeStatusChangeValue:(NSNotification *)nofi {
    /*接收通知传过来的model StyleLikesModel*/
    StyleLikesModel *objs = nofi.object;
    
    /*每次点赞的时候修改模型数据*/
    self.detailModel.isLiked = objs.isLiked;
    
    if (self.detailModel.isLiked) {
        CommunityDetailLikeUserModel *likeUser = [CommunityDetailLikeUserModel new];
        likeUser.avatar = [AccountManager sharedManager].account.avatar;
        likeUser.userId = USERID,//[NSString stringWithFormat:@"%d", USERID];
        /*将当前用户插入到数组中*/
        [self.likeUsersList insertObject:likeUser atIndex:0];
        /*点赞总数数量加1*/
        self.detailModel.likeCount = [NSString stringWithFormat:@"%d", [self.detailModel.likeCount intValue]+1];
    }else {
        /*遍历数组找到和当前登录的ID一样->移除*/
        [self.likeUsersList enumerateObjectsUsingBlock:^(CommunityDetailLikeUserModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.userId isEqualToString:USERID]) {
                [self.likeUsersList removeObject:obj];
            }
        }];
        /*点赞总数数量减1*/
        self.detailModel.likeCount = [NSString stringWithFormat:@"%d", [self.detailModel.likeCount intValue]-1];
    }
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - ZFShareViewDelegate
- (void)zfShsreView:(ZFShareView *)shareView didSelectItemAtIndex:(NSUInteger)index {
    NativeShareModel *model = [[NativeShareModel alloc] init];
    NSString *nicknameStr = [NSString stringWithFormat:@"%@",self.detailModel.nickname];
    NSRange range = [nicknameStr rangeOfString:@" "];
    if (range.location != NSNotFound) {
        //有空格
        nicknameStr = [nicknameStr stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    }
    model.share_url =  [NSString stringWithFormat:@"%@?actiontype=6&url=2,%@,%@&name=%@&source=sharelink&lang=%@",CommunityShareURL,self.reviewsId,self.userId,nicknameStr, [ZFLocalizationString shareLocalizable].nomarLocalizable];
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

#pragma mark - 接收关注通知
- (void)followStatusChangeValue:(NSNotification *)noti {
    //接收通知传过来的两个值 dict[@"isFollow"],dict[@"userId"]
    NSDictionary *dict = noti.object;
    self.detailModel.isFollow = [dict[@"isFollow"] boolValue];
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

/*========================================分割线======================================*/

#pragma mark - 接收评论通知
- (void)reviewCountsChangeValue:(NSNotification *)nofi {
    self.detailModel.replyCount = [NSString stringWithFormat:@"%d", [self.detailModel.replyCount intValue]+1];
    [self.likeUsersList removeAllObjects];
    [self requestData];
}

#pragma mark - 接收登录通知
- (void)loginChangeValue:(NSNotification *)nofi {
    [self requestData];
}

/*========================================分割线======================================*/

#pragma mark - 清除所有通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*========================================分割线======================================*/

- (ZFShareView *)shareView {
    if (!_shareView) {
        _shareView = [[ZFShareView alloc] init];
        _shareView.delegate = self;
        
        ZFShareTopView *topView = [[ZFShareTopView alloc] init];
        PictureModel *pictureModel = (PictureModel *)self.detailModel.reviewPic.firstObject;
        topView.imageName = pictureModel.bigPic;
        NSString *content;
        if (self.isOutfits) {
            content = ZFLocalizedString(@"ZFShare_Community_outfits", nil);
        }else{
            content = ZFLocalizedString(@"ZFShare_Community_post", nil);
        }
        topView.title = content;
        _shareView.topView = topView;
    }
    return _shareView;
}

@end
