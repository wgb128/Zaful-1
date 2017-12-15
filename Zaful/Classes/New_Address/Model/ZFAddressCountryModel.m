


//
//  ZFAddressCountryModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressCountryModel.h"

@implementation ZFAddressCountryModel
// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"region_code",
             @"region_id",
             @"region_name",
             @"code",
             @"supplier_number_list",
             @"number",
             @"is_state",
             @"configured_number",
             @"is_cod"
             ];
}

@end
