
//
//  ZFCommunityTopicListViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityTopicListViewModel.h"
#import "ZFCommunityTopicListModel.h"
#import "ZFCommunityTopicModel.h"
#import "ZFCommunityLabelDetailApi.h"
#import "ZFCommunityLikeApi.h"
#import "ZFCommunityFollowApi.h"

@interface ZFCommunityTopicListViewModel ()
@property (nonatomic, strong) ZFCommunityTopicListModel                 *topicModel;
@property (nonatomic, strong) NSMutableArray<ZFCommunityTopicModel *>   *dataArray;
@end

@implementation ZFCommunityTopicListViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure{
    
    NSArray *array = (NSArray *)parmaters;
    
    NSInteger page = 1;
    if ([array[0] integerValue] == 0) {
        // 假如最后一页的时候
        if ([self.topicModel.curPage integerValue] == self.topicModel.pageCount) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            return;
        }
        page = [self.topicModel.curPage integerValue]  + 1;
    }
    ZFCommunityLabelDetailApi *api = [[ZFCommunityLabelDetailApi alloc] initWithcurPage:page pageSize:PageSize topicLabel:parmaters[1]];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        @strongify(self)
        self.topicModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        
        if (page == 1) {
            self.dataArray = [NSMutableArray arrayWithArray:self.topicModel.list];
            // 谷歌统计
            //                [self analyticsCommunityBannerWithBannerArray:self.homeModel.bannerlist];
        }else{
            [self.dataArray addObjectsFromArray:self.topicModel.list];
        }
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
        
        if (completion) {
            completion(self.dataArray);
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];

}

//关注
- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
    ZFCommunityTopicModel *model = (ZFCommunityTopicModel *)parmaters;
    ZFCommunityFollowApi *api = [[ZFCommunityFollowApi alloc] initWithFollowStatue:!model.isFollow followedUserId:model.userId];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
        NSDictionary *dict = request.responseJSONObject;
        if ([dict[@"code"] integerValue] == 0) {
            BOOL isFollow = !model.isFollow;
            NSDictionary *dic = @{@"userId"   : model.userId,
                                  @"isFollow" : @(isFollow)};
            [[NSNotificationCenter defaultCenter] postNotificationName:kFollowStatusChangeNotification object:dic];

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
    
    ZFCommunityTopicModel *model = (ZFCommunityTopicModel *)parmaters;
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


- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[ZFCommunityLabelDetailApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [ZFCommunityTopicListModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}

@end
