//
//  FilterManager.m
//  Zaful
//
//  Created by zhaowei on 2017/3/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "FilterManager.h"

static NSString *codFilter = @"codFilter";
static NSString *addressFilter = @"addressFilter";
static NSString *discountFilter = @"discountFilter";

@interface FilterManager ()
@property (nonatomic, assign) NSInteger   currentPayType;
@end

@implementation FilterManager

// 写数据
+ (void)saveLocalFilter:(NSDictionary *)dict {
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:dict forKey:kFilterKey];
    
    [archiver finishEncoding];
    
    [data writeToFile:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFilterName] atomically:YES];
}

// 读数据
+ (NSDictionary *)filterDict {
    NSData *data = [[NSData alloc] initWithContentsOfFile:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFilterName]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *dict = [unarchiver decodeObjectForKey:kFilterKey];
    [unarchiver finishDecoding];//一定不要忘记finishDecoding，否则会报错
    return dict;
}

/**
 * 根据国家id判断是否支持 COD 付款方式   目前有 172,251,309支持
 * 否则去获取币种
 */
+ (NSString *)isSupportCOD:(NSString *)addressId{
    
    NSDictionary *dict = [self filterDict][codFilter];
    
    if ([[dict allKeys] containsObject:addressId]) {
        return dict[addressId];
    } else {
        return [ExchangeManager localCurrencyName];
    }
    return nil;
}

/**
 * 根据国家id判断是如何取整
 * CashOnDeliveryTruncTypeDefault 0  不显示不取整
 * CashOnDeliveryTruncTypeUp      1
 */
+ (CashOnDeliveryTruncType)cashOnDeliveryTruncType:(NSString *)addressId {
    NSDictionary *dict = [self filterDict][discountFilter];
    
    if ([[dict allKeys] containsObject:addressId]) {
        return [dict[addressId] integerValue];
    } else {
        return CashOnDeliveryTruncTypeDefault;
    }
}

+ (BOOL)requireCardNumWithAddressId:(NSString *)addressId {
    NSArray *array = [self filterDict][addressFilter];
    if ([array containsObject:addressId]) {
        return YES;
    }
    return NO;
}

+ (void)saveTempFilter:(NSString *)currency {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currency forKey:kTempFilterKey];
    [defaults synchronize];
}

+ (NSString *)tempCurrency {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tempCurrency = [defaults objectForKey:kTempFilterKey];
    return tempCurrency;
}

+ (void)removeCurrency {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kTempFilterKey];
    [defaults synchronize];
}

+ (void)saveTempCOD:(BOOL)isCOD {
    if ([FilterManager isComb]) {
        if (isCOD) {
            //ktempCombCod
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setBool:isCOD forKey:kTempCombCod];
            [defaults synchronize];
        } else {
            //ktempCombOnline
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:isCOD forKey:kTempCombOnline];
            [defaults synchronize];
        }
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:isCOD forKey:kTempCODKey];
        [defaults synchronize];
    }
}

+ (BOOL)tempCOD:(BOOL)isCod {
    if ([FilterManager isComb]) {
        if (isCod) {
            //ktempCombCod
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *tempCurrency = [defaults objectForKey:kTempCombCod];
            return [tempCurrency boolValue];
        } else {
            //ktempCombOnline
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *tempCurrency = [defaults objectForKey:kTempCombOnline];
            return [tempCurrency boolValue];
        }
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *tempCurrency = [defaults objectForKey:kTempCODKey];
        return [tempCurrency boolValue];
    }

}

+ (void)removeCOD {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kTempCODKey];
    [defaults removeObjectForKey:kTempCombCod];
    [defaults removeObjectForKey:kTempCombOnline];
    [defaults synchronize];
}

+ (void)saveIsComb:(BOOL)isComb{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isComb forKey:kTempCombKey];
    [defaults synchronize];
}

+ (BOOL)isComb {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isComb = [defaults boolForKey:kTempCombKey];
    return isComb;
}

+ (NSString *)adapterCodWithAmount:(NSString *)amount andCod:(BOOL)cod {
    NSString *result;
    
    if ([FilterManager isComb]) {
        if (cod && ![NSStringUtils isEmptyString:[FilterManager tempCurrency]]) {
            result = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:amount currency:[FilterManager tempCurrency]]];
        } else {
            result = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:amount]];
        }
    } else {
        if ([FilterManager tempCOD:cod] && ![NSStringUtils isEmptyString:[FilterManager tempCurrency]]) {
            result = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:amount currency:[FilterManager tempCurrency]]];
        } else {
            result = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:amount]];
        }
    }

    return result;
}

+ (NSString *)changeCodCurrencyToFront:(NSString *)price {
    NSString *symbol = [ExchangeManager symbolOfCurrency:[FilterManager tempCurrency]];
    NSString *result;
    if ([symbol isEqualToString:@"TL"] || [symbol isEqualToString:@"JD"]) {
        result = [NSString stringWithFormat:@"%@%@",[ExchangeManager symbolOfCurrency:[FilterManager tempCurrency]],price];
    }else{
        result = [NSString stringWithFormat:@"%@%@",price,[ExchangeManager symbolOfCurrency:[FilterManager tempCurrency]]];
    }
    return result;
}

@end

