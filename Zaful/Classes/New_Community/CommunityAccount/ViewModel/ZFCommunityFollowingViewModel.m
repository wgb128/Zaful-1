
//
//  ZFCommunityFollowingViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityFollowingViewModel.h"
#import "ZFCommunityFollowListModel.h"
#import "ZFCommunityFollowListApi.h"
#import "ZFCommunityFollowModel.h"
#import "ZFCommunityFollowApi.h"

@interface ZFCommunityFollowingViewModel ()
@property (nonatomic, strong) ZFCommunityFollowListModel        *followModel;
@property (nonatomic, strong) NSMutableArray<ZFCommunityFollowModel *> *dataArray;
@end

@implementation ZFCommunityFollowingViewModel
#pragma mark - Requset
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure
{
    @weakify(self)
    
    
    NSString *refreshOrLoadMore = (NSString *)parmaters;
    NSInteger page = 1;
    if ([refreshOrLoadMore integerValue] == 0) {
        // 假如最后一页的时候
        if (self.followModel.page == self.followModel.pageCount) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            return;
        }
        page = self.followModel.page  + 1;
    }
    
    ZFCommunityFollowListApi *api = [[ZFCommunityFollowListApi alloc] initWithCurPage:[@(page) stringValue] userListType:ZFUserListTypeFollowing userId:_userId];
    
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        self.followModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        // 列表数据
        if (page == 1) {
            self.dataArray = [NSMutableArray arrayWithArray:self.followModel.listArray];
        }else{
            [self.dataArray addObjectsFromArray:self.followModel.listArray];
        }
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
        if (completion) {
            completion(self.dataArray);
        }
    
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        @strongify(self)
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoNetType;
        if (failure) {
            failure(nil);
        }
    }];
}

- (void)requestFollowUserNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    ZFCommunityFollowModel *model = (ZFCommunityFollowModel *)parmaters;
    ZFCommunityFollowApi *api = [[ZFCommunityFollowApi alloc] initWithFollowStatue:!model.isFollow followedUserId:model.userId];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
        NSDictionary *dict = request.responseJSONObject;
        if ([dict[@"code"] integerValue] == 0) {
            BOOL isFollow = !model.isFollow;
            NSDictionary *dic = @{@"userId"   : model.userId,
                                  @"isFollow" : @(isFollow)};
            [[NSNotificationCenter defaultCenter] postNotificationName:kFollowStatusChangeNotification object:dic];
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


- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[ZFCommunityFollowListApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [ZFCommunityFollowListModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}
@end
