//
//  ChangePasswordViewModel.m
//  Dezzal
//
//  Created by ZJ1620 on 16/8/6.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "ChangePasswordViewModel.h"
#import "ChangePasswordApi.h"

@interface ChangePasswordViewModel ()

@end

@implementation ChangePasswordViewModel

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure
{
    ChangePasswordApi *api = [[ChangePasswordApi alloc] initWithChangePasswordWith:parmaters[0] newPassword:parmaters[1] confirmPassWord:parmaters[2] userId:[[AccountManager sharedManager] userId]];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
  
        completion(requestJSON);
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        failure(nil);
    }];
}

@end
