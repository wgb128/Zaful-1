//
//  LikesViewModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/8/18.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "LikesViewModel.h"

#import "LikeApi.h"
#import "FollowApi.h"
#import "StyleLikesApi.h"
#import "StyleLikesCell.h"
#import "StyleLikesModel.h"
#import "StyleLikesListModel.h"

@interface LikesViewModel ()

@property (nonatomic,strong) StyleLikesListModel *likesListModel;

@property (nonatomic,assign) BOOL isLoadLike;     // 是否正在加载点攒接口

@property (nonatomic,assign) BOOL isLoadfollow; //是否关注

@end

@implementation LikesViewModel

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    @weakify(self)
    [NetworkStateManager networkState:^{
        StyleLikesApi *api = [[StyleLikesApi alloc] initWithUserid:parmaters[0] currentPage:[parmaters[1] integerValue]];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            @strongify(self)
            self.likesListModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
            self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.likesListModel.list] ? EmptyViewHideType : EmptyShowNoDataType;
            if (completion) {
                completion(self.likesListModel);
            }
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.likesListModel.list] ? EmptyViewHideType : EmptyShowNoDataType;
            if (failure) {
                failure(nil);
            }
        }];
    } exception:^{
        self.emptyViewShowType = EmptyShowNoNetType;
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
        
        BOOL isLiked = [[parmaters valueForKey:@"isLiked"] boolValue];
        NSString *reviewId = [parmaters valueForKey:@"reviewId"];
        LikeApi *api = [[LikeApi alloc] initWithReviewId:reviewId flag:!isLiked];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
            _isLoadLike = NO;
            NSDictionary *dict = request.responseJSONObject;
            if ([dict[@"code"] integerValue] == 0) {
                
                NSInteger likeCount = [[parmaters valueForKey:@"likeCount"] integerValue];
                if (!isLiked) {
                    likeCount += 1;
                }else{
                    likeCount -= 1;
                }
                NSString *addTime = [parmaters valueForKey:@"addTime"];
                NSString *avatar  = [parmaters valueForKey:@"avatar"];
                NSString *content = [parmaters valueForKey:@"content"];
                BOOL isFollow     = [[parmaters valueForKey:@"isFollow"] boolValue];
                NSString *nickName = [parmaters valueForKey:@"nickName"];
                NSString *replyCount = [parmaters valueForKey:@"replyCount"];
                NSArray *reviewPic = [parmaters valueForKey:@"reviewPic"];
                NSString *userId = [parmaters valueForKey:@"userId"];
                
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

//关注
- (void)requestFollowedNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    [NetworkStateManager networkState:^{
        if (_isLoadfollow) {
            return;
        }
        _isLoadfollow = YES;
        
        BOOL isFollow = [[parmaters valueForKey:@"isFollow"] boolValue];
        NSString *followedUserId = [parmaters valueForKey:@"userId"];
        FollowApi *api = [[FollowApi alloc] initWithFollowStatue:!isFollow followedUserId:followedUserId];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
            _isLoadfollow = NO;
            NSDictionary *dict = request.responseJSONObject;
            if ([dict[@"code"] integerValue] == 0) {
                NSDictionary *dic = @{@"userId"   : followedUserId,
                                      @"isFollow" : @(!isFollow)};
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

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[StyleLikesApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [StyleLikesListModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
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
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = ZFLocalizedString(@"LikesViewModel_NoData_NotLikes", nil);
    [customView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(customView.mas_top).offset(158*DSCREEN_HEIGHT_SCALE);
        make.centerX.mas_equalTo(customView.mas_centerX);
    }];

    return customView;
}

@end
