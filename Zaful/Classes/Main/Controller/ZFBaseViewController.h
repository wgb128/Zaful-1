//
//  ZFBaseViewController.h
//  Dezzal
//
//  Created by 7FD75 on 16/7/21.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFBaseViewController : UIViewController

/**
 *  时间戳转换
 *
 */
- (NSString *)stringWithTimeSp:(NSString *)timeSp;

/**
 *  点赞和收藏动画效果
 */
- (CAKeyframeAnimation *)createFavouriteAnimation;

/**
 *  登录
 */
- (void)loginVerifySuccess:(void (^)())success;

/**
 * 显示错误时，边框颜色的改变
 *
 *  @param textField 
 */
- (void)showErrorBorderColorWithTextField:(UITextField *)textField;


/**
 *  显示重新请求
 */
- (void)showAgainRequest;

/**
 *  隐藏重新请求
 */
- (void)hiddenAgainRequest;

/**
 *  重新请求网络
 */
- (void)againRequest;

/**
 *  检测TextField是否可用的提示框
 *
 *  @param textField text
 *
 *  @return Bool
 */
- (BOOL)checkInputTextFieldIsValid:(UITextField *)textField;

/**
 *  后退方法
 */
- (void)popToSuperView;

- (void)loginVerifySuccess:(void (^)())success cancelLogin:(void (^)())cancel;



/**
 *  设置NO DATA 的View
 *
 *  @param view     所在的View
 *  @param imgName  图片名字
 *  @param title    文字
 *  @param name     Button名字
 *  @param btnBlock Button事件
 */
- (void)showNoDataInView:(UIView *)view imageView:(NSString *)imgName titleLabel:(NSString *)title button:(NSString *)name buttonBlock:(void (^)())btnBlock;

/**
 *  设置空
 *
 *  @param view     所在的view
 *  @param btnBlock Button事件
 */
- (void)showNoNetworkViewInView:(UIView *)view buttonBlock:(void (^)())btnBlock;

/**
 *  购物车的Badge
 */
- (void)addBadgeToButton:(UIButton *)button;

@property (nonatomic, strong) UIButton *badgeBtn;

@property (nonatomic, assign) BOOL firstEnter;

@end
