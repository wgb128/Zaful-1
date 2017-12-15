//
//  FilterManager.h
//  Zaful
//
//  Created by zhaowei on 2017/3/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterManager : NSObject

+ (void)saveLocalFilter:(NSDictionary *)dict;
//是否支持COD付款方式
+ (NSString *)isSupportCOD:(NSString *)addressId;
//该地区的COD是否支持向下取整
+ (CashOnDeliveryTruncType)cashOnDeliveryTruncType:(NSString *)addressId;

+ (BOOL)requireCardNumWithAddressId:(NSString *)addressId;

+ (void)saveTempFilter:(NSString *)currency;

+ (NSString *)tempCurrency;

+ (void)removeCurrency;

+ (void)saveTempCOD:(BOOL)isCOD;

+ (BOOL)tempCOD:(BOOL)isCod;

+ (void)removeCOD;

+ (void)saveIsComb:(BOOL)isComb;

+ (NSString *)adapterCodWithAmount:(NSString *)amount andCod:(BOOL)cod;

+ (NSString *)changeCodCurrencyToFront:(NSString *)price;

@end

