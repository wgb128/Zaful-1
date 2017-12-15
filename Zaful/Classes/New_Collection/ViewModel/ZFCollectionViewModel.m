//
//  ZFCollectionViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCollectionViewModel.h"
#import "ZFCollectionListModel.h"
#import "ZFCollectionLikeApi.h"
#import "ZFCollectionDeleteApi.h"

@interface ZFCollectionViewModel ()

@property (nonatomic, strong) NSMutableArray<ZFCollectionModel *>   *dataArray;

@property (nonatomic, strong) ZFCollectionListModel                 *listModel;

@end

@implementation ZFCollectionViewModel

- (void)requestCollectionNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    NSInteger page = 1;
    if ([parmaters intValue] == 0) {
        // 假如最后一页的时候
        if ([self.listModel.page integerValue] == [self.listModel.total_page integerValue]) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            return; // 直接返回
        }
        page = [self.listModel.page integerValue] + 1;
    }
    
    @weakify(self)
    ZFCollectionLikeApi *api = [[ZFCollectionLikeApi alloc] initWithCollectionWith:[AccountManager sharedManager].userId page:page pageSize:10];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        self.listModel = [self dataAnalysisFromJson:requestJSON request:api];
        if (page == 1) {
            self.dataArray = [NSMutableArray arrayWithArray:self.listModel.data];
        }else{
            [self.dataArray addObjectsFromArray:self.listModel.data];
        }
        self.listModel.data = self.dataArray;
        // 谷歌统计
        [ZFAnalytics showCollectionProductsWithProducts:self.listModel.data position:0 impressionList:@"Wishlist" screenName:@"Wishlist" event:nil];
        if (completion) {
            completion(self.listModel);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUD];
        if (failure) {
            failure(nil);
        }
    }];
}

- (void)requestDeleteCollectionNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    ZFCollectionDeleteApi *api = [[ZFCollectionDeleteApi alloc] initDeleteCollectionWith:[[AccountManager sharedManager] userId] goodsId:parmaters];
    [MBProgressHUD showLoadingView:nil];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        [MBProgressHUD hideHUD];
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            
            NSDictionary *dict = requestJSON[@"result"];
            
            if ([dict[@"error"] integerValue]== 0) {
                completion(nil);
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

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    if (!json) {
        return nil;
    }
    if ([request isKindOfClass:[ZFCollectionLikeApi class]]) {
        if ([json[@"statusCode"] integerValue] == 200) {
            return [ZFCollectionListModel yy_modelWithJSON:json[@"result"]];
        } else {
            [MBProgressHUD showMessage:json[@"msg"]];
        }
    }
    return nil;
}

@end
