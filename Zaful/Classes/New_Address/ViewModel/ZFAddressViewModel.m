//
//  ZFAddressViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressViewModel.h"
#import "ZFAddressDeleteApi.h"
#import "ZFAddressBookApi.h"
#import "ZFAddressDefaultApi.h"
#import "ZFAddressInfoModel.h"

@interface ZFAddressViewModel ()
@property (nonatomic, strong) NSMutableArray<ZFAddressInfoModel *>      *dataArray;
@end

@implementation ZFAddressViewModel
//请求地址列表
- (void)requestAddressListNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    @weakify(self)
    
    ZFAddressBookApi *addressBookApi = [[ZFAddressBookApi alloc] init];//传空,获取地址列表
    
    [addressBookApi  startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(addressBookApi.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            
            NSArray *tempArray = [NSArray yy_modelArrayWithClass:[ZFAddressInfoModel class] json:requestJSON[@"result"][@"data"]];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:tempArray];
            if (completion) {
                completion(self.dataArray);
            }
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];

}

//删除地址
- (void)requestDeleteAddressNetwork:(NSString *)addressId completion:(void (^)(BOOL isOK))completion {
    ZFAddressDeleteApi *api = [[ZFAddressDeleteApi alloc] initWithDeleteAddressId:addressId];
    __block BOOL _isOK = NO;
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            if ([requestJSON[@"result"][@"error"] integerValue] == 0) {
                _isOK = YES;
            }
            if (completion) {
                completion(_isOK);
            }
        }

    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];

}

//选择默认地址
- (void)requestsetDefaultAddressNetwork:(NSString *)addressId completion:(void (^)(BOOL isOK))completion {
    ZFAddressDefaultApi *api = [[ZFAddressDefaultApi alloc] initWithAddressId:addressId];
    __block BOOL _isOK = NO;
    [api  startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            _isOK = YES;
            if (completion) {
                completion(_isOK);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
         [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

#pragma mark - deal with data
- (NSMutableArray<ZFAddressInfoModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
