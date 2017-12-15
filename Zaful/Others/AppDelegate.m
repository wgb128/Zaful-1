 //
//  AppDelegate.m
//  Zaful
//
//  Created by Y001 on 16/9/13.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "AppDelegate.h"
#import "InitializeApi.h"
#import "ExchangeApi.h"
#import "HotwordSearchApi.h"
#import "FilterApi.h"
#import "ProfileInfoApi.h"
#import "ZFHomePageMenuApi.h"
#import "ZFHomePageMenuModel.h"
#import "LaunchStatusViewController.h"
#import "FilterManager.h"
#import "RateModel.h"
#import <UserNotifications/UserNotifications.h>
#import "JumpModel.h"
#import "JumpManager.h"
#import "BannerManager.h"
#import "BannerModel.h"
#import "CacheFileManager.h"
#import "ZFHomePageViewController.h"
#import "ZFStartLoadingViewController.h"
#import "FilterManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <Bolts/Bolts.h>

#import <Firebase/Firebase.h>

#ifdef BuglyEnabled
#   import <Bugly/Bugly.h>
#endif

#ifdef LeandCloudEnabled
#   import <AVOSCloud/AVOSCloud.h>
#endif
#ifdef AppsFlyerAnalyticsEnabled
#   import <AppsFlyerLib/AppsFlyerTracker.h>
#ifdef googleAnalyticsV3Enabled
#   import "GAI.h"
#   import "GAITracker.h"
#   import "GAIDictionaryBuilder.h"

#endif
#endif

#import "GuideController.h"

#import "DesEncrypt.h"

static NSString * const kClientID = @"985806194647-prpmfvlv00igfvdvjic2l23d1mnefdm6.apps.googleusercontent.com";

@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    return YES;
}
@end

@interface AppDelegate ()
@property (nonatomic, assign) BOOL isDeepLinkCalling;
@property (nonatomic, assign) BOOL isStartLoadingCalling;
@property (nonatomic, strong) GuideController * guideController;
@property (nonatomic, strong) ZFStartLoadingViewController *loadVC;
@end

