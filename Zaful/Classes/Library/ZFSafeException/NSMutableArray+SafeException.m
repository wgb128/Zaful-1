//
//  NSMutableArray+SafeException.m
//  QHSafeException
//
//  Created by QianHan on 2017/12/6.
//  Copyright © 2017年 karl.luo. All rights reserved.
//

#import "NSMutableArray+SafeException.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSMutableArray (SafeException)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(zf_objectAtIndex:)];
        [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(zf_objectAtIndexedSubscript:)];
        [objc_getClass("__NSArrayM") swizzleMethod:@selector(insertObject:atIndex:) swizzledSelector:@selector(zf_insertObject:atIndex:)];
        [objc_getClass("__NSArrayM") swizzleMethod:@selector(removeObjectsInRange:) swizzledSelector:@selector(zf_removeObjectsInRange:)];
        [objc_getClass("__NSArrayM") swizzleMethod:@selector(exchangeObjectAtIndex:withObjectAtIndex:) swizzledSelector:@selector(zf_exchangeObjectAtIndex:withObjectAtIndex:)];
    });
}

- (void)zf_insertObject:(id)object atIndex:(NSInteger)index {
    if (object == nil
        || index > self.count) {
        return;
    }
    [self zf_insertObject:object atIndex:index];
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

- (void)zf_removeObjectsInRange:(NSRange)range {
    if (range.location >= self.count) {
        return;
    }
    [self zf_removeObjectsInRange:range];
}

- (void)zf_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    if (idx1 >= self.count
        || idx2 >= self.count) {
        return;
    }
    [self zf_exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

@end
