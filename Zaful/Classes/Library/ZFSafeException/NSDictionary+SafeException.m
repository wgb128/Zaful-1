//
//  NSDictionary+SafeException.m
//  QHSafeException
//
//  Created by QianHan on 2017/12/6.
//  Copyright © 2017年 karl.luo. All rights reserved.
//

#import "NSDictionary+SafeException.h"
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"

@implementation NSDictionary (SafeException)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSPlaceholderDictionary") swizzleMethod:@selector(initWithObjects:forKeys:count:) swizzledSelector:@selector(zf_initWithObjects:forKeys:count:)];
            [objc_getClass("__NSDictionaryI") swizzleMethod:@selector(setValue:forUndefinedKey:) swizzledSelector:@selector(zf_setValue:forUndefinedKey:)];
        }
    });
}

- (instancetype)zf_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)count {
    
    id safeObjects[count];
    id safeKeys[count];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < count; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = @"";
        }
        safeKeys[j]    = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self zf_initWithObjects:safeObjects forKeys:safeKeys count:j];
}

- (instancetype)zf_setValue:(id)object forUndefinedKey:(NSString *)key {
    if (object == nil
        || key == nil) {
        return nil;
    }
    return [self zf_setValue:object forUndefinedKey:key];
}

@end
