//
//  CouponViewController.m
//  Zaful
//
//  Created by zhaowei on 2017/6/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponItemViewController.h"

@interface CouponViewController ()

@end

@implementation CouponViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ZFLocalizedString(@"MyCoupon_VC_Title",nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        NSArray *viewControllers = @[[CouponItemViewController class], [CouponItemViewController class], [CouponItemViewController class]];
        NSArray *titles = @[ZFLocalizedString(@"MyCoupon_Coupon_Unused",nil), ZFLocalizedString(@"MyCoupon_Coupon_Used",nil), ZFLocalizedString(@"MyCoupon_Coupon_Expired",nil)];

        self.viewControllerClasses = viewControllers;
        self.titles = titles;
        self.keys = @[@"kind",@"kind",@"kind"].mutableCopy;
        if ([SystemConfigUtils isRightToLeftShow]) {
            self.values = @[@"3",@"2",@"1"].mutableCopy;
            titles = @[ZFLocalizedString(@"MyCoupon_Coupon_Used",nil), ZFLocalizedString(@"MyCoupon_Coupon_Expired",nil), ZFLocalizedString(@"MyCoupon_Coupon_Unused",nil)];
            self.selectIndex = titles.count - 1;
        } else {
            self.values = @[@"1",@"2",@"3"].mutableCopy;
            self.selectIndex = 0;
        }
        
        self.pageAnimatable = YES;
        self.postNotification = YES;
        self.bounces = YES;
        self.titleSizeNormal = 16;
        self.titleSizeSelected = 16;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
        
        self.titleColorSelected = ZFCOLOR(255, 168, 0, 1.0);
        self.titleColorNormal = ZFCOLOR(153, 153, 153, 1.0);
        self.progressColor = ZFCOLOR(255, 168, 0, 1.0);
        self.progressHeight = 2;
    }
    
    return self;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = ZFCOLOR_WHITE;
    return CGRectMake(0, 0, KScreenWidth, 48);
    
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, KScreenWidth, KScreenHeight - originY - NAVBARHEIGHT - STATUSHEIGHT);
}




@end