@implementation AppDelegate
- (void)requestNecessary {
    @weakify(self)
    [self requestRateAndProfile:^{
        @strongify(self)
        // 谷歌统计
        [ZFAnalytics screenViewQuantityWithScreenName:@"Launch"];
        self.tabBarVC =  [[ZFTabBarController alloc] init];
        self.window.rootViewController = self.tabBarVC;
        [self applicationDidFinishLaunchingAction];
        [self applicationDidFinishLaunchingBannerAction];
    } failure:^{
        LaunchStatusViewController *vc = [LaunchStatusViewController new];
        @strongify(self)
        @weakify(self)
        vc.reloadBlock = ^{
            @strongify(self)
            [self requestNecessary];
        };
        self.window.rootViewController = vc;
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef BuglyEnabled
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.reportLogLevel = BuglyLogLevelWarn;
    config.debugMode = YES;
    config.blockMonitorEnable = YES;
    [Bugly startWithAppId:kBuglyAppId
#ifdef DEBUG
        developmentDevice:YES
#endif
                   config:config];
#endif
    
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    //全局监听网络状态
    [NoNetworkReachabilityManager shareManager].openReachability = YES;
    [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kStartLaunching];
    //清除webView缓存
    NSUserDefaults *versionDefaults = [NSUserDefaults standardUserDefaults];
    NSString * version = [versionDefaults stringForKey: APPVIERSION];
    if ([NSStringUtils isEmptyString:version] || ![version isEqualToString:ZFSYSTEM_VERSION]) {
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        [versionDefaults setObject:ZFSYSTEM_VERSION forKey:APPVIERSION];
        [CacheFileManager clearDatabaseCache:[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    }
    //货到付款临时数据清空
    [FilterManager removeCOD];
    [FilterManager removeCurrency];
    
    //预发布处理
    if (preRelease) {
        [self addCookie];
    } else {
        [self deleteCookie];
    }
    
    // 语言切换设置
    [ZFLocalizationString shareLocalizable].isSuppoutAppSettingLocalizable = YES;

    if ([SystemConfigUtils isCanRightToLeftShow]) {
        [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    } else {
        if (ISIOS9) {
            [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        }
    }
    
#pragma mark - 初始化leancloud
    [self initThirdPartObjectsWithOptions:launchOptions];
    [self registerForRemoteNotification];
    
    [SYNetworkConfig sharedInstance].baseURL = AppBaseURL;
    
    /**
     *  facebook 登录
     */
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    /**
     *  google+登录支持
     */
    [GIDSignIn sharedInstance].clientID = kClientID;
    
    if (launchOptions[UIApplicationLaunchOptionsURLKey] == nil) {
        [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
            if (error) {
                NSLog(@"Received error while fetching deferred app link %@", error);
            }
            if (url) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
    }
    
    // 谷歌统计
    [[ZFAnalyticsTimeManager sharedManager] logTimeWithEventName:kFinishLaunching];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app当前版本
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.window.rootViewController = [[UIViewController alloc] init];
    id requestJSON = [[NSUserDefaults standardUserDefaults] objectForKey:kStartLoadingInfo];
    NSArray *startLoad = requestJSON[@"result"];
    if (startLoad && startLoad.count > 0) {

        BannerModel *model = [BannerModel yy_modelWithJSON:requestJSON[@"result"][0]];
        self.loadVC = [[ZFStartLoadingViewController alloc] init];
        self.loadVC.loadUrl = model.image;
        @weakify(self);
        self.loadVC.startLoadingSkipCompletionHandler = ^{
            @strongify(self);
            [self requestNecessary];
            [self.loadVC removeFromParentViewController];
        };
        
        self.loadVC.startLoadingJumpBannerCompletionHandler = ^{
            @strongify(self);
            self.isStartLoadingCalling = YES;
            
            [self requestNecessary];
        };
        self.window.rootViewController = self.loadVC;
    } else {
        //获取当前设备语言
        NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *languageName = [appLanguages objectAtIndex:0];
        if ([languageName hasPrefix:@"en"] || [languageName hasPrefix:@"ar"]) {
            languageName = [languageName substringToIndex:2];
            if (![NSStringUtils isEmptyString:version] && [appVersion isEqualToString:version]) {
                //请求必要数据
                [self requestNecessary];
                
            } else {
                NSMutableArray *coverImageNames = [NSMutableArray array];
                if (IPHONE_4X_3_5) {
                    for (int i = 1; i < 4; ++i) {
                        [coverImageNames addObject:[NSString stringWithFormat:@"%@_640x750_%d", languageName, i]];
                    }
                }else if (IPHONE_5X_4_0) {
                    for (int i = 1; i < 4; ++i) {
                        [coverImageNames addObject:[NSString stringWithFormat:@"%@_640x922_%d", languageName, i]];
                    }
                }else if (IPHONE_6X_4_7) {
                    for (int i = 1; i < 4; ++i) {
                        [coverImageNames addObject:[NSString stringWithFormat:@"%@_750x1080_%d", languageName, i]];
                    }
                }else if (IPHONE_6P_5_5) {
                    for (int i = 1; i < 4; ++i) {
                        [coverImageNames addObject:[NSString stringWithFormat:@"%@_1242x1788_%d", languageName, i]];
                    }
                } else if (IPHONE_X_5_15) {
                    for (int i = 1; i < 4; ++i) {
                        [coverImageNames addObject:[NSString stringWithFormat:@"%@_1125x1620_%d", languageName, i]];
                    }
                }
                
                self.guideController = [[GuideController alloc] initWithCoverImageNames:coverImageNames];
                self.window.rootViewController = self.guideController;
                @weakify(self);
                self.guideController.didSelectedEnter = ^() {
                    @strongify(self);
                    [self.guideController removeFromParentViewController];
                    self.guideController = nil;
                    [versionDefaults setObject:appVersion forKey:APPVIERSION];
                    //请求必要数据
                    [self requestNecessary];
                };
            }
        } else {
            [self requestNecessary];
        }
    }
    

    /**
     *  IQ键盘设置
     */
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

    
    
    
    return YES;
}



- (void)goHome {
    self.tabBarVC =  [[ZFTabBarController alloc] init];
    self.window.rootViewController = self.tabBarVC;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    /**
     *  AppsFlyer 统计
     */
    // Track Installs, updates & sessions(app opens) (You must include this API to enable tracking)
#ifdef AppsFlyerAnalyticsEnabled
    // init AppsFlyer
    [AppsFlyerTracker sharedTracker].appleAppID = kCfgAppId;//[NSString stringWithFormat:@"id%@", kCfgAppId];
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = kAppsFlyerKey;
    
    // load the conversion data
    [AppsFlyerTracker sharedTracker].delegate = self;
    
    // track launch
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
#endif
    
    [FBSDKAppEvents activateApp];
    [ZFFireBaseAnalytics appOpen];
}

- (void)applicationDidFinishLaunchingAction {
    // 执行还没执行的DeepLink
    if (_isDeepLinkCalling) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSData *data = [userDefault objectForKey:DeepLinkModel];
        JumpModel *jumpModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self applyDeepLinkCallingWithJumpModel:jumpModel];
    }
    
    // 当前时间截
    NSString *currTimeStr = [NSStringUtils getCurrentTimestamp];
    NSInteger currTime = [currTimeStr integerValue];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLaunching"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:currTime forKey:@"kAPPInstallTime"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunching"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)applicationDidFinishLaunchingBannerAction {
    if (self.isStartLoadingCalling) {
        id requestJSON = [[NSUserDefaults standardUserDefaults] objectForKey:kStartLoadingInfo];
        BannerModel *model = [BannerModel yy_modelWithJSON:requestJSON[@"result"][0]];
        [self applyStartLoadingCallingWithBannerModel:model];
    }
}

void UncaughtExceptionHandler(NSException *exception) {
#ifdef googleAnalyticsV3Enabled
    @try {
//        ZFLog(@"Google Analytics cathed exception:%@", exception.description);
    }
    @catch (NSException *exception) {
        id tracker = [[GAI sharedInstance] defaultTracker];
        // isFatal (required). NO indicates non-fatal exception.
        GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createExceptionWithDescription:exception.description withFatal:@NO];
        [tracker send:[builder build]];
    }
#endif
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [NoNetworkReachabilityManager shareManager].openReachability = NO;
}
/**
 *  错误统计
 *
 *  @param exc
 */
- (void)statisticException:(NSException *)exc {
    
}

- (void)requestRateAndProfile:(void (^)())success failure:(void (^)())failure {
    
    NSArray *requestArray = nil;
    if ([AccountManager sharedManager].isSignIn) {
        requestArray = @[[[InitializeApi alloc] init],[[ExchangeApi alloc] init],[[FilterApi alloc] init],[[HotwordSearchApi alloc] init], [[ZFHomePageMenuApi alloc] init], [[ProfileInfoApi alloc] init]];
    } else {
        requestArray = @[[[InitializeApi alloc] init],[[ExchangeApi alloc] init],[[FilterApi alloc] init],[[HotwordSearchApi alloc] init], [[ZFHomePageMenuApi alloc] init]];
    }
    SYBatchRequest *batchRequest = [[SYBatchRequest alloc] initWithRequestArray:requestArray enableAccessory:NO];
    [MBProgressHUD showLoadingView:nil];
    [batchRequest startWithBlockSuccess:^(SYBatchRequest *batchRequest) {
        [MBProgressHUD hideHUD];
        NSArray *requests = batchRequest.requestArray;
        
        // 这个是版本更新接口
        InitializeApi *initializeApi = (InitializeApi *)requests[0];
        NSDictionary *initDict = [NSStringUtils desEncrypt:initializeApi api:NSStringFromClass(initializeApi.class)];
        
        if ([initDict[@"statusCode"] integerValue] == 200){
            //这里把初始化数据存到本地
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:initDict[@"result"] forKey:kInitialize];
            [user synchronize];
        }
        
        ExchangeApi *exchangeApi = (ExchangeApi *)requests[1];
        
        NSDictionary *rateDict = [NSStringUtils desEncrypt:exchangeApi api:NSStringFromClass(exchangeApi.class)];
        
        if ([rateDict[@"statusCode"] integerValue] == 200){
            
            NSArray *array = [NSArray yy_modelArrayWithClass:[RateModel class] json:rateDict[@"result"]];
            [ExchangeManager saveLocalExchange:array];
            
        }
        
        FilterApi *filterApi = (FilterApi *)requests[2];
        
        NSDictionary *filterDict = [NSStringUtils desEncrypt:filterApi api:NSStringFromClass(filterApi.class)];
        
        if ([filterDict[@"statusCode"] integerValue] == 200){
            [FilterManager saveLocalFilter:filterDict[@"result"]];
        }
        
        HotwordSearchApi *searchApi = (HotwordSearchApi *)requests[3];
        id requestJSON = [NSStringUtils desEncrypt:searchApi api:NSStringFromClass(searchApi.class)];
        NSArray *hotwordArray = requestJSON[@"result"];
        [[NSUserDefaults standardUserDefaults] setValue:hotwordArray forKey:KHotwordSearchKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        ZFHomePageMenuApi *channelMenuApi = (ZFHomePageMenuApi *)requests[4];
        NSInteger channelStatusCode = [channelMenuApi.responseJSONObject ds_integerForKey:@"statusCode"];
        NSArray *resultArray = [channelMenuApi.responseJSONObject ds_arrayForKey:@"result"];
        // 成功
        if (channelStatusCode == 200) {
            [ZFHomePageMenuModel deleteAllModels];
            if ([SystemConfigUtils isRightToLeftShow]) {
                for (NSInteger i = 0; i < resultArray.count; i++) {
                    NSInteger realIndex = resultArray.count - 1 - i;
                    NSDictionary *modelDictionary = resultArray[realIndex];
                    ZFHomePageMenuModel *model = [ZFHomePageMenuModel yy_modelWithJSON:modelDictionary];
                    [ZFHomePageMenuModel instertWithModel:model];
                }
            } else {
                for (NSDictionary *modelDictionary in resultArray) {
                    ZFHomePageMenuModel *model = [ZFHomePageMenuModel yy_modelWithJSON:modelDictionary];
                    [ZFHomePageMenuModel instertWithModel:model];
                }
            }
        }
        
        if (requestArray.count == 6) {
            
            ProfileInfoApi * userApi = (ProfileInfoApi *)requests[5];
            
            NSDictionary *loginDict = [NSStringUtils desEncrypt:userApi api:NSStringFromClass(userApi.class)];
            
            if ([loginDict[@"statusCode"] integerValue] == 200) {
                AccountModel *userModel = [AccountModel yy_modelWithJSON:loginDict[@"result"][@"user_info"]];
                //更新单例数据
                if (userModel != nil) {
                    [[AccountManager sharedManager] updateUserInfo:userModel];
                } else {
                    [[AccountManager sharedManager] clearUserInfo];
                }
            }
        }
        if (success) {
            success();
        }
    } failure:^(SYBatchRequest *batchRequest) {
        [MBProgressHUD hideHUD];
        for (SYBaseRequest *api in batchRequest.requestArray) {
            ZFLog(@"\n-------------------------- 错误日志 --------------------------\n接口:%@\n状态码:%ld\n报错信息:%@",NSStringFromClass(api.class),api.responseStatusCode,api.responseString);
        }
        
        if (failure) {
            failure();
        }
    }];
}

/**
 *  添加cookie
 */
- (void)addCookie {
    
    NSHTTPCookie *zaful_cookie = [[NSHTTPCookie alloc]initWithProperties:@{
                                                                     NSHTTPCookieName:@"staging",
                                                                     NSHTTPCookieValue:@"true",
                                                                     NSHTTPCookieDomain:@".zaful.com",
                                                                     NSHTTPCookiePath:@"/",
                                                                     }];
    

    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [storage setCookie:zaful_cookie];

}


- (void)deleteCookie {
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc]initWithProperties:@{
                                                                     NSHTTPCookieName:@"staging",
                                                                     NSHTTPCookieValue:@"true",
                                                                     NSHTTPCookieDomain:@".zaful.com",
                                                                     NSHTTPCookiePath:@"/",
                                                                     }];
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    if ([storage.cookies containsObject:cookie]) {
        [storage deleteCookie:cookie];
    }
}

#pragma mark - LeandCloud初始化
- (void)configurFireBase {
    NSString *googleServicePath;
    if ([SystemConfigUtils isRightToLeftShow]) {
        googleServicePath = [[NSBundle mainBundle] pathForResource:@"GoogleService-Info-Ar" ofType:@"plist"];
    } else {
        googleServicePath = [[NSBundle mainBundle] pathForResource:@"GoogleService-Info" ofType:@"plist"];
    }
#ifdef DEBUG
    if ([SystemConfigUtils isRightToLeftShow]) {
        googleServicePath = [[NSBundle mainBundle] pathForResource:@"GoogleService-Info-Ar-Debug" ofType:@"plist"];
    } else {
        googleServicePath = [[NSBundle mainBundle] pathForResource:@"GoogleService-Info-Debug" ofType:@"plist"];
    }
#endif
    
    FIROptions *firOptions = [[FIROptions alloc] initWithContentsOfFile:googleServicePath];
    [FIRApp configureWithOptions:firOptions];
}
    
-(void)initThirdPartObjectsWithOptions:(NSDictionary *)launchOptions {
    // FireBase 统计
    [self configurFireBase];
    
    /**
     *  AppsFlyer 统计
     */
#ifdef AppsFlyerAnalyticsEnabled
    
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = kAppsFlyerKey;
    [AppsFlyerTracker sharedTracker].appleAppID = kCfgAppId;
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    
#ifdef DEBUG
    [AppsFlyerTracker sharedTracker].isDebug = YES;
     [AppsFlyerTracker sharedTracker].useUninstallSandbox = NO;
#endif
    
#endif
    
    /**
     * GA统计
     */
#ifdef googleAnalyticsV3Enabled
    
    [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    if (!isFormalhost) {
        [GAI sharedInstance].trackUncaughtExceptions = YES;
    }else{
        [GAI sharedInstance].trackUncaughtExceptions = NO;
    }
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 5;
    
    //    [[GAI sharedInstance] setDispatchInterval:kGaDispatchPeriod];
    
    //The SDK provides a dryRun flag that when set, prevents any data from being sent to Google Analytics. The dryRun flag should be set whenever you are testing or debugging an implementation and do not want test data to appear in your Google Analytics reports.
    [[GAI sharedInstance] setDryRun:NO];
    //The GAILogger protocol is provided to handle useful messages from the SDK at these levels of verbosity: error, warning, info, and verbose.
    //[[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
#endif
    
#ifdef LeandCloudEnabled
    // 设置美国节点
    [AVOSCloud setServiceRegion:AVServiceRegionUS];
    
    [AVOSCloud setApplicationId:kLeanCloudApplicationID clientKey:kLeanCloudClientKey];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    ZFLog(@"%@----------------------%@",kLeanCloudApplicationID,kLeanCloudClientKey);
    
    // 推送跳转
    if (launchOptions)
    {
        NSDictionary *userInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
        if (![userInfo isKindOfClass:[NSNull class]])
        {
            //接收保存推送摧付参数
            [[AppsFlyerTracker sharedTracker] handlePushNotification:userInfo];
            [self saveNotificationsPaymentParmaters:userInfo];
            
            NSString* urlStr = NullFilter(userInfo[@"url"]);
            if (urlStr.length > 0)
            {
                urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlStr];
                UIApplication *application = [UIApplication sharedApplication];
                
                if ([url.scheme.lowercaseString isEqualToString:@"zaful"])
                {
                    [self application:application deepLinkCallingWithURL:url sourceApplication:nil annotation:nil];
                }
            }
        }
    }
#endif
    
}

#pragma mark - LeandCloud注册授权
-(void)registerForRemoteNotification {
    // iOS10 兼容
    if (IPHONE_ZFSYSTEM_VERSION >= 10.0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 使用 UNUserNotificationCenter 来管理通知
            UNUserNotificationCenter *uncenter = [UNUserNotificationCenter currentNotificationCenter];
            // 监听回调事件
            //iOS10 使用以下方法注册，才能得到授权
            [uncenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionBadge+UNAuthorizationOptionSound)
                                    completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                                        //TODO:授权状态改变
                                        ZFLog(@"%@" , granted ? @"授权成功" : @"授权失败");
                                    }];
            // 获取当前的通知授权状态, UNNotificationSettings
            [uncenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                
                if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                    ZFLog(@"未选择");
                } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                    ZFLog(@"未授权");
                } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                    ZFLog(@"已授权");
                }
            }];
        });
    }else{
        UIApplication *application = [UIApplication sharedApplication];
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRegisterNotification"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"promotionStatus"];        // 默认开启
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"orderMessageStatus"];     // 默认开启
    [[NSUserDefaults standardUserDefaults] synchronize];
