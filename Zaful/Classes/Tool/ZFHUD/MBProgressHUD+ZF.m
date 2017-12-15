//
//  MBProgressHUD+ZF.m
//  HUD
//
//  Created by TsangFa on 10/9/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "MBProgressHUD+ZF.h"
#import "MBLoadingView.h"


CGFloat const kDelayTime = 1.5;
CGFloat const kFontsize  = 12.0;

@implementation MBProgressHUD (ZF)

NS_INLINE MBProgressHUD *createNew(UIView *view) {
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    return [MBProgressHUD showHUDAddedTo:view animated:YES];
}

NS_INLINE MBProgressHUD *setHUD(UIView *view, NSString *title, BOOL autoHidden) {
    MBProgressHUD *hud = createNew(view);
    // 文字
    hud.label.text = title;
    hud.label.numberOfLines = 0;
    hud.label.font = [UIFont systemFontOfSize:kFontsize];
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = ZFCOLOR(51, 51, 51, 0.9);
    // 展现方式
    hud.animationType = MBProgressHUDAnimationZoom;
    // x秒之后消失
    if (autoHidden) [hud hideAnimated:YES afterDelay:kDelayTime];

    return hud;
}

+ (MBProgressHUD *)showLoadingView:(UIView *)view {
    
    MBProgressHUD *HUD = setHUD(view, nil, NO);
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.bezelView.layer.cornerRadius = 8.0;
    HUD.minSize = CGSizeMake(64, 64);
    HUD.square = YES;
    // 30秒后自动隐藏
    [HUD hideAnimated:YES afterDelay:30.0];
    
    MBLoadingView *customView = [[MBLoadingView alloc] init];
    HUD.customView = customView;
    return HUD;
}

+ (void)showMessage:(NSString *)message {
    MBProgressHUD *HUD = setHUD(nil, message, NO);
    HUD.mode = MBProgressHUDModeText;
    HUD.label.textColor =[UIColor whiteColor];
    HUD.animationType = MBProgressHUDAnimationFade;
    [HUD hideAnimated:YES afterDelay:2.0];
}

+ (void)showTitle:(NSString *)title detail:(NSString *)detail {
    MBProgressHUD *HUD = setHUD(nil, title, NO);
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabel.text = detail;
    [HUD hideAnimated:YES afterDelay:2.0];
}

+ (void)showMessage:(NSString *)message icon:(NSString *)iconName {
    MBProgressHUD *HUD = setHUD(nil, message, NO);
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.textColor = [UIColor whiteColor];
    [HUD hideAnimated:YES afterDelay:2.0];
}

