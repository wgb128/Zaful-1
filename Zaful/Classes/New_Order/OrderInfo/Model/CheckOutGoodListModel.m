//
//  CheckOutGoodListModel.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/6.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CheckOutGoodListModel.h"
#import "ZFMultAttributeModel.h"

@implementation CheckOutGoodListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"multi_attr" : [ZFMultAttributeModel class],
             };
}
@end
