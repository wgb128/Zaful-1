//
//  ZFCommunityShowViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityShowViewModel.h"
#import "ZFCommunityAccountShowsListModel.h"
#import "ZFCommunityStyleShowsApi.h"
#import "ZFCommunityLikeApi.h"
#import "ZFCommunityAccountShowsModel.h"
#import "ZFCommunityDeleteApi.h"

@interface ZFCommunityShowViewModel ()
@property (nonatomic, strong) ZFCommunityAccountShowsListModel      *showsListModel;
@end

@implementation ZFCommunityShowViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    @weakify(self)
    
    ZFCommunityStyleShowsApi *api = [[ZFCommunityStyleShowsApi alloc] initWithUserid:parmaters[0] currentPage:[parmaters[1] integerValue]];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        self.showsListModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.showsListModel.list] ? EmptyViewHideType : EmptyShowNoDataType;
        if (completion) {
            completion(self.showsListModel);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.showsListModel.list] ? EmptyViewHideType : EmptyShowNoDataType;
        if (failure) {
            failure(nil);
        }
    }];
    
}

//点赞
- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    ZFCommunityAccountShowsModel *model = (ZFCommunityAccountShowsModel *)parmaters;
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

//删除帖子
- (void)requestDeleteNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
    @weakify(self)
    NSString *reviewId = [parmaters valueForKey:@"reviewId"];
    NSString *userId = [parmaters valueForKey:@"userId"];
    ZFCommunityDeleteApi *api = [[ZFCommunityDeleteApi alloc]initWithDeleteId:reviewId andUserId:userId];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
        @strongify(self)
        BOOL isSuccess = NO;
        NSString *code = request.responseJSONObject[@"code"];
//        NSString *msg  = request.responseJSONObject[@"msg"];
        
        if ([code isEqualToString:@"0"])     // 获取评论成功
        {
            isSuccess = YES;
        } else {
            isSuccess = NO;
        }
        self.showsListModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.showsListModel.list] ? EmptyViewHideType : EmptyShowNoDataType;
        if (completion) {
            completion(@(isSuccess));
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        self.emptyViewShowType = ![NSArrayUtils isEmptyArray:self.showsListModel.list] ? EmptyViewHideType : EmptyShowNoDataType;
        if (failure) {
            failure(nil);
        }
    }];
    
    
}

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[ZFCommunityStyleShowsApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [ZFCommunityAccountShowsListModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}
@end
