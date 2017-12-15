//
//  CommunityViewModel.m
//  Zaful
//
//  Created by zhaowei on 2017/1/15.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CommunityViewModel.h"
#import "MessageCountApi.h"

@implementation CommunityViewModel
//Popluar频道
- (void)requestNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    [NetworkStateManager networkState:^{
        
        MessageCountApi *api = [[MessageCountApi alloc] initWithUserid:parmaters];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            
            NSString *code = request.responseJSONObject[@"code"];
            NSString *msg  = request.responseJSONObject[@"msg"];
            NSString *messageTotal = request.responseJSONObject[@"total"];
            if ([code isEqualToString:@"0"])     // 获取评论成功
            {
                if (completion) {
                    completion(messageTotal);
                }
           
            } else {
                [MBProgressHUD showMessage:msg];
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

//解析
- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[MessageCountApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return json[@"total"];
        }
        else {
            [MBProgressHUD showMessage:json[@"errors"]];
        }
    }
    return nil;
}

@end
