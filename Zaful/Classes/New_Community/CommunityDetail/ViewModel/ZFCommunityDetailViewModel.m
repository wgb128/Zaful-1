//
//  ZFCommunityDetailViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityDetailViewModel.h"
#import "ZFCommunityDetailModel.h"
#import "ZFCommunityDetailReviewsListModel.h"
#import "ZFCommunityDetailApi.h"
#import "ZFCommunityReviewsApi.h"

@interface ZFCommunityDetailViewModel ()
@property (nonatomic,strong) ZFCommunityDetailModel *detailModel;
@property (nonatomic,strong) ZFCommunityDetailReviewsListModel *reviewsModel;
@property (nonatomic,strong) SYBatchRequest *batchRequest;
@end

@implementation ZFCommunityDetailViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    
    NSString *rid = parmaters;
    
    ZFCommunityDetailApi *api = [[ZFCommunityDetailApi alloc] initWithReviewId:rid];
    @weakify(self);
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        ZFCommunityDetailModel *model = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        if (completion) {
            completion(model);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

//评论列表
- (void)requestReviewsListNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    ZFCommunityReviewsApi *api = [[ZFCommunityReviewsApi alloc] initWithcurPage:[parmaters[0] integerValue] pageSize:PageSize reviewId:parmaters[1]];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        self.reviewsModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        
        if (completion) {
            completion(self.reviewsModel.list);
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];

}

//回复评论
- (void)requestReplyNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
}

//点赞
- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
}

- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
}

//删除
- (void)requestDeleteNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
}

#pragma mark - deal with data 
- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[ZFCommunityDetailApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [ZFCommunityDetailModel yy_modelWithJSON:json[@"data"]];
        }
    } else if ([request isKindOfClass:[ZFCommunityReviewsApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [ZFCommunityDetailReviewsListModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}



@end
