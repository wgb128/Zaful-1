


//
//  ZFCommunityAccountViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityAccountViewModel.h"
#import "ZFCommunityAccountInfoModel.h"
#import "ZFCommunityUserInfoApi.h"
#import "ZFCommunityFollowApi.h"
#import "ZFCommunityMessageCountApi.h"

@interface ZFCommunityAccountViewModel ()

@end

@implementation ZFCommunityAccountViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    @weakify(self)
    
    ZFCommunityUserInfoApi *api = [[ZFCommunityUserInfoApi alloc] initWithUserid:parmaters];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        id result = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        if (completion) {
            completion(result);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

//关注
- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
    ZFCommunityAccountInfoModel *model = (ZFCommunityAccountInfoModel*)parmaters;
    ZFCommunityFollowApi *api = [[ZFCommunityFollowApi alloc] initWithFollowStatue:!model.isFollow followedUserId:model.userId];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
        
        NSDictionary *dict = request.responseJSONObject;
        if ([dict[@"code"] integerValue] == 0) {
            NSDictionary *dic = @{@"userId"   : model.userId ?: @"",
                                  @"isFollow" : @(!model.isFollow)};
            [[NSNotificationCenter defaultCenter] postNotificationName:kFollowStatusChangeNotification object:dic];
        }
         [MBProgressHUD showMessage:dict[@"msg"]];
        
        if (completion) {
            completion(nil);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
    
}

- (void)requestMessageCountNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
    
    ZFCommunityMessageCountApi *api = [[ZFCommunityMessageCountApi alloc] initWithUserid:parmaters];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        
        NSString *code = request.responseJSONObject[@"code"];
        NSString *messageTotal = request.responseJSONObject[@"total"];
        if ([code isEqualToString:@"0"])     // 获取评论成功
        {
            if (completion) {
                completion(messageTotal);
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
    if ([request isKindOfClass:[ZFCommunityUserInfoApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [ZFCommunityAccountInfoModel yy_modelWithJSON:json[@"data"]];
        }
    } else if ([request isKindOfClass:[ZFCommunityMessageCountApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return json[@"total"];
        }
    }

    return nil;
}


@end
