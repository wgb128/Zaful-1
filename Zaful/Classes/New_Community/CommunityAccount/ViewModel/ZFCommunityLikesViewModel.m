
//
//  ZFCommunityLikesViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityLikesViewModel.h"
#import "ZFCommunityAccountLikesListModel.h"
#import "ZFCommunityStyleLikesApi.h"
#import "ZFCommunityAccountLikesModel.h"
#import "ZFCommunityFollowApi.h"
#import "ZFCommunityLikeApi.h"

@interface ZFCommunityLikesViewModel ()

@property (nonatomic, strong) ZFCommunityAccountLikesListModel      *likesListModel;

@end

@implementation ZFCommunityLikesViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    @weakify(self)
    
    ZFCommunityStyleLikesApi *api = [[ZFCommunityStyleLikesApi alloc] initWithUserid:parmaters[0] currentPage:[parmaters[1] integerValue]];
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
    
}
//点赞
- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    ZFCommunityAccountLikesModel *model = (ZFCommunityAccountLikesModel *)parmaters;
    ZFCommunityLikeApi *api = [[ZFCommunityLikeApi alloc] initWithReviewId:model.reviewId flag:!model.isLiked];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
        NSDictionary *dict = request.responseJSONObject;
        if ([dict[@"code"] integerValue] == 0) {
            if (completion) {
                completion(nil);
            }
        }
         [MBProgressHUD showMessage:dict[@"msg"]];
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
    
}

//关注
- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure; {
    ZFCommunityAccountLikesModel *model = (ZFCommunityAccountLikesModel *)parmaters;
    ZFCommunityFollowApi *api = [[ZFCommunityFollowApi alloc] initWithFollowStatue:!model.isFollow followedUserId:model.userId];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
        NSDictionary *dict = request.responseJSONObject;
        if ([dict[@"code"] integerValue] == 0) {
            if (completion) {
                completion(nil);
                
                 [MBProgressHUD showMessage:dict[@"msg"]];
            }
        }
        
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
    
}

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[ZFCommunityStyleLikesApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [ZFCommunityAccountLikesListModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}

@end
