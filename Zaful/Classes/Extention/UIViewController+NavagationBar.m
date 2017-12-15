//
//  UIViewController+Extension.m
//  DressOnline
//
//  Created by TsangFa on 16/5/31.
//  Copyright © 2016年 Sammydress. All rights reserved.
//

#import "UIViewController+NavagationBar.h"
#import <objc/runtime.h>

static char *leftBarItemBlockKey  = "leftBarItemBlockKey";
static char *rightBarItemBlockKey = "rightBarItemBlockKey";

@implementation UIViewController (NavagationBar)

- (void)setLeftBarItemBlock:(LeftBarItemBlock)leftBarItemBlock {
    objc_setAssociatedObject(self, leftBarItemBlockKey, leftBarItemBlock, OBJC_ASSOCIATION_COPY);
}

- (LeftBarItemBlock)leftBarItemBlock {
    return objc_getAssociatedObject(self, leftBarItemBlockKey);
}

- (void)setRightBarItemBlock:(RightBarItemBlock)rightBarItemBlock {
    objc_setAssociatedObject(self, rightBarItemBlockKey, rightBarItemBlock, OBJC_ASSOCIATION_COPY);
}

- (RightBarItemBlock)rightBarItemBlock {
    return objc_getAssociatedObject(self, rightBarItemBlockKey);
}

/*********************  设置导航栏左侧图片按钮  *****************************/

- (void)setNavagationBarDefaultBackButton {
    [self setNavagationBarBackBtnWithImage:nil];
}

- (void)setNavagationBarBackBtnWithImage:(UIImage *)image {
    NSArray *itemsArray = [self barBackButtonWithImage:image];
    self.navigationItem.leftBarButtonItems = [self isTabbarRoot] ? nil : itemsArray;
    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (BOOL)isTabbarRoot {
    for (ZFNavigationController *nc in self.tabBarController.viewControllers) {
        if (nc.viewControllers.firstObject == self) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)barBackButtonWithImage:(UIImage *)aImage {
    UIImage *image;
    image = aImage ? aImage : [UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"nav_arrow_right" : @"nav_arrow_left"];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(popToSuperView) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    // 1.调整图片距左间距可以这样设置
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    return @[spaceItem, item];
}

- (void)popToSuperView {
    if (self.leftBarItemBlock) {
        self.leftBarItemBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*********************  设置导航栏右侧图片按钮  *****************************/
- (void)setNavagationBarRightButtonWithImage:(UIImage *)image {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setFrame:buttonFrame];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    btn.accessibilityLabel = nil;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 0;
    self.navigationItem.rightBarButtonItems = @[spaceItem, buttonItem];
}

- (void)buttonClick {
    if (self.rightBarItemBlock) {
        self.rightBarItemBlock();
    }
}

/*********************  设置导航栏左侧文字按钮  *****************************/
- (void)setNavagationBarLeftButtonWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect buttonFrame = CGRectMake(0, 0, 83, 30); // (83,30)是系统的尺寸
    [btn setFrame:buttonFrame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -30; // 根据效果，初步猜测这里是取（-宽度）值
    self.navigationItem.leftBarButtonItems = @[spaceItem, buttonItem];
}


/*********************  设置导航栏右侧文字按钮  *****************************/
- (void)setNavagationBarRightButtonWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect buttonFrame = CGRectMake(0, 0, 83, 30);
    [btn setFrame:buttonFrame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -25;
    self.navigationItem.rightBarButtonItems = @[spaceItem, buttonItem];
}

/********************* 设置导航栏标题文字 **********************************/
- (void)setNavagationBarTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor whiteColor];
    shadow.shadowOffset = CGSizeZero;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          color,NSForegroundColorAttributeName,
                          font,NSFontAttributeName,
                          shadow,NSShadowAttributeName,
                          shadow,NSShadowAttributeName,
                          nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.title = title;
}

/********************* 弹出半透明控制器 ************************************/
- (void)presentTranslucentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion
{
    
    // 用于显示这个视图控制器的视图是否覆盖当视图控制器或其后代提供了一个视图控制器。默认为NO
    self.definesPresentationContext = YES;
    // 设置页面切换效果
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    // UIModalPresentationOverCurrentContext能在当前VC上present一个新的VC同时不覆盖之前的内容
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    
    [self presentViewController:viewControllerToPresent animated:flag completion:^{
        
        self.presentedViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
    
    if (completion) {
        
        completion();
    }
    
}



@end
