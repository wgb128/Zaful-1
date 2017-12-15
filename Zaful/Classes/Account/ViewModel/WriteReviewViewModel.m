//
//  WriteReviewViewModel.m
//  Zaful
//
//  Created by DBP on 16/12/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "WriteReviewViewModel.h"
#import "WriteReviewApi.h"

@implementation WriteReviewViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    WriteReviewApi *api = [[WriteReviewApi alloc] initWithDict:parmaters];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        NSDictionary *dict = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        BOOL isSuccess = NO;
        if ([dict[@"code"] isEqualToString:@"10003"])      // 数据不完整
        {
            
        }
        else if ([dict[@"code"] isEqualToString:@"0"] || [dict[@"code"] isEqualToString:@"10007"])     // 评论成功  // 已经评论过
        {
            isSuccess = YES;
            
        }
        [MBProgressHUD showMessage:dict[@"msg"]];
        if (completion) {
            completion(@(isSuccess));
        }

    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        
    }];
}
@end
