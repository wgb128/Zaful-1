//
//  UILabel+StringFrame.m
//  Yoshop
//
//  Created by huangxieyue on 16/6/20.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)
- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                      
                                             options:\
                      
                      NSStringDrawingTruncatesLastVisibleLine |
                      
                      NSStringDrawingUsesLineFragmentOrigin |
                      
                      NSStringDrawingUsesFontLeading
                      
                                          attributes:attribute
                      
                                             context:nil].size;
    
    return retSize;
}

#pragma mark - Private Methods
//获取自适应Label的高度
- (CGSize)getAutoLabelHeightWithText:(NSString *)text Font:(UIFont *)font MaxWidth:(CGFloat)maxWidth
{
    NSDictionary *dic = @{NSFontAttributeName : font};
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    return CGSizeMake(rect.size.width, rect.size.height);
}
@end
