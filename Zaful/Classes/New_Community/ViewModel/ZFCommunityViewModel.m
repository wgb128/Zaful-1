
//
//  ZFCommunityViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityViewModel.h"
#import "ZFCommunityMessageCountApi.h"

@implementation ZFCommunityViewModel
- (void)requestMessageCountNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    
    
    ZFCommunityMessageCountApi *api = [[ZFCommunityMessageCountApi alloc] initWithUserid:parmaters];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        
        NSString *code = request.responseJSONObject[@"code"];
        //        NSString *msg  = request.responseJSONObject[@"msg"];
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

@end
