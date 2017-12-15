//
//  ExchangeManager.h
//  Yoshop
//
//  Created by zhaowei on 16/6/1.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeManager : NSObject
/**
 *  货币、汇率、国别信息本地存储
 */
+ (void)saveLocalExchange:(NSArray *)array;
/**
 *  获取货币列表
 */
+ (NSArray *)currencyList;
/**
 *  获取货币对应的汇率
 */
+ (CGFloat)rateOfCurrency:(NSString *)currency;
/**
 *  获取本地选择的货币对应的汇率
 */
+ (CGFloat)localRate;
/**
 *  获取本地货币类型+货币符号
 */
+ (NSString *)localCurrency;

/**
 *  获取本地选择的币种名字, USA ,EUR....
 */
+ (NSString *)localCurrencyName;
/**
 *  获取本地货币类型
 */
+ (NSString *)localTypeCurrency;
/**
 *  存储本地货币类型
 */
+ (void)updateLocalCurrency:(NSString *)currency;
/**
 *  价格汇率转换
 */
+ (NSString *)transforPrice:(NSString *)price;
+ (NSString *)transforPrice:(NSString *)price isRightToLeft:(BOOL)isRightToLeft;
/**
 *  转换成纯价格 如 5.88前面没有币种符号
 *
 *  @param price 价格字符串
 *
 *  @return 转换后的价格
 */
+ (NSString *)transPurePriceforPrice:(NSString *)price;

/**
 *  价格汇率转换
 */
+ (NSString *)transforPrice:(NSString *)price currency:(NSString *)currency;
/**
 *  价格汇率转换--向下取整数
 */
+ (NSString *)transforFloorPrice:(NSString *)price currency:(NSString *)currency;
/**
 *  价格汇率转换--向下取整数差值
 */
+ (NSString *)transforFloorDifferencePrice:(NSString *)price currency:(NSString *)currency;

/**
 *  价格汇率转换--向上取整数
 */
+ (NSString *)transforCeilPrice:(NSString *)price currency:(NSString *)currency;
/**
 *  价格汇率转换--向上取整数差值
 */
+ (NSString *)transforCeilDifferencePrice:(NSString *)price currency:(NSString *)currency;

/**
 *  转换成纯价格 如 5.88前面没有币种符号
 *
 *  @param price 价格字符串
 *
 *  @return 转换后的价格
 */
+ (NSString *)transPurePriceforPrice:(NSString *)price currency:(NSString *)currency;

+ (NSString *)symbolOfCurrency:(NSString *)currency;

@end
