//
//  ZFCommunityAccountOutfitsViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityAccountOutfitsViewModel.h"
#import "ZFCommunityAccountOutfitsApi.h"
#import "ZFCommunityOutfitsListModel.h"
#import "ZFCommunityLikeApi.h"
#import "ZFCommunityOutfitsModel.h"

@interface ZFCommunityAccountOutfitsViewModel ()
@property (nonatomic, strong) ZFCommunityOutfitsListModel       *listModel;
@property (nonatomic, strong) NSMutableArray                    *dataArray;
@end

@implementation ZFCommunityAccountOutfitsViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    NSInteger page = [parmaters[1] integerValue];
    NSString *userId = parmaters[2];
    if (page != 1 && page == [self.listModel.total integerValue]) {
        if (completion) {
            completion(NoMoreToLoad);
        }
        return ;
    }
    
    ZFCommunityAccountOutfitsApi *api = [[ZFCommunityAccountOutfitsApi alloc] initWithUserid:userId currentPage:page];
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
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoNetType;
        ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
        if (failure) {
            failure(nil);
        }
    }];
    
}

//点赞
- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    ZFCommunityOutfitsModel *model = (ZFCommunityOutfitsModel *)parmaters;
    ZFCommunityLikeApi *api = [[ZFCommunityLikeApi alloc] initWithReviewId:model.reviewId flag:![model.liked boolValue]];
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
    if ([request isKindOfClass:[ZFCommunityAccountOutfitsApi class]]) {
        if ([json[@"msg"] isEqualToString:@"Success"]) {
            return [ZFCommunityOutfitsListModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}
@end
