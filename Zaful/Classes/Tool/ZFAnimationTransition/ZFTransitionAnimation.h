//
//  ZFTransitionAnimation.h
//  Zaful
//
//  Created by liuxi on 2017/10/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZFTransitionAnimationDelegate <NSObject>

- (void)animationFinish;

@end

@interface ZFTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) NSURL         *imageUrl;
@property (nonatomic, assign) CGRect        destinationRec;
@property (nonatomic, assign) CGRect        originalRec;
@property (nonatomic, assign) BOOL          isPush;
@property (nonatomic, assign) BOOL          isGoodsDetailTransition;
@property (nonatomic, weak)   id<ZFTransitionAnimationDelegate>  delegate;

@end
