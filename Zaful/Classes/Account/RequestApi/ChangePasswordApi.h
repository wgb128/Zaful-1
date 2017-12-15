//
//  ChangePasswordApi.h
//  Dezzal
//
//  Created by ZJ1620 on 16/8/6.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ChangePasswordApi : SYBaseRequest

- (instancetype)initWithChangePasswordWith:(NSString *)oldPassword newPassword:(NSString *)newPassword confirmPassWord:(NSString *)confirmPassWord userId:(NSString *)userId;

@end
