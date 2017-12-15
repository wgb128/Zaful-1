//
//  LabelDetailViewModel.m
//  Zaful
//
//  Created by DBP on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "LabelDetailViewModel.h"
#import "TopicDetailModel.h"
#import "LabelDetailApi.h"
#import "LabelDetailTableViewCell.h"
#import "FavesItemsModel.h"
#import "LikeApi.h"
#import "StyleLikesModel.h"
#import "LabelDetailListModel.h"

/*MyStyle控制器*/
#import "MyStylePageViewController.h"
/*帖子详情控制器*/
#import "CommunityDetailViewController.h"
#import "FollowApi.h"
#import "FavesItemsModel.h"
#import "TopicDetailListModel.h"
#import "LabelDetailViewController.h"
#import "ZFLoginViewController.h"

@interface LabelDetailViewModel ()
@property (nonatomic, strong) TopicDetailModel *topicDetailModel;
@property (nonatomic, assign) BOOL isLoadLike;     // 是否正在加载点攒接口
@property (nonatomic, assign) BOOL isLoadfollow;
@end

@implementation LabelDetailViewModel

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure{
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
        LabelDetailApi *api = [[LabelDetailApi alloc] initWithcurPage:page pageSize:PageSize topicLabel:parmaters[1]];
        @weakify(self)
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            
            @strongify(self)
            self.topicDetailModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
            
            if (page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:self.topicDetailModel.list];
                // 谷歌统计
                //                [self analyticsCommunityBannerWithBannerArray:self.homeModel.bannerlist];
            }else{
                [self.dataArray addObjectsFromArray:self.topicDetailModel.list];
            }
            self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
            
            if (completion) {
                completion(self.topicDetailModel);
            }
            
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
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


- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[LabelDetailApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [TopicDetailModel yy_modelWithJSON:json[@"data"]];
        }
        else {
            
        }
    }
    return nil;
}

#pragma mark - tableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LabelDetailTableViewCell *cell = [LabelDetailTableViewCell labelDetailTableViewCellWithTableView:tableView andIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置Cell选中效果
    LabelDetailListModel *reviewsModel = self.dataArray[indexPath.row];
    cell.model = reviewsModel;
    
    @weakify(self)
    /*-*-*-*-*-*-*-*-*-*点击头像判断是否要跳转-*-*-*-*-*-*-*-*-*/
    cell.communtiyMyStyleBlock = ^{
        @strongify(self)
        if ([reviewsModel.userId isEqualToString:USERID]) return;
        MyStylePageViewController *myStyleVC = [MyStylePageViewController new];
        myStyleVC.userid = reviewsModel.userId;
        [self.controller.navigationController pushViewController:myStyleVC animated:YES];
    };
    /*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
    
    cell.topicDetailBlock = ^(NSString *labName){
        @strongify(self)
        if ([self.labelName isEqualToString:labName]) return;
        LabelDetailViewController *topic = [LabelDetailViewController new];
        topic.labelName = labName;
        [self.controller.navigationController pushViewController:topic animated:YES];
    };
    
    /*-*-*-*-*-*-*-*-*-*点赞,评论,分享点击事件-*-*-*-*-*-*-*-*-*/
    cell.clickEventBlock = ^(UIButton *btn) {
        @strongify(self)
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
                    signVC.successBlock = ^{
                        @strongify(self)
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
                if ([AccountManager sharedManager].isSignIn) {
                    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:reviewsModel.reviewsId userId:reviewsModel.userId];
                    [self.controller.navigationController pushViewController:detailVC animated:YES];
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    signVC.successBlock = ^{
                        @strongify(self)
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
               
            }
                break;
            case followBtnTag:
            {
                if ([AccountManager sharedManager].isSignIn) {
                    [self requestFollowNetwork:reviewsModel completion:^(id obj) {
                        [tableView reloadData];
                    } failure:^(id obj) {
                        
                    }];
                    
                }else {
                    ZFLoginViewController *signVC = [ZFLoginViewController new];
                    @weakify(self)
                    signVC.successBlock = ^{
                        @strongify(self)
                        [self requestFollowNetwork:reviewsModel completion:^(id obj) {
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
    /*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:TOPIC_LABEL_CELL_IDENTIFIER cacheByIndexPath:indexPath configuration:^(LabelDetailTableViewCell *cell) {
        cell.model = self.dataArray[indexPath.row];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LabelDetailListModel *reviewsModel = self.dataArray[indexPath.row];
    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:reviewsModel.reviewsId userId:reviewsModel.userId];
    [self.controller.navigationController pushViewController:detailVC animated:YES];
}



@end
