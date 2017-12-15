//
//  TopicViewModel.m
//  Zaful
//
//  Created by zhaowei on 2016/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "TopicViewModel.h"
#import "TopicDetailApi.h"
#import "TopicDetailModel.h"
#import "TopicTableViewCell.h"
#import "TopicHeadApi.h"
#import "TopicDetailHeadLabelModel.h"
#import "FavesItemsModel.h"
#import "LikeApi.h"
#import "StyleLikesModel.h"
#import "TopicDetailListModel.h"

/*MyStyle控制器*/
#import "ZFCommunityAccountViewController.h"
/*帖子详情控制器*/
#import "CommunityDetailViewController.h"

#import "FollowApi.h"
#import "FavesItemsModel.h"
#import "ZFCommunityTopicListViewController.h"
#import "TopicDetailView.h" //话题详情页两个btn切换按钮
#import "ZFLoginViewController.h"
#import "ZFShare.h"
#import "PictureModel.h"

@interface TopicViewModel ()<ZFShareViewDelegate>

@property (nonatomic, strong) TopicDetailHeadLabelModel *topicDetailHeadModel;
@property (nonatomic, strong) TopicDetailModel *topicDetailModel;
@property (nonatomic, strong) SYBatchRequest *batchRequest;
@property (nonatomic, assign) BOOL isLoadLike;     // 是否正在加载点攒接口
@property (nonatomic, assign) BOOL isLoadfollow;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ZFShareView      *shareView;
@property (nonatomic, strong) TopicDetailListModel *shareDataModel;
@end

@implementation TopicViewModel

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure{
    
    [self.batchRequest.requestArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[SYNetworkManager sharedInstance] removeRequest:obj completion:nil];
    }];
    
    NSArray *array = (NSArray *)parmaters;
    self.batchRequest = [[SYBatchRequest alloc] initWithRequestArray:@[[[TopicHeadApi alloc] initWithTopicId:array[0]],[[TopicDetailApi alloc] initWithcurPage:[Refresh integerValue] pageSize:PageSize topicId:array[0] sort:array[1]]] enableAccessory:YES];
    [MBProgressHUD showLoadingView:nil];
    @weakify(self)
    [self.batchRequest startWithBlockSuccess:^(SYBatchRequest *batchRequest) {
        @strongify(self)
        [MBProgressHUD hideHUD];
        NSArray *requests = batchRequest.requestArray;
        
        TopicHeadApi *headApi = (TopicHeadApi *)requests[0];
        
        self.topicDetailHeadModel = [self dataAnalysisFromJson: headApi.responseJSONObject request:headApi];
        
        TopicDetailApi *detailApi = (TopicDetailApi *)requests[1];
        
        self.topicDetailModel = [self dataAnalysisFromJson: detailApi.responseJSONObject request:detailApi];
        self.dataArray = [NSMutableArray arrayWithArray:self.topicDetailModel.list];
        
        if (self.topicDetailHeadModel == nil) {
            self.topicDetailHeadModel = [TopicDetailHeadLabelModel new];
        }
        
        if (self.topicDetailModel == nil) {
            self.topicDetailModel = [TopicDetailModel new];
        }
        self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.dataArray] ? EmptyViewHideType : EmptyShowNoDataType;
        if (completion) {
            completion(@[self.topicDetailHeadModel,self.topicDetailModel]);
        }
        
    } failure:^(SYBatchRequest *batchRequest) {
        [MBProgressHUD hideHUD];
        self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.dataArray] ? EmptyViewHideType : EmptyShowNoDataType;
        if (failure) {
            failure(nil);
        }
    }];

    
}

