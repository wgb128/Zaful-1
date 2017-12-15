//
//  NSArray+SafeException.m
//  QHSafeException
//
//  Created by QianHan on 2017/12/6.
//  Copyright © 2017年 karl.luo. All rights reserved.
//

#import "NSArray+SafeException.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSArray (SafeException)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSPlaceholderArray") swizzleMethod:@selector(initWithObjects:count:) swizzledSelector:@selector(zf_initWithObjects:count:)];
        [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(zf_objectAtIndex:)];
        [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(zf_objectAtIndexedSubscript:)];
        [objc_getClass("__NSSingleObjectArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(zf_singleObjectAtIndex:)];
        [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(zf_objectIndex0:)];
    });
}

- (instancetype)zf_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)count {
    id safeObjects[count];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < count; i++) {
        id obj = objects[i];
        if (!obj) {
            obj = @"";
        }
        safeObjects[j] = obj;
        j++;
    }
    return [self zf_initWithObjects:safeObjects count:j];
}

- (id)zf_objectAtIndex:(NSInteger)index {
    if (index >= self.count
        || index < 0) {
        return nil;
    }
    return [self zf_objectAtIndex:index];
}

- (id)zf_objectAtIndexedSubscript:(NSInteger)index {
    if (index >= self.count
        || index < 0) {
        return nil;
    }
    return [self zf_objectAtIndexedSubscript:index];
}

- (id)zf_singleObjectAtIndex:(NSInteger)index {
    if (index >= self.count
        || index < 0) {
        return nil;
    }
    return [self zf_singleObjectAtIndex:index];
}

- (id)zf_objectIndex0:(NSInteger)index {
    if (index >= self.count
        || index < 0) {
        return nil;
    }
    return [self zf_objectIndex0:index];
}

@end
