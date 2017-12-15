//
//  ZFAddressInfoModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressInfoModel.h"

@implementation ZFAddressInfoModel
// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
             @"address_id",
             @"is_default",
             @"user_id",
             @"firstname",
             @"lastname",
             @"id_card",
             @"email",
             @"tel",
             @"country_id",
             @"country_str",
             @"ownState",
             @"province_id",
             @"province",
             @"ownCity",
             @"city",
             @"addressline1",
             @"addressline2",
             @"supplier_number_list",
             @"supplier_number",
             @"number",
             @"zipcode",
             @"code",
             @"configured_number",
             @"landmark",
             @"whatsapp",
             @"telspare",
             @"supplier_number_spare",
             @"is_cod"
             //             @"country_code"
             ];
}

#pragma mark - multible copying
- (id)mutableCopyWithZone:(NSZone *)zone {
    ZFAddressInfoModel *model = [[ZFAddressInfoModel allocWithZone:zone] init];
    model.address_id = self.address_id;
    model.user_id = self.user_id;
    model.firstname = self.firstname;
    model.lastname = self.lastname;
    model.email = self.email != nil ? self.email : [AccountManager sharedManager].account.email;
    model.tel = self.tel;
    model.code = self.code;
    model.country_id = self.country_id;
    model.country_str = self.country_str;
    model.province_id = self.province_id;
    model.province = self.province;
    model.city = self.city;
    model.id_card = self.id_card;
    model.zipcode = self.zipcode;
    model.addressline1 = self.addressline1;
    model.addressline2 = self.addressline2;
    model.supplier_number_list = self.supplier_number_list;
    model.supplier_number = self.supplier_number;
    model.number = self.number;
    model.is_default = self.is_default;
    model.ownState = self.ownState;
    model.ownCity = self.ownCity;
    model.configured_number = self.configured_number;
    model.landmark = self.landmark;
    model.telspare = self.telspare;
    model.whatsapp = self.whatsapp;
    model.supplier_number_spare = self.supplier_number_spare;
    model.is_cod = self.is_cod;
    return model;
}

@end
