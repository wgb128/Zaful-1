//
//  NSMutableDictionary+SafeException.m
//  QHSafeException
//
//  Created by QianHan on 2017/12/6.
//  Copyright © 2017年 karl.luo. All rights reserved.
//

#import "NSMutableDictionary+SafeException.h"
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"

@implementation NSMutableDictionary (SafeException)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(zf_setObject:forKey:)];
            [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(removeObjectForKey) swizzledSelector:@selector(zf_removeObjectForKey:)];
        }
    });
}

- (void)zf_setObject:(nonnull id)object forKey:(nonnull id<NSCopying>)aKey {
    if (object == nil
        || aKey == nil) {
        return;
    }
    [self zf_setObject:object forKey:aKey];
}

- (void)zf_removeObjectForKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    [self zf_removeObjectForKey:key];
}

@end
