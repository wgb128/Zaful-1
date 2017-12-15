//
//  LoginViewModel.h
//  Zaful
//
//  Created by ZJ1620 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface LoginViewModel : BaseViewModel

/**
 *登录接口
 *
 */
- (void)requestLoginNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

/**
 *Fbid检验接口
 *
 */
- (void)requestFbidCheckNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;


/**
 *FB登录
 *
 */
- (void)requestFBLoginNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

/**
 *Google登录
 *
 */
- (void)requestGoogleLoginNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

/**
 *
 *注册接口
 */
- (void)requestRegisterNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;


/**
 *忘记密码
 *
 */
- (void)requestForgotNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

@end
