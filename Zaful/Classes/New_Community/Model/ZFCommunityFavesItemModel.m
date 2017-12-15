
//
//  ZFCommunityFavesItemModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityFavesItemModel.h"


@implementation ZFCommunityFavesItemModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"reviewPic" : [PictureModel class],
             };
}

@end
