//
//  UILabel+StringFrame.h
//  Yoshop
//
//  Created by huangxieyue on 16/6/20.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (StringFrame)
- (CGSize)boundingRectWithSize:(CGSize)size;
- (CGSize)getAutoLabelHeightWithText:(NSString *)text Font:(UIFont *)font MaxWidth:(CGFloat)maxWidth;
@end
