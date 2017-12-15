//
//  MASView+LayoutReplace.m
//  Zaful
//
//  Created by zhaowei on 2017/2/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "MASView+LayoutReplace.h"
#import <objc/runtime.h>

@implementation MAS_VIEW(LayoutReplace)
+ (void)load {
    if (!ISIOS9) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class class = [self class];
            Method mas_leadingMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_leading"));
            Method mas_leftMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_left"));
            method_exchangeImplementations(mas_leadingMethod, mas_leftMethod);
            
            Method mas_trailingMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_trailing"));
            Method mas_rightMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_right"));
            method_exchangeImplementations(mas_trailingMethod, mas_rightMethod);
            
            Method mas_leadingMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_leadingMargin"));
            Method mas_leftMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_leftMargin"));
            method_exchangeImplementations(mas_leadingMarginMethod, mas_leftMarginMethod);
            
            Method mas_trailingMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_trailingMargin"));
            Method mas_rightMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_rightMargin"));
            method_exchangeImplementations(mas_trailingMarginMethod, mas_rightMarginMethod);
        });
    }
    
//    [MAS_VIEW changeByLanguege];
}

+ (void)changeByLanguege {
    // 系统语言判断
    NSString *languegeCode = [[NSLocale currentLocale] languageCode];
    if (![languegeCode isEqualToString:@"ar"]) {
        return;
    }
    
    Class class = [self class];
    
    Method mas_leadingMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_leading"));
    Method mas_leftMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_left"));
    
    Method mas_trailingMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_trailing"));
    Method mas_rightMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_right"));
    
    Method mas_leadingMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_leadingMargin"));
    Method mas_leftMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_leftMargin"));
    
    Method mas_trailingMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_trailingMargin"));
    Method mas_rightMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"mas_rightMargin"));
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        method_exchangeImplementations(mas_leadingMethod, mas_trailingMethod);
        method_exchangeImplementations(mas_leftMethod, mas_trailingMethod);
        method_exchangeImplementations(mas_trailingMethod, mas_leadingMethod);
        method_exchangeImplementations(mas_rightMethod, mas_leadingMethod);
        
        method_exchangeImplementations(mas_leadingMarginMethod, mas_trailingMarginMethod);
        method_exchangeImplementations(mas_leftMarginMethod, mas_trailingMarginMethod);
        method_exchangeImplementations(mas_trailingMarginMethod, mas_leadingMarginMethod);
        method_exchangeImplementations(mas_rightMarginMethod, mas_leadingMarginMethod);
    } else {
        IMP mas_leadingIMP = method_getImplementation(mas_leadingMethod);
        method_setImplementation(mas_leadingMethod, mas_leadingIMP);
        
        IMP mas_leftIMP = method_getImplementation(mas_leftMethod);
        method_setImplementation(mas_leftMethod, mas_leftIMP);
        
        IMP mas_trailingIMP = method_getImplementation(mas_trailingMethod);
        method_setImplementation(mas_trailingMethod, mas_trailingIMP);
        
        IMP mas_rightIMP = method_getImplementation(mas_rightMethod);
        method_setImplementation(mas_rightMethod, mas_rightIMP);
        
        IMP mas_leadingMarginIMP = method_getImplementation(mas_leadingMarginMethod);
        method_setImplementation(mas_leadingMarginMethod, mas_leadingMarginIMP);
        
        IMP mas_leftMarginIMP = method_getImplementation(mas_leftMarginMethod);
        method_setImplementation(mas_leftMarginMethod, mas_leftMarginIMP);
        
        IMP mas_trailingMarginIMP = method_getImplementation(mas_trailingMarginMethod);
        method_setImplementation(mas_trailingMarginMethod, mas_trailingMarginIMP);
        
        IMP mas_rightMarginIMP = method_getImplementation(mas_rightMarginMethod);
        method_setImplementation(mas_rightMarginMethod, mas_rightMarginIMP);
    }
}

@end
