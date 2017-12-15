//
//  UIView+Gesture.m
//  GearBest
//
//  Created by 张行 on 16/6/2.
//  Copyright © 2016年 gearbest. All rights reserved.
//

#import "UIView+GBGesture.h"
#import <objc/runtime.h>

const void * KTapGesture = "KTapGesture";
const void * KTapGestureComplete = "KTapGestureComplete";

@interface UIView ()

@property (nonatomic, copy) UIViewGestureComplete tapGestureComplete;

@end

@implementation UIView (Gesture)

@dynamic tapGesture;

- (void)addTapGestureWithComplete:(UIViewGestureComplete)complete {
    NSParameterAssert(complete);
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    objc_setAssociatedObject(self, @selector(tapGesture), tapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(tapGestureComplete), complete, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - gesture method
- (void)tapClick{
    self.tapGestureComplete(self);
}

#pragma mark - property get
- (nullable UITapGestureRecognizer *)tapGesture {
    return objc_getAssociatedObject(self,_cmd);
}

- (UIViewGestureComplete)tapGestureComplete {
    return objc_getAssociatedObject(self, _cmd);
}

@end
