
//
//  ZFAddressCityModel.m
//  Zaful
//
//  Created by liuxi on 2017/9/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressCityModel.h"

@implementation ZFAddressCityModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"cityName"     :@"name",
             };
}
@end
