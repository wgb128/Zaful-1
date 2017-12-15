//
//  CategoryListPageViewModel.h
//  ListPageViewController
//
//  Created by TsangFa on 16/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CategoryListPageModel.h"
#import "CategoryPriceListModel.h"

typedef void(^ListpageCompletionHandler)(CategoryGoodsModel *model);

typedef void(^virtualCompletionHandler)(NSArray<CategoryNewModel *> *virtual,NSArray<CategoryPriceListModel *> *pricelists);

@interface CategoryListPageViewModel : NSObject<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, copy) ListpageCompletionHandler   handler;

@property (nonatomic, copy) virtualCompletionHandler   virtualHandler;

@property (nonatomic, copy) NSString                  *lastCategoryID;

@property (nonatomic, copy) NSString                  *cateName;

/**
 * 请求当前分类数据
 */
- (void)requestListPageDataWithParmaters:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

/**
 * 请求banner虚拟分类数据
 */
- (void)requestVirtualDataWithParmaters:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

/**
 * 请求Refine数据
 */
- (void)requestRefineDataWithCatID:(NSString *)cat_id completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;


@end
