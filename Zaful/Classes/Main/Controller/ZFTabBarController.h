//
//  ZFTabBarController.h
//  Dezzal
//
//  Created by 7FD75 on 16/7/21.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFNavigationController.h"

@interface ZFTabBarController : UITabBarController

@property (nonatomic, strong) ZFNavigationController *lastNavController;
- (ZFNavigationController*)navigationControllerWithMoudle:(TabBarIndex)moudle;
- (void)setModel:(TabBarIndex)model;

@end
