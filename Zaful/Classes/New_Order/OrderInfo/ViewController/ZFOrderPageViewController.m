//
//  ZFOrderPageViewController.m
//  Zaful
//
//  Created by TsangFa on 13/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderPageViewController.h"
#import "ZFOrderInfoViewController.h"
#import "ZFOrderCheckInfoModel.h"
#import "AppDelegate.h"

@interface ZFOrderPageViewController ()

@property (nonatomic, assign) BOOL firstEnter;

@end

@implementation ZFOrderPageViewController

#pragma mark - Life cycle
- (instancetype)init {
    if (self = [super init]) {
        self.pageAnimatable = YES;
        self.bounces = YES;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 16;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
        self.automaticallyCalculatesItemWidths = YES;
        self.titleColorSelected = ZFCOLOR(183, 96, 42, 1.0);
        self.titleColorNormal = ZFCOLOR(153, 153, 153, 1.0);
        self.progressColor = ZFCOLOR(183, 96, 42, 1.0);
        self.progressHeight = 2;
        self.preloadPolicy = WMPageControllerPreloadPolicyNeighbour;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.firstEnter) {
        [ZFAnalytics screenViewQuantityWithScreenName:@"Order Information"];
    }
    self.firstEnter = YES;
    
    /**
     *  此方法是为了防止控制器的title发生偏移，造成这样的原因是因为返回按钮的文字描述占位
     */
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    
    if ([viewControllerArray containsObject:self]) {
        long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
        UIViewController *previous;
        if (previousViewControllerIndex >= 0) {
            previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
            previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:nil];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZFLocalizedString(@"CartOrderInfo_VC_Title",nil);
}

#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.pages.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    ZFOrderInfoViewController *orderVC =  [[ZFOrderInfoViewController alloc] init];
    ZFOrderCheckInfoModel *model = self.pages[index];
    orderVC.paymentUIType = PaymentUITypeCombine;
    orderVC.payCode = PayCodeTypeCombine;
    orderVC.checkOutModel = model.order_info;
    return orderVC;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NSArray *nameArray = @[ZFLocalizedString(@"ZFPaymentCod", nil),ZFLocalizedString(@"ZFPaymentOnline", nil)];
    return nameArray[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = ZFCOLOR_WHITE;
    return CGRectMake(0, 0, KScreenWidth, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, KScreenWidth, KScreenHeight - originY - NAVBARHEIGHT - STATUSHEIGHT);
}


@end
