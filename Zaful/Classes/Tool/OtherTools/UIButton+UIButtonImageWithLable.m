//
//  UIButton+UIButtonImageWithLable.m
//  Zaful
//
//  Created by DBP on 16/12/1.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "UIButton+UIButtonImageWithLable.h"

@implementation UIButton (UIButtonImageWithLable)

- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                              -5.0,
                                              0.0,
                                              0.0)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                              5.0,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}


@end
