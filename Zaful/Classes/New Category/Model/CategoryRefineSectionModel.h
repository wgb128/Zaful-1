//
//  CategoryRefineModel.h
//  ListPageViewController
//
//  Created by TsangFa on 1/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CategoryRefineDetailModel;
@interface CategoryRefineSectionModel : NSObject
@property (nonatomic, strong) NSArray<CategoryRefineDetailModel *>     *refine_list;
@property (nonatomic, copy)   NSString                                 *priceMax;
@property (nonatomic, copy)   NSString                                 *priceMin;

@property (nonatomic, copy) NSString   *selectPriceMin;

@end
