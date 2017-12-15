//
//  SystemConfigUtils.m
//  Zaful
//
//  Created by zhaowei on 2017/2/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SystemConfigUtils.h"

@implementation SystemConfigUtils

+ (BOOL)isRightToLeftLanguage {
    if ([[ZFLocalizationString shareLocalizable].nomarLocalizable hasPrefix:@"ar"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isCanRightToLeftShow {
    if (ISIOS9 && [self isRightToLeftLanguage]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isRightToLeftShow {
    if ([self isCanRightToLeftShow]
        && [UIView appearance].semanticContentAttribute == UISemanticContentAttributeForceRightToLeft) {
        return YES;
    }
    return NO;
}
@end
