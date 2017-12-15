//
//  UIButton+UIButtonImageWithLable.h
//  Zaful
//
//  Created by DBP on 16/12/1.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButtonImageWithLable)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;
@end
