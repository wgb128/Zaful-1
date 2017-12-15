//
//  UIViewController+Extension.h
//  DressOnline
//
//  Created by TsangFa on 16/5/31.
//  Copyright © 2016年 Sammydress. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LeftBarItemBlock)();
typedef void(^RightBarItemBlock)();

@interface UIViewController (NavagationBar)

@property (nonatomic,copy) LeftBarItemBlock  leftBarItemBlock;
@property (nonatomic,copy) RightBarItemBlock rightBarItemBlock;


/**
 *  @brief 设置全局默认导航栏返回键
 */
- (void)setNavagationBarDefaultBackButton;

/**
 *  @brief 根据UI设计设置导航栏返回键
 *
 *  @param image 返回键
 */
- (void)setNavagationBarBackBtnWithImage:(UIImage *)image;

/**
 *  @brief 设置导航栏右键
 *
 *  @param image 右键图片
 */
- (void)setNavagationBarRightButtonWithImage:(UIImage *)image;

/**
 *  @brief 设置导航栏左键
 *
 *  @param title 左键标题
 *  @param font  文字字号
 *  @param color 文字颜色
 *  @param size  文字位置
 */
- (void)setNavagationBarLeftButtonWithTitle:(NSString *)title
                                        font:(UIFont *)font
                                      color:(UIColor *)color;


/**
 *  @brief 设置导航栏右键
 *
 *  @param title 右键标题
 *  @param font  文字字号
 *  @param color 文字颜色
 *  @param size  文字位置
 */
- (void)setNavagationBarRightButtonWithTitle:(NSString *)title
                                        font:(UIFont *)font
                                       color:(UIColor *)color;

/**
 *  @brief 设置导航栏标题
 *
 *  @param title 标题
 *  @param font  字体
 *  @param color 颜色
 */
- (void)setNavagationBarTitle:(NSString *)title
                         font:(UIFont *)font
                        color:(UIColor *)color;

/*!
 *  @brief 模态一个半透明的视图。
 *  @brief 透明度由 viewControllerToPresent 的 backgroundColor 控制
 */
- (void)presentTranslucentViewController:(UIViewController *)viewControllerToPresent
                                animated: (BOOL)flag
                              completion:(void (^)(void))completion;




@end
