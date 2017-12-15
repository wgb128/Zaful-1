//
//  NSStringUtils.m
//  Yoshop
//
//  Created by zhaowei on 16/5/31.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "NSStringUtils.h"
#import "DesEncrypt.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSStringUtils

+ (BOOL)isEmptyString:(id)string {
    return string==nil || string==[NSNull null] || ![string isKindOfClass:[NSString class]] || [(NSString *)string length] == 0;
}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

+ (NSString *)isEmptyString:(id)string withReplaceString:(NSString *)replaceString {
    if ([self isEmptyString:string]) {
        return [self isEmptyString:replaceString] ? @"" : replaceString;
    } else {
        return string;
    }
}

+ (BOOL)isValidEmailString:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isIncludeSpecialCharacterString:(NSString *)string {
    
    NSRange validRange = [string rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (validRange.location == NSNotFound) {
        return NO;
    }
    return YES;
}

+ (BOOL)isAllNumberCharacterString:(NSString *)string {
    
    NSString *stringRegex = @"^[0-9]*$";
    NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:string];
}

+ (BOOL)isAllLetterCharacterString:(NSString *)string {
    
    NSString *stringRegex = @"^[A-Za-z]+$";
    NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:string];
}

+ (BOOL)isAllNumberAndLetterCharacterString:(NSString *)string {
    
    NSString *stringRegex = @"^[A-Za-z0-9]+$";
    NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:string];
}

+ (NSString *)breakUpTheString:(NSString *)string point:(NSInteger)point {
    NSString *realyString = string;
    NSRange range = [string rangeOfString:@"."];
    if (range.location != NSNotFound) {
        if (point < (string.length - range.location - 1)) {
            realyString = [string substringToIndex:range.location + point + 1];
        };
    }
    return realyString;
}

+ (NSString *)emptyStringReplaceNSNull:(id)string {
    if ([self isEmptyString:string]) {
        return @"";
    }else{
        return string;
    }
}

+ (NSString *)uniqueUUID {
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *str = [[uuid UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return str;
}

/**
 *  获取当前时间的时间戳（例子：1464326536）
 *
 *  @return 时间戳字符串型
 */
+ (NSString *)getCurrentTimestamp {
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    // 转为字符型
    return timeString;
}

+ (NSString *)buildRequestPath:(NSString *)path {
    
    return [NSString stringWithFormat:@"%@?isenc=%@",path,ISENC];
}

+ (NSString *)buildCommparam {
    return [NSString stringWithFormat:@"ver=%@&pf=ios",ZFSYSTEM_VERSION];
}

+ (NSString *)encryptWithDict:(NSDictionary *)dict {
    
    NSString *jsonStr =  [dict yy_modelToJSONString];//
    
    const char *eChar = [DesEncrypt sharedDesEncrypt]->encryptText([jsonStr UTF8String],[kDesEncrypt_key UTF8String],[kDesEncrypt_iv UTF8String]);
    return [NSString stringWithCString:eChar encoding:NSUTF8StringEncoding];
}

+ (NSString *)encryptWithStr:(NSString *)string {
    const char *eChar = [DesEncrypt sharedDesEncrypt]->encryptText([string UTF8String],[kDesEncrypt_key UTF8String],[kDesEncrypt_iv UTF8String]);
    return [NSString stringWithCString:eChar encoding:NSUTF8StringEncoding];
}

+ (id)desEncrypt:(SYBaseRequest *)request api:(NSString *)api {

    if (![ISENC boolValue] || !request.encryption) {
        
        ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@ \n ", api, request.responseJSONObject);
        return request.responseJSONObject;
    }
    
    const char *dChar = [DesEncrypt sharedDesEncrypt]->decryptText([request.responseString UTF8String],[kDesEncrypt_key UTF8String],[kDesEncrypt_iv UTF8String]);
    NSString *result = [NSString stringWithUTF8String:dChar];
    
    NSError *error;
    NSData *objectData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&error];

    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", api, json);
    
    return (!json ? nil : json);

}

+ (id)desEncrypt:(SYBaseRequest *)request {
    if (![ISENC boolValue] && !request.encryption) return request.responseJSONObject;
        
    const char *dChar = [DesEncrypt sharedDesEncrypt]->decryptText([request.responseString UTF8String],[kDesEncrypt_key UTF8String],[kDesEncrypt_iv UTF8String]);
    NSString *result = [NSString stringWithUTF8String:dChar];
    
    NSError *error;
    NSData *objectData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", request.requestURLString, json);
    
    return (!json ? nil : json);
}

+ (id)desEncryptWithString:(NSString *)str {
    if (![ISENC boolValue]) return str;
    
    const char *dChar = [DesEncrypt sharedDesEncrypt]->decryptText([str UTF8String],[kDesEncrypt_key UTF8String],[kDesEncrypt_iv UTF8String]);
    NSString *result = [NSString stringWithUTF8String:dChar];
    
    NSError *error;
    NSData *objectData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&error];
    return (!json ? nil : json);
}

