


//
//  ZFGoodsDetailViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/11/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailViewModel.h"
#import "ZFGoodsDetailApi.h"
#import "ZFGoodsDetailCollectionApi.h"
#import "ZFCollectionDeleteApi.h"
#import "ZFGoodsAddToCartApi.h"
#import "GoodsDetailModel.h"



@interface ZFGoodsDetailViewModel()
@property (nonatomic, strong) GoodsDetailModel          *goodsDetailModel;
@end

@implementation ZFGoodsDetailViewModel

//请求商品详情页商品信息
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    [MBProgressHUD showLoadingView:nil];
    ZFGoodsDetailApi *api = [[ZFGoodsDetailApi alloc] initWithGoodsDetialUserId:[[AccountManager sharedManager] userId] goodsId:parmaters];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        [MBProgressHUD hideHUD];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSDictionary *dataDict = requestJSON[@"result"];
            if ([dataDict[@"error"] integerValue] == 0) {
                self.goodsDetailModel = [self dataAnalysisFromJson:requestJSON request:api];
                // 谷歌统计
                [ZFAnalytics showDetailProductsWithProducts:self.goodsDetailModel.same_cat_goods position:0 impressionList:@"Product Detail Recommend" screenName:@"Product Detail" event:nil];
                [ZFAnalytics appsFlyerTrackEvent:@"af_view_product" withValues:@{
                                                                                 @"content_ids" : self.goodsDetailModel.goods_sn,
                                                                                 @"content_type" : self.goodsDetailModel.long_cat_name
                                                                                 }];
                
                if (completion) {
                    completion(self.goodsDetailModel);
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

- (void)requestDeleteGoodsNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    ZFCollectionDeleteApi *api = [[ZFCollectionDeleteApi alloc] initDeleteCollectionWith:[[AccountManager sharedManager] userId] goodsId:parmaters];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSDictionary *dict = requestJSON[@"result"];
            if ([dict[@"error"] integerValue] == 0) {
                if (completion) {
                    completion(nil);
                }
                
            } else {
                [MBProgressHUD showMessage:dict[@"msg"]];
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

- (void)requestCollectionGoodsNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    ZFGoodsDetailCollectionApi *api = [[ZFGoodsDetailCollectionApi alloc] initWithAddCollectionGoodsId:parmaters];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            NSDictionary *dict = requestJSON[@"result"];
            if ([dict[@"error"] integerValue] == 0) {
                [[NSUserDefaults standardUserDefaults] setValue:dict[@"data"][@"sess_id"] forKey:kSessionId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (completion) {
                    completion(nil);
                }
            } else {
                [MBProgressHUD showMessage:dict[@"msg"]];
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

- (void)requestAddToBagNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    NSString *goodsId = parmaters[0];
    NSInteger goodsNumber = [parmaters[1] integerValue];
    ZFGoodsAddToCartApi *carListApi = [[ZFGoodsAddToCartApi alloc] initWithGoodsId:goodsId goodsNumber:goodsNumber];
    
    [MBProgressHUD showLoadingView:nil];
    [carListApi startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(carListApi.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            
            [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
            if (![requestJSON[@"result"][@"error"] boolValue]) {
                [[NSUserDefaults standardUserDefaults] setValue:requestJSON[@"result"][@"sess_id"] forKey:kSessionId];
                [[NSUserDefaults standardUserDefaults] setValue:@([requestJSON[@"result"][@"goods_count"] integerValue]) forKey:kCollectionBadgeKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:kCartNotification object:nil];
                if (completion) {
                    completion(nil);
                }
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

#pragma mark - deal data methods
- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    if ([request isKindOfClass:[ZFGoodsDetailApi class]]) {
        if ([json[@"statusCode"] integerValue] == 200) {
            return [GoodsDetailModel yy_modelWithJSON:json[@"result"]];
        } else {
            [MBProgressHUD showMessage:json[@"msg"]];
        }
    }
    return nil;
}

@end