+ (void)showSuccessAnimation:(NSString *)message {
    MBProgressHUD *HUD = setHUD(nil, message, YES);
    HUD.label.textColor = [UIColor whiteColor];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.bezelView.layer.cornerRadius = 8.0;
    HUD.minSize = CGSizeMake(64, 64);
    HUD.square = YES;
    HUD.customView.backgroundColor = ZFCOLOR(51, 51, 51, 0.9);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.frame = iconImageView.bounds;
    [iconImageView.layer addSublayer: layer];
    layer.strokeColor = [UIColor  whiteColor].CGColor;
    HUD.customView = iconImageView;
    
    const int STROKE_WIDTH = 3;// 默认的划线线条宽度
    
    // 绘制外部透明的圆形
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter: CGPointMake(layer.frame.size.width / 2, layer.frame.size.height / 2) radius:layer.frame.size.width / 2 - STROKE_WIDTH startAngle:  0 * M_PI/180 endAngle: 360 * M_PI/180 clockwise: NO];
    // 创建外部透明圆形的图层
    CAShapeLayer *alphaLineLayer = [CAShapeLayer layer];
    alphaLineLayer.path = circlePath.CGPath;// 设置透明圆形的绘图路径
    alphaLineLayer.strokeColor = [[UIColor colorWithCGColor: layer.strokeColor] colorWithAlphaComponent: 0.1].CGColor;// 设置图层的透明圆形的颜色
    alphaLineLayer.lineWidth = STROKE_WIDTH;// 设置圆形的线宽
    alphaLineLayer.fillColor = [UIColor clearColor].CGColor;// 填充颜色透明
    
    [layer addSublayer: alphaLineLayer];// 把外部半透明圆形的图层加到当前图层上
    
    // 设置当前图层的绘制属性
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap = kCALineCapRound;// 圆角画笔
    layer.lineWidth = STROKE_WIDTH;
    
    // 半圆+动画的绘制路径初始化
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 绘制大半圆
    [path addArcWithCenter: CGPointMake(layer.frame.size.width / 2, layer.frame.size.height / 2) radius:layer.frame.size.width / 2 - STROKE_WIDTH startAngle:  67 * M_PI / 180 endAngle: -158 * M_PI / 180 clockwise: NO];
    // 绘制对号第一笔
    [path addLineToPoint: CGPointMake(layer.frame.size.width * 0.42, layer.frame.size.width * 0.68)];
    // 绘制对号第二笔
    [path addLineToPoint: CGPointMake(layer.frame.size.width * 0.75, layer.frame.size.width * 0.35)];
    // 把路径设置为当前图层的路径
    layer.path = path.CGPath;
    
    CAMediaTimingFunction *timing = [[CAMediaTimingFunction alloc] initWithControlPoints:0.3 :0.6 :0.8 :1.1];
    // 创建路径顺序绘制的动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"strokeEnd"];
    animation.duration = 0.5;// 动画使用时间
    animation.fromValue = [NSNumber numberWithInt: 0.0];// 从头
    animation.toValue = [NSNumber numberWithInt: 1.0];// 画到尾
    // 创建路径顺序从结尾开始消失的动画
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath: @"strokeStart"];
    strokeStartAnimation.duration = 0.4;// 动画使用时间
    strokeStartAnimation.beginTime = CACurrentMediaTime() + 0.2;// 延迟0.2秒执行动画
    strokeStartAnimation.fromValue = [NSNumber numberWithFloat: 0.0];// 从开始消失
    strokeStartAnimation.toValue = [NSNumber numberWithFloat: 0.74];// 一直消失到整个绘制路径的74%
    strokeStartAnimation.timingFunction = timing;
    
    layer.strokeStart = 0.74;// 设置最终效果，防止动画结束之后效果改变
    layer.strokeEnd = 1.0;
    
    [layer addAnimation: animation forKey: @"strokeEnd"];// 添加俩动画
    [layer addAnimation: strokeStartAnimation forKey: @"strokeStart"];

}

