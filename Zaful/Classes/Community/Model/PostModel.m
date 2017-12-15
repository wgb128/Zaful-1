//
//  PostModel.m
//  Yoshop
//
//  Created by zhaowei on 16/7/20.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"goodsId" : @"goods_id",
             @"goodsTitle" : @"goods_title",
             @"goodsPrice" : @"goods_price",
             @"goodsThumb" : @"goods_thumb"
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[@"goodsId",@"goodsTitle",@"goodsPrice",@"goodsThumb",@"wid"];
}
@end
