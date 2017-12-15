//
//  ModifyPorfileViewModel.m
//  Zaful
//
//  Created by DBP on 17/2/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ModifyPorfileViewModel.h"
#import "ProfileEditApi.h"
#import "ProfileInfoApi.h"

@interface ModifyPorfileViewModel ()
@end

@implementation ModifyPorfileViewModel

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    ProfileInfoApi *api = [[ProfileInfoApi alloc] init];
    [api.accessoryArray addObject:[RequestAccessory showLoadingView:nil]];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            AccountModel *userModel = [AccountModel yy_modelWithJSON:requestJSON[@"result"][@"user_info"]];
            
            if (completion) {
                completion(userModel);
                
            }else{
                [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
            }
            
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
    
}

- (void)requestSaveInfo:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    ProfileEditApi *api = [[ProfileEditApi alloc] initWithDic:parmaters];
    [api.accessoryArray addObject:[RequestAccessory showLoadingView:nil]];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
                if (completion) {
                    completion(nil);
                }
            }else{
                
                 [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
                
            }
            
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

@end
