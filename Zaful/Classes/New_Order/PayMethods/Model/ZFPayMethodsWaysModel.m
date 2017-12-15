//
//  ZFPayMethodsWaysModel.m
//  Zaful
//
//  Created by liuxi on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPayMethodsWaysModel.h"
#import "ZFPayMethodsChildModel.h"

@implementation ZFPayMethodsWaysModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"child" : [ZFPayMethodsChildModel class],
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"child" : @"child",
             @"node" : @"node",
             };
}
@end
