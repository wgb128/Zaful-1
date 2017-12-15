//
//  CategoryListPageModel.m
//  ListPageViewController
//
//  Created by TsangFa on 24/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryListPageModel.h"
#import "CategoryPriceListModel.h"
#import "CategoryNewModel.h"

@implementation CategoryListPageModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"virtualCategorys"   : @"category" };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"goods_list"          : [CategoryGoodsModel class] ,
             @"virtualCategorys"    : [CategoryNewModel class] ,
             @"price_list"          : [CategoryPriceListModel class]
            };
}


@end
