
//
//  ZFCommunitySearchResultListModel.m
//  Zaful
//
//  Created by liuxi on 2017/7/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunitySearchResultListModel.h"
#import "ZFCommunitySearchResultModel.h"

@implementation ZFCommunitySearchResultListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"searchList" : [ZFCommunitySearchResultModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"searchList"       : @"list",
             @"pageCount"        : @"pageCount",
             @"curPage"          : @"curPage"
             };
}

@end
