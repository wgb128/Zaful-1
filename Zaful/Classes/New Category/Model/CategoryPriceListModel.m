//
//  CategoryPriceListModel.m
//  ListPageViewController
//
//  Created by TsangFa on 5/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryPriceListModel.h"

@implementation CategoryPriceListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"price_max"     : @"max",
             @"price_min"     : @"min",
             @"price_range"   : @"name"
            };
}
@end
