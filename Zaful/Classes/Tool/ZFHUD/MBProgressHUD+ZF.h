//
//  MBProgressHUD+ZF.h
//  HUD
//
//  Created by TsangFa on 10/9/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (ZF)

//*************************************************************************************//
//       [MBProgressHUD showLoadingView:nil];                                          //
//       [MBProgressHUD  hideHUD];                                                     //
//       [MBProgressHUD showMessage:@"Facebook share"];                                //
//*************************************************************************************//

/**
 * 用于网络请求
 * 搭配  +(void)hideHUD 一起使用
 * view 默认加在window 没有交互
 * 如果想在网络差的时候可以返回 ,可以加在其他view上
 */
+ (MBProgressHUD *)showLoadingView:(UIView *)view;


/**
 * 用于提示语显示(纯文字)
 * 默认加在window 没有交互
 * 2 秒后自动消失
 */
+ (void)showMessage:(NSString *)message;

/**
 * 标题 + 详情(纯文字)
 * 默认加在window 没有交互
 * 2 秒后自动消失
 */
+ (void)showTitle:(NSString *)title detail:(NSString *)detail;


/**
 * 图片 + 文字  (可自定义 成功 or 失败 提示图标)
 * 默认加在window 没有交互
 * 2 秒后自动消失
 */
+ (void)showMessage:(NSString *)message icon:(NSString *)iconName;

/**
 * 绘制成功提示动画
 * 默认加在window 没有交互
 * 1.5 秒后自动消失
 */
+ (void)showSuccessAnimation:(NSString *)message;

/**
 * 绘制错误提示动画
 * 默认加在window 没有交互
 * 1.5 秒后自动消失
 */
+ (void)ShowErrorAnimation:(NSString *)message;


/**
 * 隐藏
 */
+ (void)hideHUD;





@end
