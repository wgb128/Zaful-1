//
//  ShowsViewModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/8/18.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "ShowsViewModel.h"

#import "LikeApi.h"
#import "StyleShowsApi.h"
#import "StyleLikesModel.h"
#import "StyleShowsListModel.h"
#import "DeleteApi.h"

@interface ShowsViewModel ()

@property (nonatomic, strong) StyleShowsListModel *showsListModel;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,assign) BOOL isLoadLike;     // 是否正在加载点攒接口

@end

@implementation ShowsViewModel

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    @weakify(self)
    [NetworkStateManager networkState:^{
        StyleShowsApi *api = [[StyleShowsApi alloc] initWithUserid:parmaters[0] currentPage:[parmaters[1] integerValue]];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            @strongify(self)
            self.showsListModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
            self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.showsListModel.list] ? EmptyViewHideType : EmptyShowNoDataType;
            if (completion) {
                completion(self.showsListModel);
            }
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.showsListModel.list] ? EmptyViewHideType : EmptyShowNoDataType;
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
                userId = userId ? userId : @"";
                
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

//删除帖子
- (void)requestDeleteNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {

    @weakify(self)
    [NetworkStateManager networkState:^{
        NSString *reviewId = [parmaters valueForKey:@"reviewId"];
        NSString *userId = [parmaters valueForKey:@"userId"];
        DeleteApi *api = [[DeleteApi alloc]initWithDeleteId:reviewId andUserId:userId];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
            @strongify(self)
            BOOL isSuccess = NO;
            NSString *code = request.responseJSONObject[@"code"];
            NSString *msg  = request.responseJSONObject[@"msg"];
            
            if ([code isEqualToString:@"0"])     // 获取评论成功
            {
                isSuccess = YES;
            } else {
                isSuccess = NO;
                [MBProgressHUD showMessage:msg];
                
            }
            self.showsListModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
            self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.showsListModel.list] ? EmptyViewHideType : EmptyShowNoDataType;
            if (completion) {
                completion(@(isSuccess));
            }
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.showsListModel.list] ? EmptyViewHideType : EmptyShowNoDataType;
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

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[StyleShowsApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [StyleShowsListModel yy_modelWithJSON:json[@"data"]];
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
    titleLabel.text = ZFLocalizedString(@"ShowsViewModel_NoData_NotShowed",nil);
    [customView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(customView.mas_top).offset(158*DSCREEN_HEIGHT_SCALE);
        make.centerX.mas_equalTo(customView.mas_centerX);
    }];

    return customView;
}

@end
