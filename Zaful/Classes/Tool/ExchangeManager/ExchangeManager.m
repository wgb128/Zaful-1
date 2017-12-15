//
//  ExchangeManager.m
//  Yoshop
//
//  Created by zhaowei on 16/6/1.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "ExchangeManager.h"
#import "RateModel.h"

@implementation ExchangeManager
+ (void)saveLocalExchange:(NSArray *)array {
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:array forKey:kExchangeKey];

    [archiver finishEncoding];
    
    [data writeToFile:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kRateName] atomically:YES];
}

+ (NSArray *)currencyList {
    NSData *data = [[NSData alloc] initWithContentsOfFile:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kRateName]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray *array = [unarchiver decodeObjectForKey:kExchangeKey];
    [unarchiver finishDecoding];//一定不要忘记finishDecoding，否则会报错
    return array;
}

+ (CGFloat)rateOfCurrency:(NSString *)currency {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code == %@", currency];
    NSArray *filteredArray = [[self currencyList] filteredArrayUsingPredicate:predicate];
    if(filteredArray.count == 0) {
        predicate = [NSPredicate predicateWithFormat:@"symbol == %@", currency];
        filteredArray = [[self currencyList] filteredArrayUsingPredicate:predicate];
    }
    RateModel *model = filteredArray[0];
    
    return [model.rate floatValue];
}

+ (CGFloat)localRate {
    NSArray *array = [[self localCurrency] componentsSeparatedByString:@" "];
    NSString *country = [array lastObject];
    
    return [self rateOfCurrency:country];
}

+ (NSString *)localCurrency {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *currencyValue = [user objectForKey:kNowCurrencyKey];
    
    if ([NSStringUtils isEmptyString:currencyValue]) {
        NSString *languageCode = [ZFLocalizationString shareLocalizable].nomarLocalizable;
        //启动APP当系统语言为法语和西语的时候，APP商品的显示价格默认为欧元（ISO+Android）
        if ([languageCode hasPrefix:@"es"] || [languageCode hasPrefix:@"fr"]) {
            currencyValue = @"€ EUR";
        } else {
            currencyValue = @"$ USD";
        }
    }
    return currencyValue;
}

+ (NSString *)localCurrencyName
{
      return [[self localCurrency] componentsSeparatedByString:@" "].lastObject;
}

+ (NSString *)localTypeCurrency {
    return [[self localCurrency] componentsSeparatedByString:@" "].firstObject;
}

+ (void)updateLocalCurrency:(NSString *)currency {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:currency forKey:kNowCurrencyKey];
    [user synchronize];
}

+ (NSString *)transforPrice:(NSString *)price {
    
    NSString *currency = [[self localCurrency] componentsSeparatedByString:@" "].firstObject;
    
    CGFloat transfor = [price floatValue] * [self localRate];
    NSMutableString *str = [NSMutableString string];
    
    if ([currency isEqualToString:@"€"]) {
        [str appendFormat:@"%.2f %@",transfor,currency];
        NSRange range = [str rangeOfString:@"."];
        [str replaceCharactersInRange:range withString:@","];
    } else {
        [str appendString:currency];
        [str appendFormat:@"%.2f",transfor];
    }
    
    return str;
}

+ (NSString *)transforPrice:(NSString *)price isRightToLeft:(BOOL)isRightToLeft {
    if (!isRightToLeft) {
        return [self transforPrice:price];
    }
    NSString *currency = [[self localCurrency] componentsSeparatedByString:@" "].firstObject;
    
    CGFloat transfor = [price floatValue] * [self localRate];
    NSMutableString *str = [NSMutableString string];
    
    if ([currency isEqualToString:@"€"]) {
        [str appendFormat:@"%@ %.2f",currency, transfor];
        NSRange range = [str rangeOfString:@"."];
        [str replaceCharactersInRange:range withString:@","];
    } else {
        [str appendFormat:@"%.2f",transfor];
        [str appendString:currency];
    }
    
    return str;
}

+ (NSString *)transPurePriceforPrice:(NSString *)price {
    CGFloat transfor = [price floatValue] * [self localRate];
    return [NSString stringWithFormat:@"%.2f",transfor];
}

+ (NSString *)transforPrice:(NSString *)price currency:(NSString *)currency {
    CGFloat transfor = [price floatValue] * [self rateOfCurrency:currency];
    NSMutableString *str = [NSMutableString string];
    [str appendString:[self symbolOfCurrency:currency]];
    [str appendFormat:@"%.2f",transfor];
    return str;
}

+ (NSString *)transPurePriceforPrice:(NSString *)price currency:(NSString *)currency {
    CGFloat transfor = [price floatValue] * [self rateOfCurrency:currency];
    return [NSString stringWithFormat:@"%.2f",transfor];
}

+ (NSString *)symbolOfCurrency:(NSString *)currency {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code == %@", currency];
    NSArray *filteredArray = [[self currencyList] filteredArrayUsingPredicate:predicate];
    if(filteredArray.count == 0) {
        predicate = [NSPredicate predicateWithFormat:@"symbol == %@", currency];
        filteredArray = [[self currencyList] filteredArrayUsingPredicate:predicate];
    }
    RateModel *model = filteredArray[0];
    return model.symbol;
}

//向下取整  3.45 = 3  减号
+ (NSString *)transforFloorPrice:(NSString *)price currency:(NSString *)currency {
    NSInteger transfor = floor([price floatValue] * [self rateOfCurrency:currency]);
    NSMutableString *str = [NSMutableString string];
    [str appendString:[self symbolOfCurrency:currency]];
    [str appendFormat:@"%ld",(long)transfor];
    return str;
}
//向下取整差值 3.45  = 0.45
+ (NSString *)transforFloorDifferencePrice:(NSString *)price currency:(NSString *)currency {
    CGFloat transfor = [price floatValue] * [self rateOfCurrency:currency];
    CGFloat difference = transfor - floor(transfor);
    NSMutableString *str = [NSMutableString string];
    [str appendString:[self symbolOfCurrency:currency]];
    [str appendFormat:@"%.2f",difference];
    return str;
}

//向上取整   3.45 = 4
+ (NSString *)transforCeilPrice:(NSString *)price currency:(NSString *)currency {
    NSInteger transfor = ceil([price floatValue] * [self rateOfCurrency:currency]);
    NSMutableString *str = [NSMutableString string];
    [str appendString:[self symbolOfCurrency:currency]];
    [str appendFormat:@"%ld",(long)transfor];
    return str;
}
//向上取整差值
+ (NSString *)transforCeilDifferencePrice:(NSString *)price currency:(NSString *)currency {
    CGFloat transfor = [price floatValue] * [self rateOfCurrency:currency];
    CGFloat difference = ceil(transfor) - transfor;
    NSMutableString *str = [NSMutableString string];
    [str appendString:[self symbolOfCurrency:currency]];
    [str appendFormat:@"%.2f",difference];
    return str;
}

@end
