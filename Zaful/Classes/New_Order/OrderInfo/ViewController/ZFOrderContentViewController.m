//
//  ZFOrderInformationViewController.m
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderContentViewController.h"
#import "ZFOrderInfoViewController.h"
#import "ZFOrderPageViewController.h"
#import "ZFPayMethodsViewController.h"
#import "ZFOrderCheckInfoModel.h"
#import "ZFOrderCheckInfoDetailModel.h"
#import "ZFPayMethodsViewController.h"

@interface ZFOrderContentViewController ()<UINavigationControllerDelegate>
@end

@implementation ZFOrderContentViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZFLocalizedString(@"CartOrderInfo_VC_Title",nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadSubViewController];
    self.navigationController.delegate = self;
}


#pragma mark - Private method
- (void)adapterSubViewControllerWithIndex:(NSInteger)paymentUIType {
    ZFOrderInfoViewController *singleOrderVC = [[ZFOrderInfoViewController alloc] init];
    if (self.paymentUIType == PaymentUITypeSingle) {
        singleOrderVC.paymentUIType = self.paymentUIType;
        singleOrderVC.payCode       = self.payCode;
        singleOrderVC.checkOutModel = self.checkoutModel;
    }

    ZFOrderPageViewController *combineOrderVC = [[ZFOrderPageViewController alloc] init];
    combineOrderVC.pages        = self.pages;
    
    switch (paymentUIType) {
        case PaymentUITypeSingle:
        {
            [self addChildViewController:singleOrderVC];
            [self addChildViewController:combineOrderVC];
            [singleOrderVC didMoveToParentViewController:self];
            [self.view addSubview:singleOrderVC.view];
        }
            break;
        case PaymentUITypeCombine:
        {
            [self addChildViewController:combineOrderVC];
            [self addChildViewController:singleOrderVC];
            [combineOrderVC didMoveToParentViewController:self];
            [self.view addSubview:combineOrderVC.view];
        }
            break;
    }
}

- (void)loadSubViewController {
    switch (self.paymentProcessType) {
        // 直接走老流程,就是 ZFOrderInfoViewController , ZFPayMethodsViewController 切换
        case PaymentProcessTypeOld:
        {
            ZFOrderInfoViewController *singleOrderVC = [[ZFOrderInfoViewController alloc] init];
            singleOrderVC.paymentUIType = self.paymentUIType;
            singleOrderVC.payCode       = self.payCode;
            singleOrderVC.checkOutModel = self.checkoutModel;
            [self addChildViewController:singleOrderVC];
            [singleOrderVC didMoveToParentViewController:self];
            
            ZFPayMethodsViewController *payMethodsVC = [[ZFPayMethodsViewController alloc] init];
            [self addChildViewController:payMethodsVC];
            
            [self.view addSubview:singleOrderVC.view];
        }
            break;
        // 走新流程,就是 ZFOrderInfoViewController , ZFOrderPageViewController 切换
        case PaymentProcessTypeNew:
        {
            [self adapterSubViewControllerWithIndex:self.paymentUIType];
        }
            break;
    }
}

#pragma mark -UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.navigationController.viewControllers.count <= 2) {
        if ([viewController isKindOfClass:ZFPayMethodsViewController.class]) {
            return;
        }
    }
}

@end
