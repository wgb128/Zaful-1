//
//  CategoryParentViewModel.m
//  ListPageViewController
//
//  Created by TsangFa on 26/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryParentViewModel.h"
#import "CategoryDataApi.h"

@interface CategoryParentViewModel ()
@property (nonatomic, strong) NSMutableArray   *parentsArray;
@end

@implementation CategoryParentViewModel
#pragma mark - Public Methods
-(void)requestParentsDataCompletion:(void (^)())completion failure:(void (^)(id))failure{
    
    CategoryDataApi *api = [[CategoryDataApi alloc] initCategoryDataApi];
    
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        NSArray<CategoryNewModel *> *categorysArray = [self dataAnalysisFromJson:requestJSON request:request];
        [self parseRequestJSON:categorysArray];
        // 统计
        [self analyticsCateBannerWithCateArray:categorysArray name:@"Cate"];
        
        if (completion) {
            completion();
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

#pragma mark - Private Methods
- (void)parseRequestJSON:(NSArray<CategoryNewModel *> *)categorysArray {
    [CategoryDataManager shareManager].isVirtualCategory = NO;
    [[CategoryDataManager shareManager] parseCategoryData:categorysArray];
    NSArray *array = [[CategoryDataManager shareManager] queryRootCategoryData];
    [self.parentsArray removeAllObjects];
    
    for (CategoryNewModel *model in array) {
        if (![NSStringUtils isEmptyString:model.cat_pic]) {
            [self.parentsArray addObject:model];
        }
    }
}


- (id)dataAnalysisFromJson:(id)requestJSON request:(SYBaseRequest *)request {
    id result;
    if (![request isKindOfClass:[CategoryDataApi class]]) {
        result = nil;
    }
    if (request.responseStatusCode == 200) {
        result = [NSArray  yy_modelArrayWithClass:[CategoryNewModel class] json:requestJSON[@"result"]];
    }
    
    return result;
}

#pragma mark - UICollectionViewDelegateFlowLayout - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.parentsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryParentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CategoryParentCell setIdentifier] forIndexPath:indexPath];
    cell.model = self.parentsArray[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryNewModel *model = self.parentsArray[indexPath.row];
    if (self.handler) {
        self.handler(model);
    }
    
    // 谷歌统计
    [ZFAnalytics clickButtonWithCategory:@"Category" actionName:@"Cate - Level1" label:[NSString stringWithFormat:@"Cate - %@", model.cat_name]];
    NSString *GABannerId = model.cat_id;
    NSString *GABannerName = [NSString stringWithFormat:@"Cate - %@",model.cat_name];
    NSString *position = [NSString stringWithFormat:@"Cate - P%ld",(long)(indexPath.row + 1)];
    [ZFAnalytics clickAdvertisementWithId:GABannerId name:GABannerName position:position];
}

#pragma mark - Getter
-(NSMutableArray *)parentsArray {
    if (!_parentsArray) {
        _parentsArray = [NSMutableArray array];
    }
    return _parentsArray;
}

#pragma mark - 谷歌统计
-(void)analyticsCateBannerWithCateArray:(NSArray<CategoryNewModel *> *)cateArray name:(NSString *)name{
    NSMutableArray *screenNames = [NSMutableArray array];
    for (int i = 0; i < cateArray.count; i++) {
        CategoryNewModel * model = cateArray[i];
        NSString *screenName = [NSString stringWithFormat:@"%@ - %@",name,model.cat_name];
        NSString *position = [NSString stringWithFormat:@"%@ - P%d",name, i+1];
        [screenNames addObject:@{@"name":screenName,@"position":position}];
    }
    [ZFAnalytics showAdvertisementWithBanners:screenNames position:nil screenName:@"Category"];
}

@end