#ifdef LeandCloudEnabled
    NSInteger user = [[[AccountManager sharedManager] userId] integerValue];
    AVInstallation *currentInstallationLeandcloud = [AVInstallation currentInstallation];
    [currentInstallationLeandcloud setObject:@(user) forKey:@"userId"];
    [currentInstallationLeandcloud setObject:@"YES" forKey:@"promotions"];
    [currentInstallationLeandcloud setObject:@"YES" forKey:@"orderMessages"];
    [currentInstallationLeandcloud setObject:[AppsFlyerTracker sharedTracker].getAppsFlyerUID forKey:@"appsFlyerId"];
    [currentInstallationLeandcloud setObject:[ZFLocalizationString shareLocalizable].nomarLocalizable forKey:@"language"];
    [currentInstallationLeandcloud saveInBackground];
#endif
}

#pragma mark - Notifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
#ifdef LeandCloudEnabled
    AVInstallation *currentInstallation1 = [AVInstallation currentInstallation];
    [currentInstallation1 setDeviceTokenFromData:deviceToken];
    [currentInstallation1 saveInBackground];
#endif
    
    [[AppsFlyerTracker sharedTracker] registerUninstall:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[AppsFlyerTracker sharedTracker] handlePushNotification:userInfo];
    //接收保存推送摧付参数
    [self saveNotificationsPaymentParmaters:userInfo];
    
    NSString *urlStr = NullFilter(userInfo[@"url"]);
    if (urlStr.length > 0)
    {
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        ZFLog(@"notifications_url:%@", urlStr);
        NSURL *url = [NSURL URLWithString:urlStr];
        
        if ([url.scheme.lowercaseString isEqualToString:@"zaful"])
        {
            [self application:application deepLinkCallingWithURL:url sourceApplication:@"open" annotation:nil];
        }else
        {
#ifdef LeandCloudEnabled
            [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
#endif
        }
    }
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    application.applicationIconBadgeNumber = 0;

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL handled = YES;
    if ([url.scheme.lowercaseString isEqualToString:@"fb1396335280417835"]) {//799078940226799  fb500588386792107
        handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                 openURL:url
                                                       sourceApplication:sourceApplication
                                                              annotation:annotation
                   ];
    } else if ([url.scheme.lowercaseString isEqualToString:@"zaful"]) {
        handled = [self application:application deepLinkCallingWithURL:url sourceApplication:sourceApplication annotation:annotation];
    }else{
        handled = [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
        [[AppsFlyerTracker sharedTracker] handleOpenURL:url sourceApplication:sourceApplication withAnnotation:annotation];
    return handled;
}


#pragma mark - deepLink
-(BOOL)application:(UIApplication *)application deepLinkCallingWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    _isDeepLinkCalling = YES;
    NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
    
    ZFLog(@"url = %@ \n query = %@ \n host = %@", url.absoluteString, url.query, url.host);
    if (url.query)
    {
        NSString *queryStr = [url.query decodeFromPercentEscapeString:url.query];
        NSArray *arr = [queryStr componentsSeparatedByString:@"&"];
        for (NSString *str in arr)
        {
            NSRange range = [str rangeOfString:@"="];
            if (range.location != NSNotFound) {
                NSString *key   = [str substringToIndex:range.location];
                NSString *value = [str substringFromIndex:range.location+1];
                [md setObject:value forKey:key];
            }
        }
    }
    
    JumpModel *jumpModel = [[JumpModel alloc] init];
    jumpModel.actionType = JumpDefalutActionType;
    jumpModel.url  = @"";
    jumpModel.name = @"";
    if (md.count > 0) {
        jumpModel.actionType = [md[@"actiontype"] integerValue];
        jumpModel.url        = NullFilter(md[@"url"]);
        jumpModel.name       = NullFilter(md[@"name"]);
    }
    
    // 如果是推送跳转，则先提示用户是否打开
    if ([NullFilter(md[@"source"]) isEqualToString:@"notifications"] && [sourceApplication isEqualToString:@"open"])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notifications" message:jumpModel.name preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:ZFLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            _isDeepLinkCalling = NO;
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:ZFLocalizedString(@"AppDelegate_Open",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (jumpModel.actionType  == JumpDefalutActionType) {
                _isDeepLinkCalling = NO;
            }
            if (_isDeepLinkCalling)
            {
                // 判断是否已创建tabbar
                if (_tabBarVC.viewControllers.count>0) {
                    [self applyDeepLinkCallingWithJumpModel:jumpModel];
                }else{
                    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:jumpModel];
                    [us setObject:data forKey:DeepLinkModel];
                    [us synchronize];
                }
            }
        }]];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:^{}];
    }else{
        if (jumpModel.actionType  == JumpDefalutActionType) {
            _isDeepLinkCalling = NO;
        }
        if (_isDeepLinkCalling)
        {
            // 判断是否已创建tabbar
            if (_tabBarVC.viewControllers.count>0) {
                [self applyDeepLinkCallingWithJumpModel:jumpModel];
            }else{
                NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:jumpModel];
                [us setObject:data forKey:DeepLinkModel];
                [us synchronize];
            }
        }
    }
    
    return YES;
}

