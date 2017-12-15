//
//  AppDelegate.h
//  Zaful
//
//  Created by Y001 on 16/9/13.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFTabBarController.h"
#import <AppsFlyerLib/AppsFlyerTracker.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,AppsFlyerTrackerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) ZFTabBarController *tabBarVC;
    
// 切换语言时需要重置
- (void)requestRateAndProfile:(void (^)())success failure:(void (^)())failure;
- (void)goHome;
- (void)configurFireBase;
    
@end

