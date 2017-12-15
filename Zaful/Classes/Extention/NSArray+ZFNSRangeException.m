//
//  NSArray+ZFNSRangeException.m
//  Zaful
//
//  Created by QianHan on 2017/9/21.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "NSArray+ZFNSRangeException.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSArray (ZFNSRangeException)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(zf_objectAtIndexedSubscript:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(zf_mutableObjectAtIndexedSubscript:)];
            
        }
    });
}

- (id)zf_objectAtIndexedSubscript:(NSInteger)index {
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self zf_objectAtIndexedSubscript:index];
}

- (id)zf_mutableObjectAtIndexedSubscript:(NSInteger)index {
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self zf_mutableObjectAtIndexedSubscript:index];
}

@end
