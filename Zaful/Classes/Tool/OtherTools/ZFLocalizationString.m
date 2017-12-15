//
//  ZFLocalizationString.m
//  Zaful
//
//  Created by zhaowei on 2017/2/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFLocalizationString.h"
#import <objc/runtime.h>

NSString *const ZFLocalizationStringDidChanged = @"ZFLocalizationStringDidChanged";
NSString *const KLocalizableSetting = @"KLocalizableSetting";

@implementation ZFLocalizationString {
}

@synthesize localizableNames = _localizableNames;
@synthesize languageArray    = _languageArray;

+ (instancetype)shareLocalizable {
    static ZFLocalizationString *localizable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localizable = [[ZFLocalizationString alloc]init];
        [localizable getlocalizableNames];
        [localizable settingParment];
    });
    return localizable;
}

- (void)settingParment{
    if ([self isExitLocalLocalizable]) {
        // 以 APP 设置的优先
        _nomarLocalizable = [[NSUserDefaults standardUserDefaults] objectForKey:KLocalizableSetting];
    }
}

- (void)setNomarLocalizable:(NSString *)nomarLocalizable {
    _nomarLocalizable  = nomarLocalizable;
    self.languageArray = nil;
    [[NSUserDefaults standardUserDefaults] setObject:nomarLocalizable forKey:KLocalizableSetting];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if(self.isSuppoutAppSettingLocalizable) {
    } else {
        exit(0);
    }
}

- (NSString *)ZFLocalizedString:(NSString *)translation_key {
    
    NSString * s = NSLocalizedStringFromTable(translation_key, nil, nil);
    
    NSString * path = [[NSBundle mainBundle] pathForResource:self.nomarLocalizable ofType:@"lproj"];
    NSBundle * languageBundle = [NSBundle bundleWithPath:path];
    s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    
    return s;
}

- (void)getlocalizableNames {
    NSArray *array             = [[NSBundle mainBundle]pathsForResourcesOfType:@"lproj" inDirectory:nil];
    NSMutableArray *filltArray = [NSMutableArray array];

    NSString *systemLanguage;
    if ([NSLocale preferredLanguages].count > 0) {
        systemLanguage   = [[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2];
    } else {
        systemLanguage   = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    }
    __block BOOL isExist       = NO;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj = [obj stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/", [NSBundle mainBundle].resourcePath] withString:@""];
        obj = [obj stringByReplacingOccurrencesOfString:@".lproj" withString:@""];
        if ([obj isEqualToString:systemLanguage]) {
            isExist = YES;
        }
        [filltArray addObject:obj];
    }];
    
    if (![self isExitLocalLocalizable]) {
        if (isExist) {
            _nomarLocalizable = systemLanguage;
        } else {
            _nomarLocalizable = @"en";
        }
    }
    _localizableNames = filltArray;
}

- (BOOL)currentLocalizable:(NSString *)locallizable{
    __block BOOL isExit = NO;
    [_localizableNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([locallizable hasPrefix:obj]) {
            isExit = YES;
            *stop = YES;
        }
    }];
    return isExit;
}

- (BOOL)isExitLocalLocalizable {
    return  [[NSUserDefaults standardUserDefaults] objectForKey:KLocalizableSetting] ? YES : NO;
}

- (NSString *)currentLanguageName {
    NSString *languageName = ZFLocalizedString(@"Languge_Setting_English", nil); 
    for (NSInteger i = 0; i < self.languageArray.count; i++) {
        NSString *languegeCode = self.languageArray[i][2];
        if ([languegeCode isEqualToString:self.nomarLocalizable]) {
            languageName = self.languageArray[i][1];
            break;
        }
    }
    return languageName;
}

#pragma mark - getter/setter
- (NSArray *)languageArray {
    if (!_languageArray) {
        _languageArray = @[ @[ZFLocalizedString(@"Languge_Setting_English", nil), @"English", @"en"],
                            @[ZFLocalizedString(@"Languge_Setting_Arabic", nil), @"العربية", @"ar"],
                            @[ZFLocalizedString(@"Languge_Setting_Spanish", nil), @"Español", @"es"],
                            @[ZFLocalizedString(@"Languge_Setting_French", nil), @"Français", @"fr"],
                            ];
    }
    return _languageArray;
}

- (void)setLanguageArray:(NSArray *)languageArray {
    _languageArray = languageArray;
}

@end
