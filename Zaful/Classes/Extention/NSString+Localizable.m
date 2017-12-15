//
//  Created by zhaowei.
//  Copyright © 2017年 . All rights reserved.
//  NSString 分类

#import "NSString+Localizable.h"

@implementation NSString (Localizable)
    
- (NSString *)zf_localizedString
{
    return [self zf_localizedStringForKey:self value:nil];
}
    
- (NSString *)zf_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    // 只处理en、ar fr es情况，其他按照系统默认处理
    NSString *language = [ZFLocalizationString shareLocalizable].nomarLocalizable;
    if ([language hasPrefix:@"en"]) {
        language = @"en";
    } else if ([language hasPrefix:@"ar"]) {
        language = @"ar"; // 阿拉伯文
    } else if ([language hasPrefix:@"fr"]) {
        language = @"fr"; // 法语
    } else if ([language hasPrefix:@"es"]) {
        language = @"es"; // 西班牙
    } else {
        language = @"en";
    }
    
    // 查找资源
    bundle = [NSBundle bundleWithPath:[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Zaful" ofType:@"bundle"]] pathForResource:language ofType:@"lproj"]];
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

@end
