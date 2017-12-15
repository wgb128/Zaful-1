//
//  GoodsDetailFirstReviewImgListModel.m
//  Zaful
//
//  Created by TsangFa on 17/1/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "GoodsDetailFirstReviewImgListModel.h"

@implementation GoodsDetailFirstReviewImgListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"wp_image"    :   @"wp_image",
             @"smallPic"    :   @"small_pic",
             @"originPic"   :   @"origin_pic",
             @"bigPic"      :   @"big_pic"
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
             @"wp_image",
             @"smallPic",
             @"originPic",
             @"bigPic"
             ];
}

@end
