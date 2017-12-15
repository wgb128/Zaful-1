//
//  ZFLocalizationString.h
//  Zaful
//
//  Created by zhaowei on 2017/2/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef ZFLocalizedString
#define ZFLocalizedString(key,comment) [[ZFLocalizationString shareLocalizable] ZFLocalizedString:key]

FOUNDATION_EXTERN NSString *const ZFLocalizationStringDidChanged;   // 语言切换的通知
// 管理国际化的类
@interface ZFLocalizationString : NSObject
@property (nonatomic, strong, readonly) NSArray  *localizableNames;  // 获取工程支持的多语言的数组
@property (nonatomic, strong, readonly) NSArray *languageArray;     // 支持的语言列表集合
@property (nonatomic, copy) NSString *nomarLocalizable;             // 默认的语言 默认为英语
@property (nonatomic, assign) BOOL isSuppoutAppSettingLocalizable;  // 是否支持APP内部进行切换语言 默认不支持 强行设置nomarLocalizable 属性会退出程序
+ (instancetype)shareLocalizable; //对类初始化单例
- (NSString *)ZFLocalizedString:(NSString *)translation_key; // 用ZFLocalizedString宏进行调用国际化
- (NSString *)currentLanguageName;  // 当前 APP 使用的语言，默认为英语
@end
