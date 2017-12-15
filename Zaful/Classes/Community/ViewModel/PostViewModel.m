//
//  PostViewModel.m
//  Yoshop
//
//  Created by zhaowei on 16/7/20.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "PostViewModel.h"
#import "PostApi.h"
#import "TabObtainApi.h"

@implementation PostViewModel
#pragma mark - request
- (void)requestTabObtainNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    @weakify(self)
    [NetworkStateManager networkState:^{
        
        @strongify(self)
        TabObtainApi *api = [[TabObtainApi alloc] init];
        // 显示菊花
        [api.accessoryArray addObject:[[RequestAccessory alloc] init]];
        @weakify(self)
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

- (void)requestPostNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    
    PostApi *api = [[PostApi alloc] initWithDict:parmaters];
    // 显示菊花
    [api.accessoryArray addObject:[RequestAccessory showLoadingView:nil]];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        id result = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        NSString *msg = request.responseJSONObject[@"msg"];
        if (result) {
            if (completion) {
                completion(msg);
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
    if ([request isKindOfClass:[TabObtainApi class]]) {
        
        if ([json[@"code"] integerValue] == 0) {
            return json[@"data"];
        }else {
            [MBProgressHUD showMessage:json[@"message"]];
        }
    } else if ([request isKindOfClass:[PostApi class]]) {
        
        if ([json[@"code"] integerValue] == 0) {
            return @(YES);
        }else {
             [MBProgressHUD showMessage:json[@"msg"]];
            return @(NO);
        }
    }
    return nil;
}
@end
