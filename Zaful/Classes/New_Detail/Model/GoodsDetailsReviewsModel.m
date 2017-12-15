//
//  GoodsDetailsReviewsModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/6/10.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "GoodsDetailsReviewsModel.h"
#import "GoodsDetailsReviewsListModel.h"

@implementation GoodsDetailsReviewsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"agvRate" : @"avg_rate_all",
             @"reviewList" : @"data"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"reviewList" : [GoodsDetailsReviewsListModel class]
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
             @"reviewList",
             @"agvRate",
             @"pageCount",
             @"reviewCount",
             @"page"
             ];
}

@end
