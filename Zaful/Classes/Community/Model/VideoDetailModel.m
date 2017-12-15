//
//  VideoDetailModel.m
//  Zaful
//
//  Created by huangxieyue on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "VideoDetailModel.h"

@implementation VideoDetailModel

+ (NSArray *)modelPropertyWhitelist
{
    return @[
                 @"videoInfo",
                 @"goodsList"
                 ];
}

@end
