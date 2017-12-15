
//
//  HelpViewModel.m
//  Zaful
//
//  Created by Y001 on 16/9/21.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HelpViewModel.h"
#import "HelpApi.h"
#import "HelpModel.h"

@interface HelpViewModel ()

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation HelpViewModel

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure
{
    [NetworkStateManager networkState:^{
        
        HelpApi * helpApi = [[HelpApi alloc]init];
        [helpApi startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            
            id requestJosn = [NSStringUtils desEncrypt:request api:NSStringFromClass(helpApi.class)];
            
            _dataArray = [self dataAnalysisFromJson:requestJosn request:helpApi];
            
            if (completion) {
                completion(_dataArray);
            }
            
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            if (failure) {
                failure(nil);
            }
        }];
        
    } exception:^{
        if (failure) {
            failure(nil);
        }
    }];
}

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    //分类数据
    if ([request isKindOfClass:[HelpApi class]]) {
        if ([json[@"statusCode"] integerValue] == 200) {
            return [NSArray  yy_modelArrayWithClass:[HelpModel class]json:json[@"result"]];
        }
    }
    
    return nil;
}

@end
