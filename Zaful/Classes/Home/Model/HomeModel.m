//
//  HomeModel.m
//  Zaful
//
//  Created by Y001 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HomeModel.h"
#import "BannerModel.h"
#import "GoodsModel.h"

@implementation HomeModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"advArray"        :@"advertising",
             @"categoryArray"   :@"category",
             @"bannerArray"     :@"banner",
             @"goodsArray"      :@"newGoods",
             @"floatArray"      :@"floating"
             };
}

//首页banner对应的品牌数组
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"advArray"         : [BannerModel class],
             @"categoryArray"    : [BannerModel class],
             @"bannerArray"      : [BannerModel class],
             @"goodsArray"       : [GoodsModel class],
             @"floatArray"       : [BannerModel class]
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"advArray",
             @"categoryArray",
             @"bannerArray",
             @"goodsArray",
             @"floatArray"
             ];
}

@end
