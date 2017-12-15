
//
//  ZFCommunitySearchResultViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/7/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunitySearchViewModel.h"
#import "ZFCommunityFriendsResultApi.h"
#import "ZFCommunityFollowApi.h"
#import "ZFCommunityCommendUserApi.h"
#import "ZFCommunitySearchResultListModel.h"
#import "ZFCommunitySuggestedUsersListModel.h"
#import "ZFCommunitySearchResultModel.h"
#import "ZFCommunitySuggestedUsersModel.h"

@interface ZFCommunitySearchViewModel ()
@property (nonatomic, strong) NSMutableArray<ZFCommunitySearchResultModel *>    *resultDataArray;
@property (nonatomic, strong) NSMutableArray<ZFCommunitySuggestedUsersModel *>  *suggestedDataArray;
@property (nonatomic, strong) ZFCommunitySearchResultListModel                  *searchListModel;
@property (nonatomic, strong) ZFCommunitySuggestedUsersListModel                *suggestedUsersListModel;
@end

@implementation ZFCommunitySearchViewModel
#pragma mark - request methods
- (void)requestSearchUsersNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    NSArray *array = (NSArray *)parmaters;
    NSInteger page = 1;
    if ([array[0] integerValue] == 0) {
        // 假如最后一页的时候
        if ([self.searchListModel.curPage integerValue] == self.searchListModel.pageCount) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            return;
        }
        page = [self.searchListModel.curPage integerValue]  + 1;
    }
    NSString *searchKey = array[1] ?: @"";
    ZFCommunityFriendsResultApi *api = [[ZFCommunityFriendsResultApi alloc] initWithkeyWord:searchKey andCurPage:page pageSize:[PageSize integerValue]];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        @strongify(self)
        self.searchListModel = [self dataAnalysisForSearchResultFromJson: request.responseJSONObject request:api];
        
        if (page == 1) {
            self.resultDataArray = [NSMutableArray arrayWithArray:self.searchListModel.searchList];
        }else{
            [self.resultDataArray addObjectsFromArray:self.searchListModel.searchList];
        }
        self.emptyViewShowType = self.resultDataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
        
        if (completion) {
            completion(self.resultDataArray);
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    NSInteger page = 1;
    if ([parmaters integerValue] == 0) {
        // 假如最后一页的时候
        if ([self.suggestedUsersListModel.curPage integerValue] == self.suggestedUsersListModel.pageCount) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            return;
        }
        page = [self.suggestedUsersListModel.curPage integerValue]  + 1;
    }
    
    
    ZFCommunityCommendUserApi *api = [[ZFCommunityCommendUserApi alloc] initWithcurPage:page pageSize:[PageSize integerValue]];
    @weakify(self);
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        @strongify(self);
        self.suggestedUsersListModel = [self dataAnalysisForSuggestedUsersFromJson:request.responseJSONObject request:api];
        
        if (page == 1) {
            self.suggestedDataArray = [NSMutableArray arrayWithArray:self.suggestedUsersListModel.suggestedList];
        }else{
            [self.suggestedDataArray addObjectsFromArray:self.suggestedUsersListModel.suggestedList];
        }
        
        self.emptyViewShowType = self.suggestedDataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
        
        if (completion) {
            completion(self.suggestedDataArray);
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
    
    
}

//关注用户
- (void)requestFollowedNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    NSString *followedUserId = [parmaters valueForKey:@"user_id"];
    ZFCommunityFollowApi *api = [[ZFCommunityFollowApi alloc] initWithFollowStatue:YES followedUserId:followedUserId];
    //    [api.accessoryArray addObject:[[RequestAccessory alloc] initWithApperOnView:self.controller.view]];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        NSDictionary *dict = request.responseJSONObject;
        if ([dict[@"code"] integerValue] == 0) {
            NSDictionary *dic = @{@"userId"   : followedUserId,
                                  @"isFollow" : @(YES)};
            [[NSNotificationCenter defaultCenter] postNotificationName:kFollowStatusChangeNotification object:dic];
        }
        [HUDManager showHUDWithMessage:dict[@"msg"]];
        
        if (completion) {
            completion(nil);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
    
}

#pragma mark - deal with datas

//搜索结果数据解析
- (id)dataAnalysisForSearchResultFromJson:(id)json request:(SYBaseRequest *)request {
    if ([request isKindOfClass:[ZFCommunityFriendsResultApi class]]) {
        if ([json[@"msg"] isEqualToString:@"Success"]) {
            return [ZFCommunitySearchResultListModel yy_modelWithJSON:json[@"data"]];
        } else {
            [self alertMessage:json[@"errors"]];
        }
    }
    return nil;
}

- (id)dataAnalysisForSuggestedUsersFromJson:(id)json request:(SYBaseRequest *)request{
    if ([request isKindOfClass:[ZFCommunityCommendUserApi class]]) {
        if ([json[@"msg"] isEqualToString:@"Success"]) {
            NSLog(@"==================%@", json[@"data"]);
            return [ZFCommunitySuggestedUsersListModel yy_modelWithJSON:json[@"data"]];
        }
        else {
            [self alertMessage:json[@"errors"]];
        }
    }
    return nil;
}

@end
