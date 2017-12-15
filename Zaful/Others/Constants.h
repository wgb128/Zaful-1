//
//  Constants.h
//  Zaful
//
//  Created by Y001 on 16/9/13.
//  Copyright © 2016年 Y001. All rights reserved.
//®
#ifndef Constants_h
#define Constants_h

#define kSQLiteDBName   @"Zaful.sqlite"      // 数据库名

//App版本
#define APPVIERSION @"APPVIERSION"
// 版本号
#define ZFSYSTEM_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 系统版本
#define IPHONE_ZFSYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
// 屏幕大小
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define mas_equalTo(...) equalTo(MASBoxValue((__VA_ARGS__)))

#define DSCREEN_HEIGHT_SCALE SCREEN_HEIGHT / 568.0
#define DSCREEN_WIDTH_SCALE SCREEN_WIDTH / 375.0

#define IPHONE_4X_3_5 (SCREEN_HEIGHT==480.0f)

#define IPHONE_5X_4_0 (SCREEN_HEIGHT==568.0f)

#define IPHONE_6X_4_7 (SCREEN_HEIGHT==667.0f)

#define IPHONE_6P_5_5 (SCREEN_HEIGHT==736.0f || SCREEN_WIDTH==414.0f)

#define IPHONE_7P_5_5 (SCREEN_HEIGHT==736.0f)

#define IPHONE_X_5_15 (SCREEN_WIDTH == 375.0f && SCREEN_HEIGHT == 812.0f)

#define NAVBARHEIGHT    self.navigationController.navigationBar.frame.size.height
#define STATUSHEIGHT    [UIApplication sharedApplication].statusBarFrame.size.height

// 时间
#define sec_per_min     60
#define sec_per_hour    3600
#define sec_per_day     86400
#define sec_per_month   2592000
#define sec_per_year    31104000

// end
#define ISIOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) // IOS7的系统
#define ISIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) // IOS7的系统
#define ISIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) // IOS8的系统
#define ISIOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) // IOS9的系统
#define ISIOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) // IOS11的系统

#define BADGE_BACKGROUNDCOLOR [UIColor colorWithRed:183/255.0 green:96/255.0 blue:42/255.0 alpha:1.0]
#define THEME_COLOR [UIColor colorWithRed:255/255.0 green:168/255.0 blue:0/255.0 alpha:1.0]
// 颜色
#define ZFCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

//设置颜色 示例：ColorHex(0x26A7E8)
#define ColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//设置颜色与透明度 示例：ColorHEX_Alpha(0x26A7E8, 0.5)
#define ColorHex_Alpha(rgbValue, al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

// 随机颜色
#define ZFCOLOR_RANDOM [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1.0]

#define URLENCODING(s)  [s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

// Directory 目录
#define ZFPATH_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// Cache 目录
#define ZFPATH_CACHE [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
// 数据库 目录
#define ZFPATH_DATABASE_CACHE [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// userId
#define USERID          [[AccountManager sharedManager] userId]
#define TOKEN           [[AccountManager sharedManager] token]
#define SESSIONID       [[NSUserDefaults standardUserDefaults] objectForKey:kSessionId] == nil ? @"" :[[NSUserDefaults standardUserDefaults] objectForKey:kSessionId]
// 通知
#define addEventListener(observer,selector,name,objectName)     [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:objectName]
#define removeEventListener(observer,name,objectName)           [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:objectName]
#define removeAllEventListener(observer)                        [[NSNotificationCenter defaultCenter] removeObserver:observer]
#define postEvent(name,objectName)                              [[NSNotificationCenter defaultCenter] postNotificationName:name object:objectName]
#define postEventWithData(name,objectName,userInfo)             [[NSNotificationCenter defaultCenter] postNotificationName:name object:objectName userInfo:userInfo]

//自定义Log
#ifdef DEBUG
    // 判断是真机还是模拟器
    #if TARGET_OS_IPHONE
    //iPhone Device
        #define ZFLog(fmt, ...) fprintf(stderr,"%s: %s [Line %d]\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);
    #elif TARGET_IPHONE_SIMULATOR
    //iPhone Simulator
        #define ZFLog(arg,...) NSLog(@"%s " arg ,__PRETTY_FUNCTION__, ##__VA_ARGS__)
    #endif
#else
    #define ZFLog(...)
#endif

#define SCREENSCALE         [UIScreen mainScreen].scale
#define KScale [UIScreen mainScreen].scale
#define MIN_PIXEL           1.0/SCREENSCALE
#define KLineHeight 1.0/KScale

#define SCREEN_WIDTH_SCALE      KScreenWidth / 375.0

#define KScreenWidth  [UIScreen mainScreen].bounds.size.width

#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

//请求路径
#define ENCPATH [NSStringUtils buildRequestPath:@""]


// 白颜色
#define ZFCOLOR_WHITE [UIColor whiteColor]
//黑色
#define ZFCOLOR_BLACK [UIColor blackColor]
// 主颜色  橘黄色
#define ZFMAIN_COLOR  ColorHex(0xffda35)
//字体加粗
#define FONT_BOLD @"Helvetica-Bold"
#define FONT_HIGHT @"STHeitiTC-Light"

#define NullFilter(s) [NSStringUtils emptyStringReplaceNSNull:s]

#define RegularExpression @"#([^\\s]+)\\s"

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#define SHAREDAPP       [UIApplication sharedApplication]
#define APPDELEGATE     ((AppDelegate*)[SHAREDAPP delegate])
#define WINDOW          [[UIApplication sharedApplication].delegate window]

#endif /* Constants_h */
