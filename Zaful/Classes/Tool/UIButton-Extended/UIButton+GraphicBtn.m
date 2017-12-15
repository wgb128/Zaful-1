//
//  UIButton+GraphicBtn.m
//  Zaful
//
//  Created by DBP on 2017/6/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "UIButton+GraphicBtn.h"

@implementation UIButton (GraphicBtn)

- (void)initWithTitle:(NSString *)titles andImageName:(NSString *)imageName andTopHeight:(CGFloat)topHeigt andTextColor:(UIColor *)textColor{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(topHeigt);
        make.size.mas_equalTo(CGSizeMake(24, 18));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = titles;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = textColor;
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(imageView.mas_bottom).offset(5);
    }];
}

@end
