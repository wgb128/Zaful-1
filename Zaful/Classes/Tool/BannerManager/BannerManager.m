//
//  BannerManager.m
//  Zaful
//
//  Created by TsangFa on 16/10/27.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "BannerManager.h"
#import "BannerModel.h"
#import "ZFWebViewViewController.h"
#import "JumpModel.h"
#import "JumpManager.h"
#import "CategoryDataApi.h"
#import "CategoryNewModel.h"

@interface BannerManager ()
@property (nonatomic, strong)  NSMutableDictionary         *params;
@end

@implementation BannerManager

+ (void)doBannerActionTarget:(id)target withBannerModel:(BannerModel *)bannerModel {
    
    NSString *url = bannerModel.deeplink_uri;
    if ([NSStringUtils isBlankString:url]) {
        return;
    }
    
    UIViewController *targetVC = target;
    NSString *str1 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *banner_url = [NSURL URLWithString:str1];
    NSString *scheme = [banner_url scheme];
    if ([scheme isEqualToString:@"zaful"]) {
        BannerManager *manger = [[BannerManager alloc] init];
        [manger parseURLParams:banner_url];
        if ([manger.params[@"actiontype"] isEqualToString:@"2"]) { // 如果检测到是跳分类,先请求分类数据 (后期加入缓存优化)
            [manger requestCategoryDataCompletion:^{
                [manger deeplinkHandle:targetVC];
            }];
        }else{
            [manger deeplinkHandle:targetVC];
        }
        return;
    }
    
    ZFWebViewViewController *webViewVC = [[ZFWebViewViewController alloc] init];
    webViewVC.link_url = url;
    [targetVC.navigationController pushViewController:webViewVC animated:YES];
}

- (void)parseURLParams:(NSURL *)url {
    [self.params removeAllObjects];
    if (url.query) {
        NSArray *arr = [url.query componentsSeparatedByString:@"&"];
        for (NSString *str in arr) {
            if ([str rangeOfString:@"="].location != NSNotFound) {
                NSString *key = [str componentsSeparatedByString:@"="][0];
                NSString *value;
                if ([key isEqualToString:@"url"]) {
                    value = [str substringFromIndex:4] ;
                }else{
                    value = [str componentsSeparatedByString:@"="][1];
                }
                NSString *decodeValue = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self.params setObject:decodeValue forKey:key];
            }
        }
        ZFLog(@"\n================================ 参数 =======================================\n👉: %@", self.params);
    }
}

- (void)deeplinkHandle:(id)target {
    JumpModel *jumpModel = [[JumpModel alloc] init];
    jumpModel.actionType = [NSStringUtils isEmptyString:_params[@"actiontype"]] ? JumpDefalutActionType : [_params[@"actiontype"] integerValue];
    jumpModel.url        = NullFilter(_params[@"url"]);
    jumpModel.name       = NullFilter(_params[@"name"]);
    [JumpManager doJumpActionTarget:target withJumpModel:jumpModel];
}

- (void)requestCategoryDataCompletion:(void (^)())completion {
    CategoryDataApi *api = [[CategoryDataApi alloc] initCategoryDataApi];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        if (request.responseStatusCode == 200) {
            NSArray<CategoryNewModel *> *categorysArray = [NSArray  yy_modelArrayWithClass:[CategoryNewModel class] json:requestJSON[@"result"]];
            [CategoryDataManager shareManager].isVirtualCategory = NO;
            [[CategoryDataManager shareManager] parseCategoryData:categorysArray];
            // 统计
            [self analyticsCateBannerWithCateArray:categorysArray name:@"Cate"];
            if (completion) {
                completion(nil);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)analyticsCateBannerWithCateArray:(NSArray<CategoryNewModel *> *)cateArray name:(NSString *)name{
    NSMutableArray *screenNames = [NSMutableArray array];
    for (int i = 0; i < cateArray.count; i++) {
        CategoryNewModel * model = cateArray[i];
        NSString *screenName = [NSString stringWithFormat:@"%@ - %@",name,model.cat_name];
        NSString *position = [NSString stringWithFormat:@"%@ - P%d",name, i+1];
        [screenNames addObject:@{@"name":screenName,@"position":position}];
    }
    [ZFAnalytics showAdvertisementWithBanners:screenNames position:nil screenName:@"Category"];
}

#pragma mark - Getter
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return  _params;
}

@end
