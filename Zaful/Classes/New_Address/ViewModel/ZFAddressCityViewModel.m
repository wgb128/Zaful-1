
//
//  ZFAddressCityViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/9/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressCityViewModel.h"
#import "ZFAddressCityListApi.h"
#import "ZFAddressCityModel.h"

@interface ZFAddressCityViewModel ()
@property (nonatomic, strong) NSMutableArray        *dataArray;
@end

@implementation ZFAddressCityViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    @weakify(self)
    ZFAddressCityListApi *api = [[ZFAddressCityListApi alloc] initWithProvinceId:parmaters[0] countryId:parmaters[1]];
    
    [api  startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        self.dataArray = [self dataAnalysisFromJson:requestJSON request:api];
        if (completion) {
            completion(self.dataArray);
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
    if ([request isKindOfClass:[ZFAddressCityListApi class]]) {
        if ([json[@"statusCode"] integerValue] == 200) {
            return [NSArray yy_modelArrayWithClass:[ZFAddressCityModel class] json:json[@"result"]];
        }
    }
    return nil;
}
@end
