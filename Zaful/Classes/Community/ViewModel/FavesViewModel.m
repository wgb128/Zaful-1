//
//  FavesViewModel.m
//  Yoshop
//
//  Created by zhaowei on 16/7/18.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "FavesViewModel.h"

#import "LikeApi.h"
#import "CommunityFavesApi.h"

#import "MyStylePageViewController.h"
#import "CommunityDetailViewController.h"

#import "FavesCell.h"

#import "StyleLikesModel.h"
#import "FavesModel.h"
#import "FavesItemsModel.h"
#import "PictureModel.h"
#import "LabelDetailViewController.h"

@interface FavesViewModel ()

@property (nonatomic, strong) FavesModel *model;
@property (nonatomic, assign) BOOL isLoadLike;     // 是否正在加载点赞接口

@end

@implementation FavesViewModel

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    NSInteger page = 1;
    if ([parmaters integerValue] == 0) {
        // 假如最后一页的时候
        if ([self.model.curPage integerValue] == self.model.pageCount) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            return;
        }
        page = [self.model.curPage integerValue]  + 1;
    }
    
    @weakify(self)
    [NetworkStateManager networkState:^{
        @strongify(self)
        CommunityFavesApi *api = [[CommunityFavesApi alloc] initWithcurPage:page];
        @weakify(self)
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
            @strongify(self)
            self.model = [self dataAnalysisFromJson: request.responseJSONObject request:api];
            
            //列表数据
            if (page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:self.model.list];
            }else{
                [self.dataArray addObjectsFromArray:self.model.list];
            }
            
            //判断数据设置空页面
            self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
            
            if (completion) {
                completion(@(self.emptyViewShowType));
            }
            
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            @strongify(self)
            self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoNetType;
            if (failure) {
                failure(@(self.emptyViewShowType));
            }
        }];
    } exception:^{
        @strongify(self)
        self.emptyViewShowType = EmptyShowNoNetType;
        if (failure) {
            failure(@(self.emptyViewShowType));
        }
    }];
}

- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    [NetworkStateManager networkState:^{
        if (_isLoadLike) {
            return;
        }
        _isLoadLike = YES;
        
        FavesItemsModel *model = (FavesItemsModel *)parmaters;
        LikeApi *api = [[LikeApi alloc] initWithReviewId:model.reviewId flag:!model.isLiked];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
            _isLoadLike = NO;
            NSDictionary *dict = request.responseJSONObject;
            if ([dict[@"code"] integerValue] == 0) {
                NSString *addTime = model.addTime;
                NSString *avatar  = model.avatar;
                NSString *content = model.content;
                BOOL isFollow = model.isFollow;
                NSString *nickName = model.nickname;
                NSString *replyCount = model.replyCount;
                NSArray *reviewPic = model.reviewPic;
                NSString *userId = model.userId;
                NSInteger likeCount = [model.likeCount integerValue];
                NSString *reviewId = model.reviewId;
                BOOL isLiked = model.isLiked;
                
                NSDictionary *dic = @{
                                      @"addTime" : addTime,
                                      @"avatar" : avatar,
                                      @"content" : content,
                                      @"isFollow" : @(isFollow),
                                      @"isLiked" : @(!isLiked),
                                      @"likeCount" : @(likeCount),
                                      @"nickname" : nickName,
                                      @"replyCount" : replyCount,
                                      @"reviewPic" : reviewPic,
                                      @"userId" : userId,
                                      @"reviewId" : reviewId
                                      };
                
                StyleLikesModel *likeModel = [StyleLikesModel yy_modelWithJSON:dic];
                [[NSNotificationCenter defaultCenter] postNotificationName:kLikeStatusChangeNotification object:likeModel];
            }else{
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

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[CommunityFavesApi class]]) {
        if ([json[@"msg"] isEqualToString:@"Success"]) {
            return [FavesModel yy_modelWithJSON:json[@"data"]];
        }
        else {
             [MBProgressHUD showMessage:json[@"errors"]];
        }
    }
    return nil;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArray.count < 5) {
        tableView.mj_footer.hidden = YES;
    } else {
        tableView.mj_footer.hidden = NO;
    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FavesCell *cell = [FavesCell favesCellWithTableView:tableView IndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FavesItemsModel *itemsModel = self.dataArray[indexPath.section];
    cell.itemsModel =itemsModel;
    
    @weakify(self)
    cell.communtiyMyStyleBlock = ^{
        @strongify(self)
        MyStylePageViewController *myStyleVC = [MyStylePageViewController new];
        myStyleVC.userid = itemsModel.userId;
        [self.controller.navigationController pushViewController:myStyleVC animated:YES];
    };
    
    cell.topicDetailBlock = ^(NSString *labName){
        @strongify(self)
        LabelDetailViewController *topic = [LabelDetailViewController new];
        topic.labelName = labName;
        [self.controller.navigationController pushViewController:topic animated:YES];
    };
    
    cell.clickEventBlock = ^(UIButton *btn) {
        @strongify(self)
        switch (btn.tag) {
            case likeBtnTag:
            {
                btn.enabled = NO;
                [self requestLikeNetwork:itemsModel completion:^(id obj) {
                    btn.enabled = YES;
                    [tableView reloadData];
                } failure:^(id obj) {
                    btn.enabled = YES;
                }];
            }
                break;
            case reviewBtnTag:
            {
                CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:itemsModel.reviewId userId:itemsModel.userId];
                [self.controller.navigationController pushViewController:detailVC animated:YES];
            }
                break;
            case shareBtnTag:
            {
              
            }
                break;
            default:
                break;
        }
    };
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:FAVES_CELL_INENTIFIER cacheByIndexPath:indexPath configuration:^(FavesCell *cell) {
        cell.itemsModel = self.dataArray[indexPath.section];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FavesItemsModel *itemsModel = self.dataArray[indexPath.section];
    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:itemsModel.reviewId userId:itemsModel.userId];
    [self.controller.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - DZNEmptyDataSetSource Methods
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    self.emptyViewManager.customNoDataView = [self makeCustomNoDataView];
    return [self.emptyViewManager accordingToTypeReBackView:self.emptyViewShowType];
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark make - privateCustomView(NoDataView)
- (UIView *)makeCustomNoDataView {
    UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
    
    YYAnimatedImageView *imageView = [YYAnimatedImageView new];
    imageView.image = [UIImage imageNamed:@"followed-1"];
    [customView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(customView.mas_top).mas_offset(105 * DSCREEN_HEIGHT_SCALE);
        make.centerX.mas_equalTo(customView.mas_centerX);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.numberOfLines = 2;
    titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 40;
    titleLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = ZFLocalizedString(@"FavesViewModel_NoData_Title",nil);
    [customView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(18);
        make.centerX.mas_equalTo(customView.mas_centerX);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = ZFCOLOR(255, 168, 0, 1);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:ZFCOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    [button setTitle:ZFLocalizedString(@"FavesViewModel_NoData_AddMoreFriends",nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(emptyJumpOperationTouch) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 2;
    [customView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(18);
        make.centerX.mas_equalTo(customView.mas_centerX);
        make.height.mas_equalTo(@34);
    }];
    
    return customView;
}

@end