- (void)requestTopicDetailListNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure{
    
    [NetworkStateManager networkState:^{
        
        NSArray *array = (NSArray *)parmaters;
        
        NSInteger page = 1;
        if ([array[0] integerValue] == 0) {
            // 假如最后一页的时候
            if ([self.topicDetailModel.curPage integerValue] == self.topicDetailModel.pageCount) {
                if (completion) {
                    completion(NoMoreToLoad);
                }
                return;
            }
            page = [self.topicDetailModel.curPage integerValue]  + 1;
        }
        
        TopicDetailApi *api = [[TopicDetailApi alloc] initWithcurPage:page pageSize:PageSize topicId:array[1] sort:array[2]];
        
        [MBProgressHUD showLoadingView:nil];
        
        @weakify(self)
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            [MBProgressHUD hideHUD];
            @strongify(self)
            self.topicDetailModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
            
            if (page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:self.topicDetailModel.list];
            }else{
                [self.dataArray addObjectsFromArray:self.topicDetailModel.list];
            }
            self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.dataArray] ? EmptyViewHideType : EmptyShowNoDataType;
            
            if (completion) {
                completion(self.topicDetailModel);
            }
            
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            [MBProgressHUD hideHUD];
            self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.dataArray] ? EmptyViewHideType : EmptyShowNoDataType;
            if (failure) {
                failure(nil);
            }
        }];
        
    } exception:^{
        if (failure) {
            failure(nil);
        }
    }];
    
}

//点赞
- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    [NetworkStateManager networkState:^{
        if (_isLoadLike) {
            return;
        }
        _isLoadLike = YES;
        
        TopicDetailListModel *model = (TopicDetailListModel *)parmaters;
        LikeApi *api = [[LikeApi alloc] initWithReviewId:model.reviewsId flag:!model.isLiked];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
            _isLoadLike = NO;
            NSDictionary *dict = request.responseJSONObject;
            if ([dict[@"code"] integerValue] == 0) {
                NSString *addTime = model.addTime;
                NSString *avatar  = model.avatar;
                NSString *content = model.content;
                BOOL isFollow     = model.isFollow;
                NSString *nickName = model.nickname;
                NSString *replyCount = model.replyCount;
                NSArray *reviewPic = model.reviewPic;
                NSString *userId = model.userId;
                NSInteger likeCount = [model.likeCount integerValue];
                NSString *reviewId = model.reviewsId;
                BOOL isLiked = model.isLiked;
                
                NSDictionary *dic = @{@"addTime" : addTime,
                                      @"avatar" : avatar,
                                      @"content" : content,
                                      @"isFollow" : @(isFollow),
                                      @"isLiked" : @(!isLiked),
                                      @"likeCount" : @(likeCount),
                                      @"nickname" : nickName,
                                      @"replyCount" : replyCount,
                                      @"reviewPic" : reviewPic,
                                      @"userId" : userId,
                                      @"reviewId" : reviewId};
                
                StyleLikesModel *likeModel = [StyleLikesModel yy_modelWithJSON:dic];
                [[NSNotificationCenter defaultCenter] postNotificationName:kLikeStatusChangeNotification object:likeModel];
            }else
            {
                [MBProgressHUD showMessage:dict[@"msg"]];
            }
            
            if (completion) {
                completion(nil);
            }
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            _isLoadLike = NO;
            if (failure) {
                failure(nil);
            }
        }];
    } exception:^{
        if (failure) {
            failure(nil);
        }
    }];
}

//关注
- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    [NetworkStateManager networkState:^{
        if (_isLoadfollow) {
            return;
        }
        _isLoadfollow = YES;
        
        TopicDetailListModel *model = (TopicDetailListModel*)parmaters;
        FollowApi *api = [[FollowApi alloc] initWithFollowStatue:!model.isFollow followedUserId:model.userId];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
            
            _isLoadfollow = NO;
            NSDictionary *dict = request.responseJSONObject;
            if ([dict[@"code"] integerValue] == 0) {
                NSDictionary *dic = @{@"userId"   : model.userId,
                                      @"isFollow" : @(!model.isFollow)};
                [[NSNotificationCenter defaultCenter] postNotificationName:kFollowStatusChangeNotification object:dic];
            }
            [MBProgressHUD showMessage:dict[@"msg"]];
            
            if (completion) {
                completion(nil);
            }
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            _isLoadfollow = NO;
            if (failure) {
                failure(nil);
            }
        }];
    } exception:^{
        if (failure) {
            failure(nil);
        }
    }];
}


- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[TopicHeadApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [TopicDetailHeadLabelModel yy_modelWithJSON:json[@"data"]];
        }
    }else if ([request isKindOfClass:[TopicDetailApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [TopicDetailModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}

#pragma mark - tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count < 5) {
        tableView.mj_footer.hidden = YES;
    } else {
        tableView.mj_footer.hidden = NO;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicTableViewCell *cell = [TopicTableViewCell topicTableViewCellWithTableView:tableView andIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置Cell选中效果
    TopicDetailListModel *reviewsModel;
    if (![NSArrayUtils isEmptyArray:self.dataArray]) {
        reviewsModel = self.dataArray[indexPath.row];
        cell.model = reviewsModel;
    }
    
    @weakify(self)
    @weakify(reviewsModel)
    /*-*-*-*-*-*-*-*-*-*点击头像判断是否要跳转-*-*-*-*-*-*-*-*-*/
    cell.communtiyMyStyleBlock = ^{
        @strongify(self)
        @strongify(reviewsModel)
        if ([reviewsModel.userId isEqualToString:USERID]) return;
        ZFCommunityAccountViewController *myStyleVC = [ZFCommunityAccountViewController new];
        myStyleVC.userId = reviewsModel.userId;
        [self.controller.navigationController pushViewController:myStyleVC animated:YES];
    };
    /*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
    
    cell.topicDetailBlock = ^(NSString *labName){
        @strongify(self)
        ZFCommunityTopicListViewController *topic = [ZFCommunityTopicListViewController new];
        topic.topicTitle = labName;
        [self.controller.navigationController pushViewController:topic animated:YES];
    };
    
    /*-*-*-*-*-*-*-*-*-*点赞,评论,分享点击事件-*-*-*-*-*-*-*-*-*/
    cell.clickEventBlock = ^(UIButton *btn, TopicDetailListModel *model) {
        @strongify(self)
        @strongify(reviewsModel)
        switch (btn.tag) {
                //点赞
            case likeBtnTag:
            {
                btn.enabled = NO;
                if ([AccountManager sharedManager].isSignIn) {
                    [self requestLikeNetwork:reviewsModel completion:^(id obj) {
                        btn.enabled = YES;
                    } failure:^(id obj) {
                        btn.enabled = YES;
                    }];
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    @weakify(reviewsModel)
                    signVC.successBlock = ^{
                        @strongify(self)
                        @strongify(reviewsModel)
                        [self requestLikeNetwork:reviewsModel completion:^(id obj) {
                            btn.enabled = YES;
                        } failure:^(id obj) {
                            btn.enabled = YES;
                        }];
                    };
                    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                    [self.controller.navigationController  presentViewController:nav animated:YES completion:^{
                    }];
                }
            }
                break;
                //评论
            case reviewBtnTag:
            {
                @weakify(self)
                @weakify(reviewsModel)
                if ([AccountManager sharedManager].isSignIn) {
                    @strongify(self)
                    @strongify(reviewsModel)
                    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:reviewsModel.reviewsId userId:reviewsModel.userId];
                    [self.controller.navigationController pushViewController:detailVC animated:YES];
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    @weakify(reviewsModel)
                    signVC.successBlock = ^{
                        @strongify(self)
                        @strongify(reviewsModel)
                        CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:reviewsModel.reviewsId userId:reviewsModel.userId];
                        [self.controller.navigationController pushViewController:detailVC animated:YES];
                    };
                    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                    [self.controller.navigationController  presentViewController:nav animated:YES completion:^{
                    }];
                }
            }
                break;
                //分享
            case shareBtnTag:
            {
                self.shareDataModel = model;
                [self configureShareTopView];
                [self.shareView open];
            }
                break;
            case followBtnTag:
            {
                @weakify(self)
                @weakify(reviewsModel)
                if ([AccountManager sharedManager].isSignIn) {
                    @strongify(self)
                    @strongify(reviewsModel)
                    [self requestFollowNetwork:reviewsModel completion:^(id obj) {
                    } failure:^(id obj) {
                        
                    }];
                    
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    @weakify(reviewsModel)
                    signVC.successBlock = ^{
                        @strongify(self)
                        @strongify(reviewsModel)
                        [self requestFollowNetwork:reviewsModel completion:^(id obj) {
                            //                            [tableView reloadData];
                        } failure:^(id obj) {
                            
                        }];
                    };
                    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                    [self.controller.navigationController  presentViewController:nav animated:YES completion:^{
                    }];
                }
            }
                break;
            default:
                break;
        }
    };
    
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:TOPIC_CELL_IDENTIFIER cacheByIndexPath:indexPath configuration:^(TopicTableViewCell *cell) {
        cell.model = self.dataArray[indexPath.row];
    }];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TopicDetailView *view = [[TopicDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor clearColor];
    view.topicDetailSelectBlock = ^(NSInteger btnTag){
        [self clickEvent:btnTag];
    };
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopicDetailListModel *reviewsModel;
    if (![NSArrayUtils isEmptyArray:self.dataArray]) {
        reviewsModel = self.dataArray[indexPath.row];
        CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:reviewsModel.reviewsId userId:reviewsModel.userId];
        [self.controller.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)clickEvent:(NSInteger )sort {
    
    if (self.dataArray.count != 0) {
        [self.dataArray removeAllObjects];
    }
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",(int)sort] forKey:KTopicKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.topicclickEventBlock) {
        self.topicclickEventBlock(sort);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - ZFShareViewDelegate
- (void)zfShsreView:(ZFShareView *)shareView didSelectItemAtIndex:(NSUInteger)index {
    NativeShareModel *model = [[NativeShareModel alloc] init];
    NSString *nicknameStr = [NSString stringWithFormat:@"%@",self.shareDataModel.nickname];
    NSRange range = [nicknameStr rangeOfString:@" "];
    if (range.location != NSNotFound) {
        //有空格
        nicknameStr = [nicknameStr stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    }
    model.share_url = [NSString stringWithFormat:@"%@?actiontype=6&url=2,%@,%@&name=%@&source=sharelink&lang=%@",CommunityShareURL,self.shareDataModel.reviewsId,self.shareDataModel.userId,nicknameStr, [ZFLocalizationString shareLocalizable].nomarLocalizable];
    model.fromviewController = self.controller;
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

- (void)configureShareTopView {
    ZFShareTopView *topView = [[ZFShareTopView alloc] init];
    PictureModel *model = self.shareDataModel.reviewPic.firstObject;
    topView.imageName = model.bigPic;
    topView.title = self.shareDataModel.content;
    self.shareView.topView = topView;
}


#pragma mark - DZNEmptyDataSetSource Methods
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    self.emptyViewManager.customNoDataView = [self makeCustomNoDataView];
    return [self.emptyViewManager accordingToTypeReBackView:self.emptyViewShowType];
}

#pragma mark make - privateCustomView(NoDataView)
- (UIView *)makeCustomNoDataView {
    UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
    customView.backgroundColor = ZFCOLOR(245, 245, 245, 1);
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = ZFLocalizedString(@"TopicViewModel_NoData_FirstJoined",nil);
    [customView addSubview:self.titleLabel];
    
    
    UITableView *tableView = [self.controller valueForKey:@"tableView"];
    CGFloat height = [tableView.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(customView.mas_bottom).mas_offset(- (SCREEN_HEIGHT - height - 40 )/2);
        make.centerX.mas_equalTo(customView.mas_centerX);
    }];
    
    return customView;
}

- (void)isHiddenEmpty:(BOOL)isShow {
    if (isShow) {
        self.titleLabel.hidden = YES;
    }else{
        self.titleLabel.hidden = NO;
    }
}

#pragma mark - getter
- (ZFShareView *)shareView {
    if (!_shareView) {
        _shareView = [[ZFShareView alloc] init];
        _shareView.delegate = self;
        

    }
    return _shareView;
}


@end
