//
//  MyOrdersModel.m
//  Yoshop
//
//  Created by huangxieyue on 16/6/7.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "MyOrdersModel.h"
#import "MyOrderGoodListModel.h"

@implementation MyOrdersModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"goods" : [MyOrderGoodListModel class]
             };
}



@end
