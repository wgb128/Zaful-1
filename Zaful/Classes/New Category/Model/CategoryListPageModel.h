//
//  CategoryListPageModel.h
//  ListPageViewController
//
//  Created by TsangFa on 24/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryGoodsModel.h"

/**
 *  原有listPage接口  @"category/get_list"  和  虚拟分类接口  @"category/get_promotion_goods"
 *
 *  共用一个数据模型
 */

@interface CategoryListPageModel : NSObject<YYModel>
/**
 * 商品数据
 */
@property (nonatomic, strong) NSArray          *goods_list;
/**
 * 当前页数
 */
@property (nonatomic, copy) NSString         *cur_page;
/**
 * 总页数
 */
@property (nonatomic, copy) NSString         *total_page;
/**
 * 虚拟分类所有数据
 */
@property (nonatomic, strong) NSArray          *virtualCategorys;
/**
 * deals价格列表
 */
@property (nonatomic, strong) NSArray          *price_list;

@end
