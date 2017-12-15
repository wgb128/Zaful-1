

//
//  ZFCommunitySuggestedUsersListModel.m
//  Zaful
//
//  Created by liuxi on 2017/7/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunitySuggestedUsersListModel.h"
#import "ZFCommunitySuggestedUsersModel.h"
@implementation ZFCommunitySuggestedUsersListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"suggestedList" : [ZFCommunitySuggestedUsersModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"suggestedList"       : @"list",
             @"pageCount"        : @"pageCount",
             @"curPage"          : @"curPage"
             };
}
@end
