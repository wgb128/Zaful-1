//
//  CountryManager.h
//  Yoshop
//
//  Created by zhaowei on 16/6/2.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryManager : NSObject
/**
 *  国家信息本地存储
 */
+ (void)saveLocalCountry:(NSArray *)array;
/**
 *  获取国家列表
 */
+ (NSArray *)countryList;
@end