// Appflyer推广跳转处理
-(void)application:(UIApplication *)application deepLinkCallingWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication params:(id)params {
    _isDeepLinkCalling = YES;
    NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
    
//    ZFLog(@"url = %@ \n query = %@ \n host = %@", url.absoluteString, url.query, url.host);
    if (url.query)
    {
        NSString *queryStr = [url.query decodeFromPercentEscapeString:url.query];
        NSArray *arr = [queryStr componentsSeparatedByString:@"&"];
        for (NSString *str in arr)
        {
            NSRange range = [str rangeOfString:@"="];
            if (range.location != NSNotFound) {
                NSString *key   = [str substringToIndex:range.location];
                NSString *value = [str substringFromIndex:range.location+1];
                [md setObject:value forKey:key];
            }
        }
    }
    
    JumpModel *jumpModel = [[JumpModel alloc] init];
    jumpModel.actionType = JumpDefalutActionType;
    jumpModel.url  = @"";
    jumpModel.name = @"";
    if (md.count>0) {
        jumpModel.actionType = [md[@"actiontype"] integerValue];
        jumpModel.url        = NullFilter(md[@"url"]);
        jumpModel.name       = NullFilter(md[@"name"]);
    }
    if ([NSStringUtils isEmptyString:jumpModel.url]) jumpModel.url = NullFilter(params);
    
    if (jumpModel.actionType  == JumpDefalutActionType) {
        _isDeepLinkCalling = NO;
    }
    if (_isDeepLinkCalling)
    {
        // 判断是否已创建tabbar
        if (_tabBarVC.viewControllers.count > 0) {
            [self applyDeepLinkCallingWithJumpModel:jumpModel];
        }else{
            NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:jumpModel];
            [us setObject:data forKey:DeepLinkModel];
            [us synchronize];
        }
    }
}

