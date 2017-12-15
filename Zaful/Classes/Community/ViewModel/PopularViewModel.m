//
//  PopularViewModel.m
//  Yoshop
//
//  Created by zhaowei on 16/7/18.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "PopularViewModel.h"

#import "LikeApi.h"
#import "FollowApi.h"
#import "PopularCell.h"
#import "StyleLikesModel.h"

#import "MyStylePageViewController.h"

#import "CommunityPopularApi.h"
#import "PopularModel.h"
#import "CommunityDetailViewController.h"
#import "FavesItemsModel.h"
#import "PictureModel.h"
#import "JumpModel.h"
#import "LabelDetailViewController.h"
#import "ZFLoginViewController.h"

@interface PopularViewModel ()

@property (nonatomic, strong) PopularModel *homeModel;
@property (nonatomic, assign) BOOL isLoadLike;     // 是否正在加载点攒接口
@property (nonatomic, assign) BOOL isLoadfollow;

@end

@implementation PopularViewModel

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//Popluar频道
- (void)requestNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    NSInteger page = 1;
    if ([parmaters integerValue] == 0) {
        // 假如最后一页的时候
        if ([self.homeModel.curPage integerValue] == self.homeModel.pageCount) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            return;
        }
        page = [self.homeModel.curPage integerValue]  + 1;
    }
    
    @weakify(self)
    [NetworkStateManager networkState:^{
        @strongify(self)
        CommunityPopularApi *api = [[CommunityPopularApi alloc] initWithcurPage:page];
        @weakify(self)
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            @strongify(self)
            self.homeModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
            
            if (page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:self.homeModel.list];
            }else{
                [self.dataArray addObjectsFromArray:self.homeModel.list];
            }
            
            self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
            
            if (completion) {
                completion(self.homeModel);
            }
            
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            @strongify(self)
            self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoNetType;
            
            if (failure) {
                failure(nil);
            }
        }];
    } exception:^{
        @strongify(self)
        self.emptyViewShowType = EmptyShowNoNetType;
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
        
        FavesItemsModel *model = (FavesItemsModel*)parmaters;
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

//点赞
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
                BOOL isFollow     = model.isFollow;
                NSString *nickName = model.nickname;
                NSString *replyCount = model.replyCount;
                NSArray *reviewPic = model.reviewPic;
                NSString *userId = model.userId;
                NSInteger likeCount = [model.likeCount integerValue];
                NSString *reviewId = model.reviewId;
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

//解析
- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[CommunityPopularApi class]]) {
        if ([json[@"msg"] isEqualToString:@"Success"]) {
            return [PopularModel yy_modelWithJSON:json[@"data"]];
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
    PopularCell *cell = [PopularCell popularCellWithTableView:tableView IndexPath:indexPath];
    FavesItemsModel *infoModel = self.dataArray[indexPath.section];
    cell.itemsModel = infoModel;
    
    @weakify(self)
    @weakify(infoModel)
    cell.communtiyMyStyleBlock = ^{
        @strongify(self)
        @strongify(infoModel)
        MyStylePageViewController *myStyleVC = [MyStylePageViewController new];
        myStyleVC.userid = infoModel.userId;
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
                if ([AccountManager sharedManager].isSignIn) {
                    @strongify(infoModel)
                    [self requestLikeNetwork:infoModel completion:^(id obj) {
                        btn.enabled = YES;
                        [tableView reloadData];
                    } failure:^(id obj) {
                        btn.enabled = YES;
                    }];
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    signVC.successBlock = ^{
                        @strongify(self)
                        @strongify(infoModel)
                        [self requestLikeNetwork:infoModel completion:^(id obj) {
                            btn.enabled = YES;
                            [tableView reloadData];
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
            case reviewBtnTag:
            {
                if ([AccountManager sharedManager].isSignIn) {
                    @strongify(infoModel)
                    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:infoModel.reviewId userId:infoModel.userId];
                    [self.controller.navigationController pushViewController:detailVC animated:YES];
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    signVC.successBlock = ^{
                        @strongify(self)
                        @strongify(infoModel)
                        CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:infoModel.reviewId userId:infoModel.userId];
                        [self.controller.navigationController pushViewController:detailVC animated:YES];
                    };
                    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                    [self.controller.navigationController  presentViewController:nav animated:YES completion:^{
                    }];
                }
            }
                break;
            case shareBtnTag:
            {
                            
            }
                break;
            case followBtnTag:
            {
                if ([AccountManager sharedManager].isSignIn) {
                    @strongify(infoModel)
                    @weakify(tableView)
                    [self requestFollowNetwork:infoModel completion:^(id obj) {
                        @strongify(tableView)
                        [tableView reloadData];
                    } failure:^(id obj) {
                        
                    }];
                    
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    signVC.successBlock = ^{
                        @strongify(self)
                        @strongify(infoModel)
                        @weakify(tableView)
                        [self requestFollowNetwork:infoModel completion:^(id obj) {
                            @strongify(tableView)
                            [tableView reloadData];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:POPULAR_CELL_INENTIFIER cacheByIndexPath:indexPath configuration:^(PopularCell *cell) {
        cell.itemsModel = self.dataArray[indexPath.section];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FavesItemsModel *infoModel = self.dataArray[indexPath.section];
    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:infoModel.reviewId userId:infoModel.userId];
    [self.controller.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - DZNEmptyDataSetSource Methods
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    self.emptyViewManager.customNoDataView = [self makeCustomNoDataView];
    return [self.emptyViewManager accordingToTypeReBackView:self.emptyViewShowType];
}

#pragma mark make - privateCustomView(NoDataView)
- (UIView *)makeCustomNoDataView {
    UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (![NSArrayUtils isEmptyArray:self.homeModel.bannerlist]) {
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = ZFLocalizedString(@"PopularViewModel_NoData_Title",nil);
        [customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(customView.mas_bottom).mas_offset(-120 * DSCREEN_HEIGHT_SCALE);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = ZFCOLOR(51, 51, 51, 1);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:ZFLocalizedString(@"PopularViewModel_Refresh",nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(emptyOperationTouch) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 3;
        [customView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(33);
            make.centerX.mas_equalTo(customView.mas_centerX);
            make.width.mas_equalTo(@180);
            make.height.mas_equalTo(@40);
        }];
        
    }else {
        
        YYAnimatedImageView *imageView = [YYAnimatedImageView new];
        imageView.image = [UIImage imageNamed:@"photo"];
        [customView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(customView.mas_top).mas_offset(105 * DSCREEN_HEIGHT_SCALE);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"Posts from your Popular \n will appear here";
        [customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(20);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = ZFCOLOR(51, 51, 51, 1);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"Refresh" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(emptyOperationTouch) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 3;
        [customView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(33);
            make.centerX.mas_equalTo(customView.mas_centerX);
            make.width.mas_equalTo(@180);
            make.height.mas_equalTo(@40);
        }];
        
    }
    return customView;
}

#pragma mark - 谷歌统计
-(void)analyticsCommunityBannerWithBannerArray:(NSArray<JumpModel *> *)banners {
    NSMutableArray *screenNames = [NSMutableArray array];
    for (int i = 0; i < banners.count; i++) {
        JumpModel * banner = banners[i];
        NSString *screenName = [self bannerScreenKeyWithBannerName:banner.name];
        NSString *position = [NSString stringWithFormat:@"CommunityBanner - P%d", i+1];
        [screenNames addObject:@{@"name":screenName,@"position":position}];
    }
}

-(NSString *)bannerScreenKeyWithBannerName:(NSString *)name {
    return [NSString stringWithFormat:@"CommunityBanner - %@",name];
}

#pragma mark - 空字符串包含
-(BOOL)isEmpty:(NSString *) str {
    NSRange range = [str rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return  YES; //yes代表包含空格
    }else {
        return  NO;  //反之
    }
}

@end
