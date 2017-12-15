//
//  CategoryRefineCellModel.h
//  ListPageViewController
//
//  Created by TsangFa on 1/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryRefineCellModel : NSObject

/**
 * 属性id
 */
@property (nonatomic, copy) NSString   *attrID;

/**
 * 属性名
 */
@property (nonatomic, copy) NSString   *name;

/**
 * 标记已选的属性
 */
@property (nonatomic, assign) BOOL   isSelect;

@end