-(void)applyDeepLinkCallingWithJumpModel:(JumpModel *)jumpModel {
    _isDeepLinkCalling = NO;
    [_tabBarVC setModel:TabBarIndexHome];
    ZFNavigationController *nav = [_tabBarVC navigationControllerWithMoudle:TabBarIndexHome];
    if (nav) {
        if (nav.viewControllers.count > 1) {
            [nav popToRootViewControllerAnimated:NO];
        }
        
        ZFHomePageViewController *homeViewController = nav.viewControllers[0];
        [JumpManager doJumpActionTarget:homeViewController withJumpModel:jumpModel];
    }
}

- (void)applyStartLoadingCallingWithBannerModel:(BannerModel *)bannerModel {
    _isStartLoadingCalling = NO;
    [_tabBarVC setModel:TabBarIndexHome];
    ZFNavigationController *nav = [_tabBarVC navigationControllerWithMoudle:TabBarIndexHome];
    if (nav) {
        if (nav.viewControllers.count > 1) {
            [nav popToRootViewControllerAnimated:NO];
        }
        
        ZFHomePageViewController *homeViewController = nav.viewControllers[0];
        [BannerManager doBannerActionTarget:homeViewController withBannerModel:bannerModel];
    }
}

#pragma mark - AppsFlyerTrackerDelegate
-(void)onConversionDataReceived:(NSDictionary*) installData {       // AppsFlyer推广数据回调
    id status = [installData objectForKey:@"af_status"];
    if([status isEqualToString:@"Non-organic"]) {
        NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
        if ([us boolForKey:FIRST_LOAD]) return;
        id sourceID = [installData objectForKey:@"media_source"];   // 推广来源
        id campaign = [installData objectForKey:@"campaign"];       // 营销数据
        id lkid     = [installData objectForKey:@"af_sub1"];        // lkid
        id urlStr   = [installData objectForKey:@"af_dp"];          // DeepLink跳转数据
        id param      = [installData objectForKey:@"url"];          // DeepLink跳转参数
        id adId     = [installData objectForKey:@"ad_id"];
        
        [us setBool:YES forKey:FIRST_LOAD];
        [us setObject:sourceID forKey:MEDIA_SOURCE];
        [us setObject:campaign forKey:CAMPAIGN];
        [us setObject:lkid forKey:LKID];
        [us setObject:adId forKey:ADID];
        [us setObject:installData forKey:APPFLYER_ALL_PARAMS];
        [us synchronize];
        
        if (![NSStringUtils isEmptyString:urlStr]) {
            NSURL *url = [NSURL URLWithString:urlStr];
            [self application:nil deepLinkCallingWithURL:url sourceApplication:nil params:param];
        }
        
        ZFLog(@"This is a none organic install. installData: %@",installData);
        
    } else if([status isEqualToString:@"Organic"]) {
//        ZFLog(@"This is an organic install.");
    }
}

