//
//  CategoryRefineDetailModel.h
//  ListPageViewController
//
//  Created by TsangFa on 1/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CategoryRefineCellModel;

@interface CategoryRefineDetailModel : NSObject
/**
 * 属性类名
 */
@property (nonatomic, copy)   NSString                               *name;
/**
 * 所有属性集合
 */
@property (nonatomic, strong) NSArray<CategoryRefineCellModel *>     *childArray;

/**
 * 记录是否展开,默认关闭
 */
@property (nonatomic, assign) BOOL                                   isExpend;

/**
 * 已选属性名称集合
 */
@property (nonatomic, strong) NSMutableArray                         *selectArray;


/**
 * 上传属性集合
 */
@property (nonatomic, strong) NSMutableArray                         *attrsArray;


@end
