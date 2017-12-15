//
//  CommunityHomeReviewsPicModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "PictureModel.h"

@implementation PictureModel

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"originPic",
             @"bigPic",
             @"smallPic",
             @"bigPicWidth",
             @"bigPicHeight"
             ];
}

@end
