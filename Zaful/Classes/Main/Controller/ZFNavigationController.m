//
//  ZFNavigationController.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/21.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "ZFNavigationController.h"

@interface ZFNavigationController ()

@end

@implementation ZFNavigationController

/**
 *  系统在第一次使用这个类的时候调用(1个类只会调用一次)
 */
+ (void)initialize
{
    //    设置NavigationBar背景颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:ZFCOLOR(0, 0, 0, 1.0)];
    
    if (ISIOS11) {
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"nav_arrow_left"]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"nav_arrow_left"]];
    } else {
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"nav_arrow_right" : @"nav_arrow_left"]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"nav_arrow_right" : @"nav_arrow_left"]];
    }
//    //     2.设置BarButtonItem的主题
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    //     设置文字颜色
//
//    //设置item普通状态
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
//    attrs[NSForegroundColorAttributeName] = [UIColor bla];
//    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
//
//    //设置item不可用状态
//    NSMutableDictionary *disabledAttrs = [NSMutableDictionary dictionary];
//    disabledAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];
//    disabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    [item setTitleTextAttributes:disabledAttrs forState:UIControlStateDisabled];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 11.0) {
        // 将返回按钮的文字position设置不在屏幕上显示
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
}

/**
 *  重写这个方法,能拦截所有的push操作
 *
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