-(void)onConversionDataRequestFailure:(NSError *) error {
    NSLog(@"%@",error);
}

- (void)onAppOpenAttribution:(NSDictionary*)attributionData {
    
    NSString *link = [attributionData ds_stringForKey:@"link"];
    NSArray *linkArray = [link componentsSeparatedByString:@"af_dp="];
    
    NSURL *url;
    if (linkArray.count > 1) {
        url = [NSURL URLWithString:[linkArray lastObject]];
    }
    
    if ([url.scheme.lowercaseString isEqualToString:@"zaful"]) {
        [self application:nil deepLinkCallingWithURL:url sourceApplication:@"open" annotation:nil];
    }
}

- (void)saveNotificationsPaymentParmaters:(NSDictionary *)userInfo {
    NSDictionary *parmaters = userInfo[@"af"];
    if ([parmaters isKindOfClass:[NSDictionary class]]) {
        NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
        [us setObject:parmaters forKey:NOTIFICATIONS_PAYMENT_PARMATERS];  // 推送摧付参数
        [us setInteger:[[NSStringUtils getCurrentTimestamp] integerValue] forKey:SAVE_NOTIFICATIONS_PARMATERS_TIME]; // 推送时间
        [us synchronize];
    }
}

// Reports app open from a Universal Link for iOS 9
- (BOOL) application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler
{
    [[AppsFlyerTracker sharedTracker] continueUserActivity:userActivity restorationHandler:restorationHandler];
    return YES;
}

@end
