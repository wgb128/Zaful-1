
//
//  ZFCommunityOutfitsViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/7/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityOutfitsViewModel.h"
#import "ZFCommunityOutfitsApi.h"
#import "ZFCommunityOutfitsListModel.h"
#import "ZFCommunityOutfitsModel.h"
#import "ZFCommunityLikeApi.h"

@interface ZFCommunityOutfitsViewModel ()
@property (nonatomic, strong) ZFCommunityOutfitsListModel       *listModel;
@property (nonatomic, strong) NSMutableArray                    *dataArray;
@end

@implementation ZFCommunityOutfitsViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    NSInteger page = [parmaters[1] integerValue];
    
    if (page != 1 && page == [self.listModel.total integerValue]) {
        if (completion) {
            completion(NoMoreToLoad);
        }
        return ;
    }
    
    ZFCommunityOutfitsApi *api = [[ZFCommunityOutfitsApi alloc] initWithcurrentPage:page];
    @weakify(self);
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self);
        self.listModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        
        if (page == 1) {
            self.dataArray = [NSMutableArray arrayWithArray:self.listModel.outfitsList];
        }else{
            [self.dataArray addObjectsFromArray:self.listModel.outfitsList];
        }
        
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
        
        if (completion) {
            completion(self.dataArray);
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        @strongify(self)
        ZFLog(@"\n-------------------------- 错误日志 --------------------------\n接口:%@\n状态码:%ld\n报错信息:%@",NSStringFromClass(api.class),api.responseStatusCode,api.responseString);
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoNetType;
        ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
        if (failure) {
            failure(nil);
        }
    }];

}

- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
    ZFCommunityOutfitsModel *model = (ZFCommunityOutfitsModel *)parmaters;
    ZFCommunityLikeApi *api = [[ZFCommunityLikeApi alloc] initWithReviewId:model.reviewId flag:![model.liked boolValue]];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
        NSDictionary *dict = request.responseJSONObject;
        [MBProgressHUD showMessage:dict[@"msg"]];
        if ([dict[@"code"] integerValue] == 0) {
            if (completion) {
                completion(nil);
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
    if ([request isKindOfClass:[ZFCommunityOutfitsApi class]]) {
        if ([json[@"msg"] isEqualToString:@"Success"]) {
            return [ZFCommunityOutfitsListModel yy_modelWithJSON:json[@"data"]];
        }
        else {
            [MBProgressHUD showMessage:json[@"errors"]];
        }
    }
    return nil;
}
@end
