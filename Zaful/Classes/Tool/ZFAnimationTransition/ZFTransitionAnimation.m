//
//  ZFTransitionAnimation.m
//  Zaful
//
//  Created by liuxi on 2017/10/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFTransitionAnimation.h"

@interface ZFTransitionAnimation()

@end

@implementation ZFTransitionAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 这个是小红书的动画  通过imageView实现rec的变化，然后消失，代理调用，再把image补上，动画就是衔接得这么不自然......
    UIView *contentView = [transitionContext containerView];
    contentView.backgroundColor = ZFCOLOR_WHITE;
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [contentView addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    
    __block UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setYy_imageURL:self.imageUrl];
    imageView.frame = self.isPush ? self.originalRec : self.destinationRec;
    [contentView addSubview:imageView];
    
    if (!self.isPush) {
        self.imageView.alpha = 0;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        imageView.frame = self.isPush ? self.destinationRec : self.originalRec;
        toViewController.view.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        [imageView removeFromSuperview];
        if (!self.isPush) {
            self.imageView.alpha = 1;
        }
        imageView = nil;
    }];
}
@end
