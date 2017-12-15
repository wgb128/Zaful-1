//
//  CategoryNewModel.h
//  ListPageViewController
//
//  Created by TsangFa on 26/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryNewModel : NSObject<YYModel>
/**
 * 分类ID
 */
@property (nonatomic, copy) NSString   *cat_id;

/**
 * 父类ID
 */
@property (nonatomic, copy) NSString   *parent_id;

/**
 * 分类名
 */
@property (nonatomic, copy) NSString   *cat_name;

/**
 * 图片URL
 */
@property (nonatomic, copy) NSString   *cat_pic;

/**
 * 默认排序方式
 */
@property (nonatomic, copy) NSString   *default_sort;

/**
 * 是否有下一级
 */
@property (nonatomic, copy) NSString   *is_child;

/**
 * 是否展开
 */
@property (nonatomic, assign) BOOL   isOpen;

/**
 * 是否选择
 */
@property (nonatomic, assign) BOOL   isSelect;

@end
