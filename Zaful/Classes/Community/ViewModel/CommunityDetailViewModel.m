//
//  CommunityDetailViewModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CommunityDetailViewModel.h"

#import "LikeApi.h"//点赞
#import "CommunityDetailApi.h"//详情
#import "CommunityReplyApi.h"//回复
#import "CommunityReviewsApi.h"//评论

#import "StyleLikesModel.h"
#import "CommunityDetailModel.h"
#import "CommunityDetailReviewsModel.h"
#import "CommunityDetailReviewsListMode.h"
#import "FollowApi.h"
#import "DeleteApi.h"

@interface CommunityDetailViewModel ()

@property (nonatomic,strong) CommunityDetailModel *detailModel;
@property (nonatomic,strong) CommunityDetailReviewsModel *reviewsModel;
@property (nonatomic,strong) SYBatchRequest *batchRequest;
@property (nonatomic,assign) BOOL isLoadLike;     // 是否正在加载点攒接口
@property (nonatomic,assign) BOOL isLoadfollow;

@end

@implementation CommunityDetailViewModel

#define PageSize @"15"

#pragma mark Requset
- (void)requestNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
    NSLog(@"parmaters:%@",parmaters);
    [self.batchRequest.requestArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[SYNetworkManager sharedInstance] removeRequest:obj completion:nil];
    }];
    
    self.batchRequest = [[SYBatchRequest alloc] initWithRequestArray:@[[[CommunityDetailApi alloc] initWithReviewId:parmaters],[[CommunityReviewsApi alloc] initWithcurPage:[Refresh integerValue] pageSize:PageSize reviewId:parmaters]] enableAccessory:YES];
    @weakify(self);
    [self.batchRequest startWithBlockSuccess:^(SYBatchRequest *batchRequest) {
        NSArray *requests = batchRequest.requestArray;
        CommunityDetailApi *detailApi = (CommunityDetailApi *)requests[0];
        
        @strongify(self);
        self.detailModel = [self dataAnalysisFromJson: detailApi.responseJSONObject request:detailApi];
        
        CommunityReviewsApi *reviewsApi = (CommunityReviewsApi *)requests[1];
        
        self.reviewsModel = [self dataAnalysisFromJson: reviewsApi.responseJSONObject request:reviewsApi];
        
        //这个参数是从首页一直带过来的 评论需要 因为后台没有返回这个参数
        self.detailModel.reviewsId = parmaters;
        
        if (completion) {
            completion(@[self.detailModel == nil ? [CommunityDetailModel new] : self.detailModel,self.reviewsModel == nil ? [CommunityDetailReviewsModel new] : self.reviewsModel]);
        }
        
    } failure:^(SYBatchRequest *batchRequest) {
        if (failure) {
            failure(nil);
        }
    }];
}

- (void)requestReviewsListNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    [NetworkStateManager networkState:^{
        CommunityReviewsApi *api = [[CommunityReviewsApi alloc] initWithcurPage:[parmaters[0] integerValue] pageSize:PageSize reviewId:parmaters[1]];
        @weakify(self)
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            @strongify(self)
            self.reviewsModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
            
            if (completion) {
                completion(self.reviewsModel);
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

- (void)requestReplyNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    CommunityReplyApi *api = [[CommunityReplyApi alloc] initWithDict:parmaters];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
        NSDictionary *dict = request.responseJSONObject;
        
        if ([dict[@"code"] integerValue] == 0) {
            StyleLikesModel *likeModel = [StyleLikesModel new];
            likeModel.addTime = self.detailModel.addTime;
            likeModel.avatar = self.detailModel.avatar;
            likeModel.content = self.detailModel.content;
            likeModel.isFollow = self.detailModel.isFollow;
            likeModel.isLiked = !self.detailModel.isLiked;
            likeModel.likeCount = self.detailModel.likeCount;
            likeModel.nickName = self.detailModel.nickname;
            likeModel.replyCount = self.detailModel.replyCount;
            likeModel.reviewId = self.detailModel.reviewsId;
            likeModel.reviewPic = self.detailModel.reviewPic;
            likeModel.userId = self.detailModel.userId;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kReviewCountsChangeNotification object:likeModel];
            [MBProgressHUD showMessage:dict[@"msg"]];
        }

        if (completion) {
            completion(nil);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
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
        
        CommunityDetailModel *model = (CommunityDetailModel *)parmaters;
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
        
        self.detailModel = (CommunityDetailModel *)parmaters;
        LikeApi *api = [[LikeApi alloc] initWithReviewId:self.detailModel.reviewsId flag:!self.detailModel.isLiked];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            _isLoadLike = NO;
            NSDictionary *dict = request.responseJSONObject;
            [MBProgressHUD showMessage:dict[@"msg"]];
            if ([dict[@"code"] integerValue] == 0) {
                
                NSString *addTime = self.detailModel.addTime ?: @"";
                NSString *avatar  = self.detailModel.avatar ?: @"";
                NSString *content = self.detailModel.content ?: @"";
                BOOL isFollow     = self.detailModel.isFollow;
                NSString *nickName = self.detailModel.nickname ?: @"";
                NSString *replyCount = self.detailModel.replyCount ?: @"";
                NSArray *reviewPic = self.detailModel.reviewPic;
                NSString *userId = self.detailModel.userId ?: @"";
                NSInteger likeCount = [self.detailModel.likeCount integerValue];
                NSString *reviewId = self.detailModel.reviewsId ?: @"";
                BOOL isLiked = self.detailModel.isLiked;
                
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
    
    NSString *reviewId = self.detailModel.reviewsId;
    DeleteApi *api = [[DeleteApi alloc]initWithDeleteId:reviewId andUserId:self.detailModel.userId];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
        BOOL isSuccess = NO;
        NSString *code = request.responseJSONObject[@"code"];
        NSString *msg  = request.responseJSONObject[@"msg"];
        
        if ([code isEqualToString:@"0"])     // 获取评论成功
        {
            isSuccess = YES;
        } else {
            isSuccess = NO;
        }
        [MBProgressHUD showMessage:msg];
        if (completion) {
            completion(@(isSuccess));
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}


- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[CommunityDetailApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [CommunityDetailModel yy_modelWithJSON:json[@"data"]];
        }
    }else if ([request isKindOfClass:[CommunityReviewsApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [CommunityDetailReviewsModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}

@end
