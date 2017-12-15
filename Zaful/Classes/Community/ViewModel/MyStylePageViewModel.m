//
//  MyStylePageViewModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/8/19.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "MyStylePageViewModel.h"

#import "UserInfoApi.h"
#import "UserInfoModel.h"
#import "FollowApi.h"

@interface MyStylePageViewModel ()

@property (nonatomic, assign) BOOL isLoadfollow;

@end

@implementation MyStylePageViewModel

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    @weakify(self)
    [NetworkStateManager networkState:^{
        UserInfoApi *api = [[UserInfoApi alloc] initWithUserid:parmaters];
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
    } exception:^{
        if (failure) {
            failure(nil);
        }
    }];
}

//关注
- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    [NetworkStateManager networkState:^{
        if (_isLoadfollow) {
            return;
        }
        _isLoadfollow = YES;
        
        UserInfoModel *model = (UserInfoModel*)parmaters;
        FollowApi *api = [[FollowApi alloc] initWithFollowStatue:!model.isFollow followedUserId:model.userId];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
            _isLoadfollow = NO;
            NSDictionary *dict = request.responseJSONObject;
            if ([dict[@"code"] integerValue] == 0) {
                NSDictionary *dic = @{@"userId"   : model.userId,
                                      @"isFollow" : @(!model.isFollow)};
                [[NSNotificationCenter defaultCenter] postNotificationName:kFollowStatusChangeNotification object:dic];
            }
            [MBProgressHUD showMessage:dict[@"msg"]];
            
            if (completion) {
                completion(nil);
            }
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            _isLoadfollow = NO;
            if (failure) {
                failure(nil);
            }
        }];
    } exception:^{
        if (failure) {
            failure(nil);
        }
    }];
}

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[UserInfoApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [UserInfoModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}

@end
