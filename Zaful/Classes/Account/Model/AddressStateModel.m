//
//  AddressStateModel.m
//  Zaful
//
//  Created by zhaowei on 2017/4/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "AddressStateModel.h"

@implementation AddressStateModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"provinceName"     :@"name",
             @"provinceId"       :@"id",
             @"is_city"          :@"is_city"
             };
}
@end