+ (void)ShowErrorAnimation:(NSString *)message {
    MBProgressHUD *HUD = setHUD(nil, message, YES);
    HUD.label.textColor = [UIColor whiteColor];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.bezelView.layer.cornerRadius = 8.0;
    HUD.minSize = CGSizeMake(64, 64);
    HUD.square = YES;
    HUD.customView.backgroundColor = ZFCOLOR(51, 51, 51, 0.9);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.frame = iconImageView.bounds;
    [iconImageView.layer addSublayer: layer];
    layer.strokeColor = [UIColor  whiteColor].CGColor;
    HUD.customView = iconImageView;
    
    const int STROKE_WIDTH = 3;// 默认的划线线条宽度

    // 绘制外部透明的圆形
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter: CGPointMake(layer.frame.size.width / 2, layer.frame.size.height / 2) radius:layer.frame.size.width / 2 - STROKE_WIDTH startAngle:  0 * M_PI/180 endAngle: 360 * M_PI/180 clockwise: NO];
    // 创建外部透明圆形的图层
    CAShapeLayer *alphaLineLayer = [CAShapeLayer layer];
    alphaLineLayer.path = circlePath.CGPath;// 设置透明圆形的绘图路径
    alphaLineLayer.strokeColor = [[UIColor colorWithCGColor: layer.strokeColor] colorWithAlphaComponent: 0.1].CGColor;
    // ↑ 设置图层的透明圆形的颜色，取图标颜色之后设置其对应的0.1透明度的颜色
    alphaLineLayer.lineWidth = STROKE_WIDTH;// 设置圆形的线宽
    alphaLineLayer.fillColor = [UIColor clearColor].CGColor;// 填充颜色透明
    
    [layer addSublayer: alphaLineLayer];// 把外部半透明圆形的图层加到当前图层上
    
    // 开始画叉的两条线，首先画逆时针旋转的线
    CAShapeLayer *leftLayer = [CAShapeLayer layer];
    // 设置当前图层的绘制属性
    leftLayer.frame = layer.bounds;
    leftLayer.fillColor = [UIColor clearColor].CGColor;
    leftLayer.lineCap = kCALineCapRound;// 圆角画笔
    leftLayer.lineWidth = STROKE_WIDTH;
    leftLayer.strokeColor = layer.strokeColor;
    
    // 半圆+动画的绘制路径初始化
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    // 绘制大半圆
    [leftPath addArcWithCenter: CGPointMake(layer.frame.size.width / 2, layer.frame.size.height / 2) radius:layer.frame.size.width / 2 - STROKE_WIDTH startAngle:  -43 * M_PI / 180 endAngle: -315 * M_PI / 180 clockwise: NO];
    [leftPath addLineToPoint: CGPointMake(layer.frame.size.width * 0.35, layer.frame.size.width * 0.35)];
    // 把路径设置为当前图层的路径
    leftLayer.path = leftPath.CGPath;
    
    [layer addSublayer: leftLayer];
    
    // 逆时针旋转的线
    CAShapeLayer *rightLayer = [CAShapeLayer layer];
    // 设置当前图层的绘制属性
    rightLayer.frame = layer.bounds;
    rightLayer.fillColor = [UIColor clearColor].CGColor;
    rightLayer.lineCap = kCALineCapRound;// 圆角画笔
    rightLayer.lineWidth = STROKE_WIDTH;
    rightLayer.strokeColor = layer.strokeColor;
    
    // 半圆+动画的绘制路径初始化
    UIBezierPath *rightPath = [UIBezierPath bezierPath];
    // 绘制大半圆
    [rightPath addArcWithCenter: CGPointMake(layer.frame.size.width / 2, layer.frame.size.height / 2) radius:layer.frame.size.width / 2 - STROKE_WIDTH  startAngle:  -128 * M_PI / 180 endAngle: 133 * M_PI / 180 clockwise: YES];
    [rightPath addLineToPoint: CGPointMake(layer.frame.size.width * 0.65, layer.frame.size.width * 0.35)];
    // 把路径设置为当前图层的路径
    rightLayer.path = rightPath.CGPath;
    
    [layer addSublayer: rightLayer];
    
    
    CAMediaTimingFunction *timing = [[CAMediaTimingFunction alloc] initWithControlPoints:0.3 :0.6 :0.8 :1.1];
    // 创建路径顺序绘制的动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"strokeEnd"];
    animation.duration = 0.5;// 动画使用时间
    animation.fromValue = [NSNumber numberWithInt: 0.0];// 从头
    animation.toValue = [NSNumber numberWithInt: 1.0];// 画到尾
    // 创建路径顺序从结尾开始消失的动画
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath: @"strokeStart"];
    strokeStartAnimation.duration = 0.4;// 动画使用时间
    strokeStartAnimation.beginTime = CACurrentMediaTime() + 0.2;// 延迟0.2秒执行动画
    strokeStartAnimation.fromValue = [NSNumber numberWithFloat: 0.0];// 从开始消失
    strokeStartAnimation.toValue = [NSNumber numberWithFloat: 0.84];// 一直消失到整个绘制路径的84%
    strokeStartAnimation.timingFunction = timing;
    
    leftLayer.strokeStart = 0.84;// 设置最终效果，防止动画结束之后效果改变
    leftLayer.strokeEnd = 1.0;
    rightLayer.strokeStart = 0.84;// 设置最终效果，防止动画结束之后效果改变
    rightLayer.strokeEnd = 1.0;
    
    
    [leftLayer addAnimation: animation forKey: @"strokeEnd"];// 添加俩动画
    [leftLayer addAnimation: strokeStartAnimation forKey: @"strokeStart"];
    [rightLayer addAnimation: animation forKey: @"strokeEnd"];// 添加俩动画
    [rightLayer addAnimation: strokeStartAnimation forKey: @"strokeStart"];

}

+ (void)hideHUD {
    UIView *view = (UIView*)[UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:view animated:YES];
}



@end