+ (NSString*)timeLapse:(NSInteger)time {
    NSInteger curTime = [[NSDate date] timeIntervalSince1970];
    NSInteger distance = curTime - time;
    
    NSInteger value       = 0;
    NSString *tag   = (distance<0) ? [NSString stringWithFormat:@" %@",ZFLocalizedString(@"TimeLapse_Later",nil)] : [NSString stringWithFormat:@" %@",ZFLocalizedString(@"TimeLapse_Ago",nil)] ;
    NSString *unit  = @"";
    
    distance = labs(distance);
    
    if(distance < sec_per_min)
    {
        value = (NSInteger)distance;
        unit = value >1 ? ZFLocalizedString(@"TimeLapse_Secs",nil) : ZFLocalizedString(@"TimeLapse_Sec",nil);
    }else if(distance < sec_per_hour)
    {
        value = (NSInteger)distance/sec_per_min;
        unit = value>1 ? ZFLocalizedString(@"TimeLapse_Mins",nil) : ZFLocalizedString(@"TimeLapse_Min",nil);
    }else if (distance < sec_per_day)
    {
        value = (NSInteger)distance/sec_per_hour;
        unit = value>1 ? ZFLocalizedString(@"TimeLapse_Hours",nil) : ZFLocalizedString(@"TimeLapse_Hour",nil);
    }else if (distance < sec_per_month){
        value = (NSInteger)distance/sec_per_day;
        unit = value>1 ? ZFLocalizedString(@"TimeLapse_Days",nil) : ZFLocalizedString(@"TimeLapse_Day",nil);
    }else if (distance < sec_per_year){
        value = (NSInteger)distance/sec_per_month;
        unit = value>1 ? ZFLocalizedString(@"TimeLapse_Months",nil) : ZFLocalizedString(@"TimeLapse_Month",nil);
    }else{
        value = (NSInteger)distance/sec_per_year;
        unit = value>1 ? ZFLocalizedString(@"TimeLapse_Years",nil) : ZFLocalizedString(@"TimeLapse_Year",nil);
    }
    
    NSString *strTime = [[[[@(value) stringValue] stringByAppendingString:@" "] stringByAppendingString:unit] stringByAppendingString:tag];
    
    return strTime;
}

+ (NSString *)getMediaSource {
    // 当前时间截
    NSString *currTimeStr = [self getCurrentTimestamp];
    NSInteger currTime = [currTimeStr integerValue];
    NSInteger installTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"kAPPInstallTime"];
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    NSString *str = [us objectForKey:MEDIA_SOURCE];
    if ([self isEmptyString:str] || currTime - installTime > sec_per_month) str = @"";
    return str;
}

+ (NSString *)getCampaign {
    // 当前时间截
    NSString *currTimeStr = [self getCurrentTimestamp];
    NSInteger currTime = [currTimeStr integerValue];
    NSInteger installTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"kAPPInstallTime"];
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    NSString *str = [us objectForKey:CAMPAIGN];
    if ([self isEmptyString:str] || currTime - installTime > sec_per_month) str = @"";
    return str;
}

+ (NSString *)getLkid {
    // 当前时间截
    NSString *currTimeStr = [self getCurrentTimestamp];
    NSInteger currTime = [currTimeStr integerValue];
    NSInteger installTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"kAPPInstallTime"];
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    NSString *str = [us objectForKey:LKID];
    if ([self isEmptyString:str] || currTime - installTime > sec_per_month) str = @"";
    return str;
}

+ (NSString *)getAdId {
    // 当前时间截
    NSString *currTimeStr = [self getCurrentTimestamp];
    NSInteger currTime = [currTimeStr integerValue];
    NSInteger installTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"kAPPInstallTime"];
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    NSString *str = [us objectForKey:ADID];
    if ([self isEmptyString:str] || currTime - installTime > sec_per_month) str = @"";
    return str;
}

// ＝＝＝＝＝＝＝＝＝＝＝＝推送催付参数＝＝＝＝＝＝＝＝＝＝＝＝
+ (NSString *)getPid {
    // 当前时间截
    NSString *currTimeStr = [NSStringUtils getCurrentTimestamp];
    NSInteger currTime = [currTimeStr integerValue];
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    NSInteger saveTime = [us integerForKey:SAVE_NOTIFICATIONS_PARMATERS_TIME];
    NSDictionary *notificationsParmaters = [us objectForKey:NOTIFICATIONS_PAYMENT_PARMATERS];
    NSString *str = notificationsParmaters[@"pid"];
    if ([NSStringUtils isEmptyString:str] || currTime - saveTime > sec_per_day*3) str = @"";
    return str;
}

+ (NSString *)getC {
    // 当前时间截
    NSString *currTimeStr = [NSStringUtils getCurrentTimestamp];
    NSInteger currTime = [currTimeStr integerValue];
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    NSInteger saveTime = [us integerForKey:SAVE_NOTIFICATIONS_PARMATERS_TIME];
    NSDictionary *notificationsParmaters = [us objectForKey:NOTIFICATIONS_PAYMENT_PARMATERS];
    NSString *str = notificationsParmaters[@"c"];
    if ([NSStringUtils isEmptyString:str] || currTime - saveTime > sec_per_day*3) str = @"";
    return str;
}

+ (NSString *)getIsRetargeting {
    // 当前时间截
    NSString *currTimeStr = [NSStringUtils getCurrentTimestamp];
    NSInteger currTime = [currTimeStr integerValue];
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    NSInteger saveTime = [us integerForKey:SAVE_NOTIFICATIONS_PARMATERS_TIME];
    NSDictionary *notificationsParmaters = [us objectForKey:NOTIFICATIONS_PAYMENT_PARMATERS];
    NSString *str = notificationsParmaters[@"is_retargeting"];
    if ([NSStringUtils isEmptyString:str] || currTime - saveTime > sec_per_day*3) str = @"";
    return str;
}
// ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

+ (NSString *)ZFNSStringMD5:(NSString *)string {
    if (!string) return nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],  result[1],  result[2],  result[3],
            result[4],  result[5],  result[6],  result[7],
            result[8],  result[9],  result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
