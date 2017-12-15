//
//  GoodsDetailsReviewsImageListModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/6/10.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "GoodsDetailsReviewsImageListModel.h"

@implementation GoodsDetailsReviewsImageListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"smallPic" : @"small_pic",
             @"originPic" : @"origin_pic"
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
             @"smallPic",
             @"originPic"
             ];
}

@end
