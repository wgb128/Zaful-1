//
//  ZFAddressInfoModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ZFAddressInfoModel : NSObject <NSMutableCopying>

@property (nonatomic, copy) NSString *address_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *firstname;
@property (nonatomic, copy) NSString *lastname;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *code;//区号
@property (nonatomic, copy) NSString *country_id;
@property (nonatomic, copy) NSString *country_str;
@property (nonatomic, copy) NSString *province_id;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *id_card;
@property (nonatomic, copy) NSString *zipcode;
@property (nonatomic, copy) NSString *addressline1;
@property (nonatomic, copy) NSString *addressline2;
@property (nonatomic, copy) NSString *landmark;
@property (nonatomic, copy) NSString *telspare;
@property (nonatomic, copy) NSString *whatsapp;
@property (nonatomic, copy) NSString *supplier_number_spare;
@property (nonatomic, assign) BOOL    is_cod;
//运营商号列表
@property (nonatomic, copy) NSString *supplier_number_list;
//当前运营商号
@property (nonatomic, copy) NSString *supplier_number;
//手机号码最大位数
@property (nonatomic, copy) NSString *number;
@property (nonatomic, assign) BOOL is_default;    //是否是默认邮寄地址 [0-否，1-是]
@property (nonatomic, assign) BOOL ownState;
@property (nonatomic, assign) BOOL ownCity;
@property (nonatomic, assign) BOOL configured_number; //1 是后台设置的 判断就直接 =  0未设置的就是 <=

@end
