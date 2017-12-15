//
//  MASConstraintMaker+LayoutReplace.m
//  Zaful
//
//  Created by zhaowei on 2017/2/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "MASConstraintMaker+LayoutReplace.h"
#import <objc/runtime.h>

@implementation MASConstraintMaker(LayoutReplace)
+ (void)load {
    
    if (!ISIOS9) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class class = [self class];
            Method leadingMethod = class_getInstanceMethod(class, NSSelectorFromString(@"leading"));
            Method leftMethod = class_getInstanceMethod(class, NSSelectorFromString(@"left"));
            method_exchangeImplementations(leadingMethod, leftMethod);
            
            Method trailingMethod = class_getInstanceMethod(class, NSSelectorFromString(@"trailing"));
            Method rightMethod = class_getInstanceMethod(class, NSSelectorFromString(@"right"));
            method_exchangeImplementations(trailingMethod, rightMethod);
            
            Method leadingMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"leadingMargin"));
            Method leftMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"leftMargin"));
            method_exchangeImplementations(leadingMarginMethod, leftMarginMethod);
            
            Method trailingMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"trailingMargin"));
            Method rightMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"rightMargin"));
            method_exchangeImplementations(trailingMarginMethod, rightMarginMethod);
        });
    }
    
//    [MASConstraintMaker changeByLanguege];
}

+ (void)changeByLanguege {
    // 系统语言判断
    NSString *languegeCode = [[NSLocale currentLocale] languageCode];
    if (![languegeCode isEqualToString:@"ar"]) {
        return;
    }
    
    Class class = [self class];
    
    Method leadingMethod = class_getInstanceMethod(class, NSSelectorFromString(@"leading"));
    Method leftMethod = class_getInstanceMethod(class, NSSelectorFromString(@"left"));
    
    Method trailingMethod = class_getInstanceMethod(class, NSSelectorFromString(@"trailing"));
    Method rightMethod = class_getInstanceMethod(class, NSSelectorFromString(@"right"));
    
    Method leadingMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"leadingMargin"));
    Method leftMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"leftMargin"));
    
    Method trailingMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"trailingMargin"));
    Method rightMarginMethod = class_getInstanceMethod(class, NSSelectorFromString(@"rightMargin"));
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        method_exchangeImplementations(leadingMethod, trailingMethod);
        method_exchangeImplementations(leftMethod, trailingMethod);
        method_exchangeImplementations(trailingMethod, leadingMethod);
        method_exchangeImplementations(rightMethod, leadingMethod);
        
        method_exchangeImplementations(leadingMarginMethod, trailingMarginMethod);
        method_exchangeImplementations(leftMarginMethod, trailingMarginMethod);
        method_exchangeImplementations(trailingMarginMethod, leadingMarginMethod);
        method_exchangeImplementations(rightMarginMethod, leadingMarginMethod);
    } else {
        IMP leadingIMP = method_getImplementation(leadingMethod);
        method_setImplementation(leadingMethod, leadingIMP);
        
        IMP leftIMP = method_getImplementation(leftMethod);
        method_setImplementation(leftMethod, leftIMP);
        
        IMP trailingIMP = method_getImplementation(trailingMethod);
        method_setImplementation(trailingMethod, trailingIMP);
        
        IMP rightIMP = method_getImplementation(rightMethod);
        method_setImplementation(rightMethod, rightIMP);
        
        IMP leadingMarginIMP = method_getImplementation(leadingMarginMethod);
        method_setImplementation(leadingMarginMethod, leadingMarginIMP);
        
        IMP leftMarginIMP = method_getImplementation(leftMarginMethod);
        method_setImplementation(leftMarginMethod, leftMarginIMP);
        
        IMP trailingMarginIMP = method_getImplementation(trailingMarginMethod);
        method_setImplementation(trailingMarginMethod, trailingMarginIMP);
        
        IMP rightMarginIMP = method_getImplementation(rightMarginMethod);
        method_setImplementation(rightMarginMethod, rightMarginIMP);
    }
}

@end
