//
//  LoginViewModel.m
//  Zaful
//
//  Created by ZJ1620 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "LoginViewModel.h"
#import "LoginApi.h"
#import "RegisterApi.h"
#import "ForgotPasswordApi.h"
#import "FbidCheckApi.h"
#import "FBLoginApi.h"
#import "GoogleLoginApi.h"
#ifdef LeandCloudEnabled
#   import <AVOSCloud/AVOSCloud.h>
#endif

static NSString *const RegisterKeyEmail = @"email";
static NSString *const RegisterKeyPassword = @"password";
static NSString *const RegisterKeyConfirmPassword = @"confirmPassword";

@implementation LoginViewModel


#pragma mark NetRequset
/**
 *登录接口
 *
 */
- (void)requestLoginNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    NSDictionary *dict = parmaters;
    LoginApi *loginApi = [[LoginApi alloc] initWithEmail:dict[RegisterKeyEmail] password:dict[RegisterKeyPassword]];
    [MBProgressHUD showLoadingView:nil];
    [loginApi  startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(loginApi.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSDictionary *dataDict = requestJSON[@"result"];
            if ([dataDict[@"error"] integerValue] == 0) {
                AccountModel *userModel = [AccountModel yy_modelWithJSON:dataDict[@"data"]];
                [[AccountManager sharedManager] updateUserInfo:userModel];
                [[NSUserDefaults standardUserDefaults] setValue:userModel.email forKey:kUserEmail];
                [[NSUserDefaults standardUserDefaults] setValue:@([dataDict[@"data"][@"cart_number"] integerValue]) forKey:kCollectionBadgeKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
#ifdef LeandCloudEnabled
                NSInteger user = [[[AccountManager sharedManager] userId] integerValue];
                AVInstallation *currentInstallationLeandcloud = [AVInstallation currentInstallation];
                [currentInstallationLeandcloud setObject:@(user) forKey:@"userId"];
                [currentInstallationLeandcloud setObject:@"YES" forKey:@"promotions"];
                [currentInstallationLeandcloud setObject:@"YES" forKey:@"orderMessages"];
                [currentInstallationLeandcloud setObject:[AppsFlyerTracker sharedTracker].getAppsFlyerUID forKey:@"appsFlyerId"];
                [currentInstallationLeandcloud setObject:[ZFLocalizationString shareLocalizable].nomarLocalizable forKey:@"language"];
                [currentInstallationLeandcloud saveInBackground];
#endif
                
                if (completion) {
                    completion(nil);
                }
            } else {
                 [MBProgressHUD showMessage:dataDict[@"msg"]];
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        ZFLog(@"\n-------------------------- 错误日志 --------------------------\n接口:%@\n状态码:%ld\n报错信息:%@",NSStringFromClass(request.class),request.responseStatusCode,request.responseString);
        if (failure) {
            failure(nil);
        }
         [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    
    }];
}

/**
 *Fbid检验接口
 *
 */
- (void)requestFbidCheckNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    FbidCheckApi *checkApi = [[FbidCheckApi alloc] initWithDict:parmaters];
    [MBProgressHUD showLoadingView:nil];
    [checkApi startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(checkApi.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSDictionary *dataDict = requestJSON[@"result"];
            if ([dataDict[@"error"] integerValue] == 0) {
                AccountModel *userModel = [AccountModel yy_modelWithJSON:dataDict[@"data"]];
                [[AccountManager sharedManager] updateUserInfo:userModel];
                [[NSUserDefaults standardUserDefaults] setValue:userModel.email forKey:kUserEmail];
                [[NSUserDefaults standardUserDefaults] setValue:@([dataDict[@"data"][@"cart_number"] integerValue]) forKey:kCollectionBadgeKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
#ifdef LeandCloudEnabled
                NSInteger user = [[[AccountManager sharedManager] userId] integerValue];
                AVInstallation *currentInstallationLeandcloud = [AVInstallation currentInstallation];
                [currentInstallationLeandcloud setObject:@(user) forKey:@"userId"];
                [currentInstallationLeandcloud setObject:@"YES" forKey:@"promotions"];
                [currentInstallationLeandcloud setObject:@"YES" forKey:@"orderMessages"];
                [currentInstallationLeandcloud setObject:[AppsFlyerTracker sharedTracker].getAppsFlyerUID forKey:@"appsFlyerId"];
                [currentInstallationLeandcloud setObject:[ZFLocalizationString shareLocalizable].nomarLocalizable forKey:@"language"];
                [currentInstallationLeandcloud saveInBackground];
#endif
                if (completion) {
                    completion(@YES);
                }
            } else {
                if (completion) {
                    completion(@NO);
                }
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}


/**
 *FB登录接口
 *
 */
- (void)requestFBLoginNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    FBLoginApi *api = [[FBLoginApi alloc] initWithDict:parmaters];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSDictionary *dataDict = requestJSON[@"result"];
            if ([dataDict[@"error"] integerValue] == 0) {
                 AccountModel *userModel = [AccountModel yy_modelWithJSON:dataDict[@"data"]];
                 [[AccountManager sharedManager] updateUserInfo:userModel];
                 [[NSUserDefaults standardUserDefaults] setValue:userModel.email forKey:kUserEmail];
                 [[NSUserDefaults standardUserDefaults] setValue:@([dataDict[@"data"][@"cart_number"] integerValue]) forKey:kCollectionBadgeKey];
                 [[NSUserDefaults standardUserDefaults] synchronize];
#ifdef LeandCloudEnabled
                NSInteger user = [[[AccountManager sharedManager] userId] integerValue];
                AVInstallation *currentInstallationLeandcloud = [AVInstallation currentInstallation];
                [currentInstallationLeandcloud setObject:@(user) forKey:@"userId"];
                [currentInstallationLeandcloud setObject:@"YES" forKey:@"promotions"];
                [currentInstallationLeandcloud setObject:@"YES" forKey:@"orderMessages"];
                [currentInstallationLeandcloud setObject:[AppsFlyerTracker sharedTracker].getAppsFlyerUID forKey:@"appsFlyerId"];
                [currentInstallationLeandcloud setObject:[ZFLocalizationString shareLocalizable].nomarLocalizable forKey:@"language"];
                [currentInstallationLeandcloud saveInBackground];
#endif
                if (completion) {
                    completion(nil);
                }
            } else {
                 [MBProgressHUD showMessage:dataDict[@"msg"]];
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        if (failure) {
            failure(nil);
        }
    }];
}

/**
 *Google登录接口
 *
 */
- (void)requestGoogleLoginNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    GoogleLoginApi *api = [[GoogleLoginApi alloc] initWithDict:parmaters];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
         if ([requestJSON[@"statusCode"] integerValue] == 200) {
             NSDictionary *dataDict = requestJSON[@"result"];
             if ([dataDict[@"error"] integerValue] == 0) {
                 AccountModel *userModel = [AccountModel yy_modelWithJSON:dataDict[@"returnInfo"]];
                 [[AccountManager sharedManager] updateUserInfo:userModel];
                 [[NSUserDefaults standardUserDefaults] setValue:userModel.email forKey:kUserEmail];
                 [[NSUserDefaults standardUserDefaults] setValue:@([dataDict[@"returnInfo"][@"cart_number"] integerValue]) forKey:kCollectionBadgeKey];
                 [[NSUserDefaults standardUserDefaults] synchronize];
#ifdef LeandCloudEnabled
                 NSInteger user = [[[AccountManager sharedManager] userId] integerValue];
                 AVInstallation *currentInstallationLeandcloud = [AVInstallation currentInstallation];
                 [currentInstallationLeandcloud setObject:@(user) forKey:@"userId"];
                 [currentInstallationLeandcloud setObject:@"YES" forKey:@"promotions"];
                 [currentInstallationLeandcloud setObject:@"YES" forKey:@"orderMessages"];
                 [currentInstallationLeandcloud setObject:[AppsFlyerTracker sharedTracker].getAppsFlyerUID forKey:@"appsFlyerId"];
                 [currentInstallationLeandcloud setObject:[ZFLocalizationString shareLocalizable].nomarLocalizable forKey:@"language"];
                 [currentInstallationLeandcloud saveInBackground];
#endif
                 if (completion) {
                     completion(nil);
                 }

             }else{
                 [MBProgressHUD showMessage:dataDict[@"msg"]];
             }
         }

    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        if (failure) {
            failure(nil);
        }
    }];
}

