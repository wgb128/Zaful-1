//
//  ZFAddressCountryViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/9/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressCountryViewModel.h"
#import "ZFAddressCountryListApi.h"
#import "ZFAddressCountryModel.h"

@interface ZFAddressCountryViewModel ()
@property (nonatomic, strong) NSMutableArray        *dataArray;
@end

@implementation ZFAddressCountryViewModel
#pragma mark - Requset
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    @weakify(self)
    ZFAddressCountryListApi *api = [[ZFAddressCountryListApi alloc] init];//获取国家信息

    [api  startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            /**
             *  取的region_list就是级联信息接口里的 ountry list,返回的是国家,命名有问题.
             */
            self.dataArray = [self dataAnalysisFromJson:requestJSON request:api];
            if (completion) {
                completion(self.dataArray);
            }
            
        }else{
            
            [MBProgressHUD showMessage:requestJSON[@"_msg"]];
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
         [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    if (!json) {
        return nil;
    }
    //分类数据
    if ([request isKindOfClass:[ZFAddressCountryListApi class]]) {
        if ([json[@"statusCode"] integerValue] == 200) {
            return [NSArray yy_modelArrayWithClass:[ZFAddressCountryModel class] json:json[@"result"]];
        }
    }
    return nil;
}

@end
