




//
//  ZFGoodsDetailReviewsViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/11/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailReviewsViewModel.h"
#import "GoodsDetailsReviewsModel.h"
#import "ZFGoodsReviewsApi.h"

@interface ZFGoodsDetailReviewsViewModel()
@property (nonatomic, strong) GoodsDetailsReviewsModel          *reviewsModel;
@property (nonatomic, strong) NSMutableArray                    *dataArray;
@end

@implementation ZFGoodsDetailReviewsViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    NSInteger page = 1;
    
    if ([parmaters[2] intValue] == 0) {
        // 假如最后一页的时候
        if (self.reviewsModel.page  == self.reviewsModel.pageCount) {
            return; // 直接返回
        }
        page = self.reviewsModel.page + 1;
    }
    ZFGoodsReviewsApi *api = [[ZFGoodsReviewsApi alloc] initWithGoodsID:parmaters[0] goodsSn:parmaters[1] page:[@(page) stringValue]];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        self.reviewsModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        if (completion) {
            completion(self.reviewsModel);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}


- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    if ([request isKindOfClass:[ZFGoodsReviewsApi class]]) {
        return [GoodsDetailsReviewsModel yy_modelWithJSON:json[@"response"]];
    }
    return nil;
}

@end
