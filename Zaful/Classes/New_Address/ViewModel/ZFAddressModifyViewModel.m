//
//  ZFAddressModifyViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressModifyViewModel.h"
#import "ZFAddressStateListApi.h"
#import "ZFAddressCityListApi.h"
#import "ZFAddressStateModel.h"
#import "ZFAddressAddApi.h"

@interface ZFAddressModifyViewModel ()

@end

@implementation ZFAddressModifyViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    ZFAddressAddApi *addressBookApi = [[ZFAddressAddApi alloc] initWithDic:parmaters];// 接口address/edit_address
    [MBProgressHUD showLoadingView:nil];
    [addressBookApi  startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(addressBookApi.class)];
        [MBProgressHUD hideHUD];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                
                [[AccountManager sharedManager] updateUserDefaultAddressId:[NSString stringWithFormat:@"%@",requestJSON[@"result"][@"address_id"]]];
                 [MBProgressHUD showMessage:ZFLocalizedString(@"ModifyAddress_Success_Show_Message",nil)];
                if (completion) {
                    completion(nil);
                }
            } else {
                 [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}




@end
