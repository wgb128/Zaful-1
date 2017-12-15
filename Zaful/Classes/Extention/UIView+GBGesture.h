//
//  UIView+Gesture.h
//  GearBest
//
//  Created by 张行 on 16/6/2.
//  Copyright © 2016年 gearbest. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UIViewGestureComplete)(UIView *view);

@interface UIView (Gesture)

@property (nonatomic, strong, readonly,nullable) UITapGestureRecognizer *tapGesture;

- (void)addTapGestureWithComplete:(UIViewGestureComplete)complete;

@end

NS_ASSUME_NONNULL_END
