//
//  VideoViewModel.m
//  Zaful
//
//  Created by zhaowei on 2016/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "VideoViewModel.h"
#import "LikeApi.h"
#import "VideoDetailApi.h"
#import "VideoDetailModel.h"
#import "VideoDetailInfoModel.h"
#import "CommunityReplyApi.h"
#import "CommunityReviewsApi.h"
#import "CommunityDetailReviewsModel.h"

@interface VideoViewModel ()

@property (nonatomic, assign) BOOL isLoadLike; // 是否正在加载点赞接口

@property (nonatomic, strong) VideoDetailModel *detailmodel;

@property (nonatomic, strong) CommunityDetailReviewsModel *reviewsModel;

@property (nonatomic, strong) SYBatchRequest *batchRequest;
@end

@implementation VideoViewModel

- (void)requestNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
    [self.batchRequest.requestArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[SYNetworkManager sharedInstance] removeRequest:obj completion:nil];
    }];
    
    self.batchRequest = [[SYBatchRequest alloc] initWithRequestArray:@[[[VideoDetailApi alloc] initWithVideoId:parmaters],[[CommunityReviewsApi alloc] initWithcurPage:[Refresh integerValue] pageSize:PageSize reviewId:parmaters]] enableAccessory:YES];
    [self.batchRequest.accessoryArray addObject:[RequestAccessory showLoadingView:nil]];
    @weakify(self)
    [self.batchRequest startWithBlockSuccess:^(SYBatchRequest *batchRequest) {
        
        NSArray *requests = batchRequest.requestArray;
        
        VideoDetailApi *detailApi = (VideoDetailApi *)requests[0];
        
        @strongify(self)
        self.detailmodel = [self dataAnalysisFromJson: detailApi.responseJSONObject request:detailApi];
        
        CommunityReviewsApi *reviewsApi = (CommunityReviewsApi *)requests[1];
        
        self.reviewsModel = [self dataAnalysisFromJson: reviewsApi.responseJSONObject request:reviewsApi];
        if (self.reviewsModel == nil) {
            self.reviewsModel = [CommunityDetailReviewsModel new];
        }
        
        if (self.detailmodel == nil) {
            self.detailmodel = [VideoDetailModel new];
        }
        
        if (completion) {
            completion(@[self.detailmodel,self.reviewsModel]);
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
    [NetworkStateManager networkState:^{
        CommunityReplyApi *api = [[CommunityReplyApi alloc] initWithDict:parmaters];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
            NSDictionary *dict = request.responseJSONObject;
            
            if (completion) {
                completion(dict[@"msg"]);
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


- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    [NetworkStateManager networkState:^{
        NSInteger flag;
        
        if (self.detailmodel.videoInfo.isLike) {
            flag = 0;
        }else {
            flag = 1;
        }
        
        LikeApi *api = [[LikeApi alloc] initWithReviewId:parmaters flag:flag];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            
            _isLoadLike = NO;
            
            NSDictionary *dict = request.responseJSONObject;
            
            if ([dict[@"code"] integerValue] == 0) {
                //这里对数据源做处理进行修改
                if (flag) {
                    self.detailmodel.videoInfo.likeNum = [NSString stringWithFormat:@"%d",[self.detailmodel.videoInfo.likeNum intValue]+1];
                }else {
                    self.detailmodel.videoInfo.likeNum = [NSString stringWithFormat:@"%d",[self.detailmodel.videoInfo.likeNum intValue]-1];
                }
                
                self.detailmodel.videoInfo.isLike = flag;
                
            }else {
                
                [MBProgressHUD showMessage:dict[@"msg"]];
            }
            
            if (completion) {
                completion(self.detailmodel.videoInfo);
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
    if ([request isKindOfClass:[VideoDetailApi class]]) {
        if ([json[@"msg"] isEqualToString:@"Success"]) {
            return [VideoDetailModel yy_modelWithJSON:json[@"data"]];
        }
    }else if ([request isKindOfClass:[CommunityReviewsApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [CommunityDetailReviewsModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}

@end
