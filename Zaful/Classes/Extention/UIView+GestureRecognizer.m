//
//  UIView+GestureRecognizer.m
//  Zaful
//
//  Created by zhaowei on 2017/2/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "UIView+GestureRecognizer.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface UIView ()<UIGestureRecognizerDelegate>
@property CGFloat lastRotation;
@end

@implementation UIView(GestureRecognizer)
//定义常量 必须是C语言字符串
static char *UIViewGestureRecognizerKey = "UIViewGestureRecognizerKey";
-(void)setLastRotation:(CGFloat)lastRotation{
    /*
     OBJC_ASSOCIATION_ASSIGN;            //assign策略
     OBJC_ASSOCIATION_COPY_NONATOMIC;    //copy策略
     OBJC_ASSOCIATION_RETAIN_NONATOMIC;  // retain策略
     
     OBJC_ASSOCIATION_RETAIN;
     OBJC_ASSOCIATION_COPY;
     */
    /*
     * id object 给哪个对象的属性赋值
     const void *key 属性对应的key
     id value  设置属性值为value
     objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
     */
    
    objc_setAssociatedObject(self, UIViewGestureRecognizerKey, @(lastRotation), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(CGFloat)lastRotation{
    return [objc_getAssociatedObject(self, UIViewGestureRecognizerKey) floatValue];
}

// 添加所有的手势
- (void)addGestureRecognizerToView:(UIView *)view {
    [self setUserInteractionEnabled:YES];
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    rotationGestureRecognizer.delegate = self;
    [view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    pinchGestureRecognizer.delegate = self;
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
}


// 处理旋转手势
- (void)rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer {
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        //        [rotationGestureRecognizer setRotation:0];
        [self bringSubviewToFront:view];
        CGPoint location = [rotationGestureRecognizer locationInView:self];
        view.center = CGPointMake(location.x, location.y);
        
        if ([rotationGestureRecognizer state] == UIGestureRecognizerStateEnded) {
            self.lastRotation = 0;
            return;
        }
        CGAffineTransform currentTransform = view.transform;
        CGFloat rotation = 0.0 - (self.lastRotation - rotationGestureRecognizer.rotation);
        CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, rotation);
        view.transform = newTransform;
        self.lastRotation = rotationGestureRecognizer.rotation;
    }
}

// 处理缩放手势
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        //        pinchGestureRecognizer.scale = 1;
        [self bringSubviewToFront:view];
        
        CGPoint location = [pinchGestureRecognizer locationInView:self];
        view.center = CGPointMake(location.x, location.y);
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIView *view = panGestureRecognizer.view;
    [self bringSubviewToFront:view];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

- (UIImage *)screenShot {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    // 屏幕闪烁方法
    [self setAlpha:1];
    //开始动画
    [UIView beginAnimations:@"flash screen" context:nil];
    //动画时间
    [UIView setAnimationDuration:0.3f];
    //动画效果枚举值 淡入淡出动画
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //将闪烁view的透明度变为 透明
    [self setAlpha:0.0f];
    //结束动画
    [UIView commitAnimations];
    return image;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
