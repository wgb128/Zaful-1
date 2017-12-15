//
//  ZFCommunityOutfitsListModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityOutfitsListModel.h"
#import "ZFCommunityOutfitsModel.h"
@implementation ZFCommunityOutfitsListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"outfitsList" : @"list",
             @"total" : @"total"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"outfitsList" : [ZFCommunityOutfitsModel class],
             };
}

@end
