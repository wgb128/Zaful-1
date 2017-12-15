

//
//  ZFAddressStateModel.m
//  Zaful
//
//  Created by Apple on 2017/9/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressStateModel.h"

@implementation ZFAddressStateModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"provinceName"     :@"name",
             @"provinceId"       :@"id",
             @"is_city"          :@"is_city"
             };
}
@end
