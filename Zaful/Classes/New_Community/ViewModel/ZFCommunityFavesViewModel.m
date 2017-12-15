

//
//  ZFCommunityFavesViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityFavesViewModel.h"
#import "ZFCommunityFavesApi.h"
#import "ZFCommunityFavesModel.h"
#import "ZFCommunityFavesItemModel.h"
#import "ZFCommunityLikeApi.h"

@interface ZFCommunityFavesViewModel ()
@property (nonatomic, strong) ZFCommunityFavesModel     *model;
@property (nonatomic, strong) NSMutableArray            *dataArray;
@end

@implementation ZFCommunityFavesViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    NSInteger page = 1;
    if ([parmaters integerValue] == 0) {
        // 假如最后一页的时候
        if ([self.model.curPage integerValue] == self.model.pageCount) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            return;
        }
        page = [self.model.curPage integerValue]  + 1;
    }
    
    ZFCommunityFavesApi *api = [[ZFCommunityFavesApi alloc] initWithcurrentPage:page];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
        @strongify(self)
        self.model = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        
        //列表数据
        if (page == 1) {
            self.dataArray = [NSMutableArray arrayWithArray:self.model.list];
        }else{
            [self.dataArray addObjectsFromArray:self.model.list];
        }
        
        //判断数据设置空页面
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
        
        if (completion) {
            completion(self.dataArray);
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        @strongify(self)
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoNetType;
        if (failure) {
            failure(self.dataArray);
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

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[ZFCommunityFavesApi class]]) {
        if ([json[@"msg"] isEqualToString:@"Success"]) {
            return [ZFCommunityFavesModel yy_modelWithJSON:json[@"data"]];
        }
        else {
            [MBProgressHUD showMessage:json[@"errors"]];
        }
    }
    return nil;
}

@end
