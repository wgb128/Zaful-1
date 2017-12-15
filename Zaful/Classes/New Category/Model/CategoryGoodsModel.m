//
//  ListPageModel.m
//  ListPageViewController
//
//  Created by TsangFa on 21/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryGoodsModel.h"

@implementation CategoryGoodsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
              @"discount"   :@"promote_zhekou",
              @"isExclusive"  :@"is_mobile_price",
              @"goodsName" : @"goods_name",
              @"is_cod" : @"is_cod"
              };
}

@end
