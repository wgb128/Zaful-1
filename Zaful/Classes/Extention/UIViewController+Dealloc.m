//
//  UIViewController+Dealloc.m
//  GearBest
//
//  Created by 张行 on 16/6/30.
//  Copyright © 2016年 GearBest. All rights reserved.
//

#import "UIViewController+Dealloc.h"
#import <objc/runtime.h>
@implementation UIViewController (Dealloc)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        Method setTextMethod = class_getInstanceMethod(class, NSSelectorFromString(@"dealloc"));
        Method replaceSetTextMethod = class_getInstanceMethod(class, NSSelectorFromString(@"zf_dealloc"));
        method_exchangeImplementations(setTextMethod, replaceSetTextMethod);
    });
}

-(void)zf_dealloc {
    ZFLog(@"%@->>>>已经释放了",[self class]);
    [self zf_dealloc];
}

@end