/**
 *
 *注册接口--用户注册
 */
- (void)requestRegisterNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    NSDictionary *dict = parmaters;
    RegisterApi *loginApi = [[RegisterApi alloc] initWithEmail:dict[RegisterKeyEmail] password:dict[RegisterKeyPassword]confirmPassword:dict[RegisterKeyConfirmPassword] sex:dict[@"sex"] issubscribe:dict[@"issubscribe"]];
    [MBProgressHUD showLoadingView:nil];
    [loginApi  startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(loginApi.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSDictionary *dataDict = requestJSON[@"result"];
            if ([dataDict[@"error"] integerValue] == 0) {
                AccountModel *userModel = [AccountModel yy_modelWithJSON:dataDict[@"data"]];
                [[AccountManager sharedManager] updateUserInfo:userModel];
                [[NSUserDefaults standardUserDefaults] setValue:userModel.email forKey:kUserEmail];
                [[NSUserDefaults standardUserDefaults] setValue:@([dataDict[@"data"][@"cart_number"] integerValue]) forKey:kCollectionBadgeKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
#ifdef LeandCloudEnabled
                NSInteger user = [[[AccountManager sharedManager] userId] integerValue];
                AVInstallation *currentInstallationLeandcloud = [AVInstallation currentInstallation];
                [currentInstallationLeandcloud setObject:@(user) forKey:@"userId"];
                [currentInstallationLeandcloud setObject:@"YES" forKey:@"promotions"];
                [currentInstallationLeandcloud setObject:@"YES" forKey:@"orderMessages"];
                [currentInstallationLeandcloud setObject:[AppsFlyerTracker sharedTracker].getAppsFlyerUID forKey:@"appsFlyerId"];
                [currentInstallationLeandcloud setObject:[ZFLocalizationString shareLocalizable].nomarLocalizable forKey:@"language"];
                [currentInstallationLeandcloud saveInBackground];
#endif
                if (completion) {
                    completion(nil);
                }
            }else{
                 [MBProgressHUD showMessage:dataDict[@"msg"]];
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        if (failure) {
            failure(nil);
        }
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

/**
 *忘记密码
 *
 */
- (void)requestForgotNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure
{
    ForgotPasswordApi *api = [[ForgotPasswordApi alloc] initWithEmail:parmaters];
    [MBProgressHUD showLoadingView:nil];
    [api  startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            
            NSDictionary *dataDict = requestJSON[@"result"];
            /**
             *
             *判断error字段是否成功
             */
            if ([dataDict[@"error"] integerValue] == 0) {
                if (completion) {
                    completion(nil);
                }
            } else {
                [MBProgressHUD showMessage:dataDict[@"msg"]];
                
            }
            
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        if (failure) {
            failure(nil);
        }
         [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];

}

@end
