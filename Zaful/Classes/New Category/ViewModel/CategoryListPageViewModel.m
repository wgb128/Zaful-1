//
//  CategoryListPageViewModel.m
//  ListPageViewController
//
//  Created by TsangFa on 16/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryListPageViewModel.h"
#import "CategoryListPageApi.h"
#import "CategoryVirtualApi.h"
#import "CategoryNewRefineApi.h"
#import "CategoryListPageCell.h"
#import "CategoryRefineSectionModel.h"
#import "CategoryPriceListModel.h"

@interface CategoryListPageViewModel ()
@property (nonatomic, strong) CategoryListPageModel   *model;
@property (nonatomic, strong) NSMutableArray          *goodsArray;
@end

@implementation CategoryListPageViewModel
#pragma mark - Public Methods
- (void)requestListPageDataWithParmaters:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    id dict = [self calculatePageNumber:parmaters];
    if (dict == nil) {
        completion(NoMoreToLoad);
        return;
    }
    
    CategoryListPageApi *api = [[CategoryListPageApi alloc] initListPageApiWithParameter:dict];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        if (![self.lastCategoryID isEqualToString:dict[@"cat_id"]]) {
            [self.goodsArray removeAllObjects];
        }
        
        NSMutableArray *indexPaths = [self queryInsertIndexPaths:request api:NSStringFromClass(api.class)];
        if (indexPaths.count == 0) {
            if (completion) {
                completion(@(LoadingViewNoDataType));
                return;
            }
        }
        
        if (completion) {
            completion(indexPaths.copy);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(@(LoadingViewNoNetType));
        }
    }];
}

- (void)requestVirtualDataWithParmaters:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    id dict = [self calculatePageNumber:parmaters];
    if (dict == nil) {
        completion(NoMoreToLoad);
        return;
    }
    
    CategoryVirtualApi *api = [[CategoryVirtualApi alloc] initVirtualApiWithParameter:dict];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        if (![self.lastCategoryID isEqualToString:dict[@"cat_id"]]) {
            [self.goodsArray removeAllObjects];
        }
        
        NSMutableArray *indexPaths = [self queryInsertIndexPaths:request api:NSStringFromClass(api.class)];
        if ([dict[@"page"] isEqualToString:Refresh]) {
            [CategoryDataManager shareManager].isVirtualCategory = YES;
            [[CategoryDataManager shareManager] parseCategoryData:self.model.virtualCategorys];
            NSArray<CategoryNewModel *> *virtualArray = [[CategoryDataManager shareManager] queryRootCategoryData];
            NSArray<CategoryPriceListModel *> *priceLists = self.model.price_list;
            if (self.virtualHandler) {
                self.virtualHandler(virtualArray, priceLists);
            }
        }
        
        if (completion) {
            completion(indexPaths.copy);
        }

    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

- (void)requestRefineDataWithCatID:(NSString *)cat_id completion:(void (^)(id))completion failure:(void (^)(id))failure {
    CategoryNewRefineApi *api = [[CategoryNewRefineApi alloc] initWithCategoryRefineApiCat_id:cat_id];
    
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        CategoryRefineSectionModel *refineModel = [CategoryRefineSectionModel yy_modelWithJSON:requestJSON[@"result"]];
        if (completion) {
            completion(refineModel);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

#pragma mark - Private Methods
- (id)dataAnalysisFromJson:(id)requestJSON request:(SYBaseRequest *)request {
    id result;
    if (!requestJSON) {
        return nil;
    }
    if (request.responseStatusCode == 200) {
        if ([request isKindOfClass:[CategoryListPageApi class]] || [request isKindOfClass:[CategoryVirtualApi class]] ) {
            result = [CategoryListPageModel yy_modelWithJSON:requestJSON[@"result"]];
        }
    }
    return result;
}

- (id)calculatePageNumber:(id)parmaters {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parmaters];
    NSInteger page = 1;
    if ([dict[@"page"] isEqualToString:LoadMore]) {
        if ([self.model.cur_page isEqualToString: self.model.total_page]) {
            return nil;
        }
        page = [self.model.cur_page integerValue] + 1;
        dict[@"page"] = [@(page) stringValue];
    }
    return dict;
}

- (NSMutableArray *)queryInsertIndexPaths:(SYBaseRequest *)request api:(NSString *)api{
    id requestJSON = [NSStringUtils desEncrypt:request api:api];
    self.model = [self dataAnalysisFromJson:requestJSON request:request];
     [self.goodsArray addObjectsFromArray:self.model.goods_list];
    
    // 谷歌统计
    [self analyticsCateWithModel:self.model];
    // 统计
    [ZFAnalytics appsFlyerTrackEvent:@"af_view_list" withValues:@{
                                                                  @"af_content_type" : [NSString stringWithFormat:@"Category/%@", self.cateName]
                                                                  }];
    

    return self.goodsArray;
}

#pragma mark - UICollectionViewDelegateFlowLayout - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    collectionView.mj_footer.hidden = self.model.goods_list.count < 5 ? YES : NO;
    return self.goodsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryListPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CategoryListPageCell setIdentifier] forIndexPath:indexPath];
    
    if (indexPath.row <= self.goodsArray.count - 1) {
        cell.model = self.goodsArray[indexPath.row];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryGoodsModel *model = self.goodsArray[indexPath.row];
    if (self.handler) {
        self.handler(model);
    }
    // 谷歌统计
    NSString *GAProductName = [NSString stringWithFormat:@"Cate - %@",self.cateName];
    [ZFAnalytics clickCategoryProductWithProduct:model position:[self.model.cur_page intValue] actionList:GAProductName];
}

#pragma mark - Getter
-(NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

#pragma mark - 谷歌统计
- (void)analyticsCateWithModel:(CategoryListPageModel *)model {
    NSArray *goodsList = model.goods_list;
    if (goodsList.count == 0) {
        return;
    }
    NSString *event = nil;
    if (![model.cur_page isEqualToString: @"1"]) {
        event = @"LoadMoreProducts";
    }
    NSString *GAName = [NSString stringWithFormat:@"Cate - %@", self.cateName];
    [ZFAnalytics showCategoryProductsWithProducts:goodsList position:(int)self.model.cur_page impressionList:GAName screenName:@"Category" event:event];
}

@end
