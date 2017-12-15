//
//  ZFCommunityExploreViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityExploreViewModel.h"
#import "ZFCommunityPopularApi.h"
#import "ZFCommunityExploreModel.h"
#import "ZFCommunityFollowApi.h"
#import "ZFCommunityFavesItemModel.h"
#import "ZFCommunityLikeApi.h"

@interface ZFCommunityExploreViewModel ()
@property (nonatomic, strong) ZFCommunityExploreModel       *homeModel;
@property (nonatomic, strong) NSMutableArray                *dataArray;
@end

@implementation ZFCommunityExploreViewModel
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
    
    ZFCommunityPopularApi *api = [[ZFCommunityPopularApi alloc] initWithcurrentPage:page];
    @weakify(self);
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self);
        self.homeModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        
        if (page == 1) {
            self.dataArray = [NSMutableArray arrayWithArray:self.homeModel.list];
        }else{
            [self.dataArray addObjectsFromArray:self.homeModel.list];
        }
        
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
        self.homeModel.list = self.dataArray;
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
}

//关注
- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
 
    ZFCommunityFavesItemModel *model = (ZFCommunityFavesItemModel *)parmaters;
    ZFCommunityFollowApi *api = [[ZFCommunityFollowApi alloc] initWithFollowStatue:!model.isFollow followedUserId:model.userId];
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

- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
    ZFCommunityFavesItemModel *model = (ZFCommunityFavesItemModel *)parmaters;
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

//解析
- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[ZFCommunityPopularApi class]]) {
        if ([json[@"msg"] isEqualToString:@"Success"]) {
            return [ZFCommunityExploreModel yy_modelWithJSON:json[@"data"]];
        }
        else {
            [MBProgressHUD showMessage:json[@"errors"]];
        }
    }
    return nil;
}


@end
