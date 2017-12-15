//
//  UIView+AutoLayoutSpace.h
//  DemoMasonry
//
//  Created by TsangFa on 16/6/16.
//  Copyright © 2016年 LJC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YSOscillatoryAnimationToBigger,
    YSOscillatoryAnimationToSmaller,
} YSOscillatoryAnimationType;


@interface UIView (AutoLayoutSpace)

/*!
 *  @brief Masonry并没有直接提供等间隙排列的方法，水平方向的等间隙排列 注意是由父视图调用！
 *
 *  @param views 需要等间隙排列的视图集合
 */
- (void) distributeSpacingHorizontallyWith:(NSArray*)views;

/*!
 *  @brief Masonry并没有直接提供等间隙排列的方法，垂直方向的等间隙排列 注意是由父视图调用！
 *
 *  @param views 需要等间隙排列的视图集合
 */
- (void) distributeSpacingVerticallyWith:(NSArray*)views;


/*!
 *  @brief 显示当前视图的边框，用于UI调试
 *
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
- (void)showCurrentViewBorder:(CGFloat)borderWidth color:(UIColor *)borderColor;

/*!
 *  @brief 显示UI 默认红色
 */
- (void)showDebugUI;

/*!
 *  @brief 提醒数字动弹效果
 *
 *  @param layer 需要做动画的视图 layer
 *  @param type  动画类型
 */
+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(YSOscillatoryAnimationType)type;

- (UIView*)findViewRecursively:(BOOL(^)(UIView* subview, BOOL* stop))recurse;
@end
