//
//  UIView+GestureRecognizer.h
//  Zaful
//
//  Created by zhaowei on 2017/2/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(GestureRecognizer)
//[self addGestureRecognizerToView:view];
//
////如果处理的是图片，别忘了
//[imageView setUserInteractionEnabled:YES];
//[imageView setMultipleTouchEnabled:YES];
- (void)addGestureRecognizerToView:(UIView *)view;
-(UIImage *)screenShot;
@end
