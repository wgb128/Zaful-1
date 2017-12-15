
//
//  ZFCartListModel.m
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartListModel.h"
#import "ZFCartListResultModel.h"

@implementation ZFCartListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"result" : [ZFCartListResultModel class],
             };
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"statusCode" : @"statusCode",
             @"msg" : @"msg",
             @"result" : @"result",
             };
}
@end
