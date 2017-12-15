//
//  CheckReviewViewModel.m
//  Zaful
//
//  Created by DBP on 16/12/27.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "CheckReviewViewModel.h"
#import "CheckReviewApi.h"
#import "CheckReviewModel.h"

@interface CheckReviewViewModel ()
@property (nonatomic, strong) CheckReviewModel *checkModel;
@end

@implementation CheckReviewViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    CheckReviewApi *api = [[CheckReviewApi alloc]initWithDict:parmaters];
    [api.accessoryArray addObject:[RequestAccessory showLoadingView:self.controller.view]];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        self.checkModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        BOOL isSuccess = NO;
        NSString *code = request.responseJSONObject[@"response"][@"code"];
        NSString *msg  = request.responseJSONObject[@"response"][@"msg"];
        
        if ([code isEqualToString:@"0"]) {
            isSuccess = YES;
        } else {
            [MBProgressHUD showMessage:msg];
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@(isSuccess) forKey:@"status"];
        if (self.checkModel){
            [dict setValue:self.checkModel forKey:@"model"];
        }
        
        if (completion) {
            completion(dict);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request
{
    if ([request isKindOfClass:[CheckReviewApi class]]) {
        return [CheckReviewModel yy_modelWithJSON:json[@"response"][@"data"]];
    }
    return nil;
}

@end
