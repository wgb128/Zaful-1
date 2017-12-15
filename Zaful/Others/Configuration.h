//
//  Configuration.h
//  Zaful
//
//  Created by zhaowei on 2017/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#ifndef Configuration_h
#define Configuration_h

//--------------------------------------------------Model Config--------------------------------------

#define        isOpenDebugConfig      // 是否打开环境切换功能, 发版本要注释掉这一行  切到正式环境
#define        debugUseLocalhost    1 // App主站类型 0 : 测试   1 : 预发布


#ifdef DEBUG //是否是debug模式
    #ifdef         isOpenDebugConfig //如果定义了 isOpenDebugConfig
        #define    isFormalhost    (([[NSUserDefaults standardUserDefaults] objectForKey:DebugConfigKey]) ? ([[NSUserDefaults standardUserDefaults] integerForKey:DebugConfigKey]) : (debugUseLocalhost))
        #define    preRelease      (([[NSUserDefaults standardUserDefaults] objectForKey:PreConfigKey])   ? ([[NSUserDefaults standardUserDefaults] integerForKey:PreConfigKey])   : (debugUseLocalhost))
        #define    isTrunkHost     (([[NSUserDefaults standardUserDefaults] objectForKey:TrunkConfigKey])   ? ([[NSUserDefaults standardUserDefaults] integerForKey:TrunkConfigKey])   : (0))
    #else
        #define    isFormalhost     1
        #define    preRelease       0
        #define    isTrunkHost      0
    #endif

#else
    //App主站类型 0 : 测试   1 : 正式
    #define        isFormalhost   1
    #define        preRelease     0
    #define        isTrunkHost    0
#endif

// 1为加密   0不加密 
#define ISENC @"1"

//--------------------------------------------------Configration Key--------------------------------------
#define DebugConfigKey             @"localHostConfig"
#define PreConfigKey               @"preReleaseConfig"
#define TrunkConfigKey             @"trunkConfigKey"
#define kCfgItunesAppId            @"itunesAppId"
#define kCfgAppBaseURL             @"appBaseURL"
#define kCfgDevAppBaseURL          @"devAppBaseURL"
#define kCfgH5BaseURL              @"h5BaseURL"
#define kCfgDevH5BaseURL           @"devh5BaseURL"
#define kCfgCommentURL             @"commentURL"
#define kCfgDevCommentURL          @"devCommentURL"
#define kCfgCommunityURL           @"communityURL"
#define kCfgDevCommunityURL        @"devCommunityURL"
#define kCfgCardIntroURL           @"cardIntroURL"
#define kCfgDevCardIntroURL        @"devcardIntroURL"
#define kCfgCommunityPostURL       @"communityPostURL"
#define kCfgDevCommunityPostURL    @"devCommunityPostURL"
#define kCfgCommunityIntroURL      @"communityIntroURL"
#define kCfgDevCommunityIntroURL   @"devcommunityIntroURL"
#define kCfgCommunityShareURL      @"communityShareURL"
#define kCfgDevCommunityShareURL   @"devcommunityShareURL"

#define kCfgAuthQuickPayURL        @"authQuickPayURL"
#define kCfgDevAuthQuickPayURL     @"devauthQuickPayURL"

#define kCfgReviewPostURL          @"reviewPostURL"
#define kCfgDevReviewPostURL       @"devReviewPostURL"

#define kCfgDevAppsFlyerKey        @"devAppsFlyerKey"
#define kCfgAppsFlyerKey           @"devAppsFlyerKey"

//DES加密（key与偏移）
#define kCfgDesEncrypt_key         @"DesEncrypt_key"
#define kCfgDesEncrypt_iv          @"DesEncrypt_iv"

//header 私钥
#define kPrivateKey                @"PrivateKey"
#define kDevPrivateKey             @"DevPrivateKey"

//Bugly
#define kCfgDevBuglyAppId          @"DevBuglyAppId"
#define kCfgBuglyAppId             @"BuglyAppId"

//leanCloud推送
#define kCfgLeanCloudApplicationID       @"leanCloudApplicationID"
#define kCfgLeanCloudClientKey           @"leanCloudClientKey"
#define kCfgDevLeanCloudApplicationID    @"DevleanCloudApplicationID"
#define kCfgDevLeanCloudClientKey        @"DevleanCloudClientKey"

#define kCfgDevBaseHost  [NSString stringWithFormat:@"http://app-zaful.com.%@.s1.egomsl.com/api_ios/", isTrunkHost ? @"trunk" : @"a"]
#define ZF_CONFIGRATION @{\
    kCfgItunesAppId                 :@"1078789949",\
    kCfgAppBaseURL                  :@"https://app.zaful.com/api_ios/",\
    kCfgDevAppBaseURL               :kCfgDevBaseHost,\
    \
    kCfgH5BaseURL                   :@"https://m.zaful.com/",\
    kCfgDevH5BaseURL                :@"http://wap-zaful.com.c.s1.egomsl.com/",\
    \
    kCfgCommentURL                  :@"https://admin.reuew.com/api-zaful/index?site=zaful",\
    kCfgDevCommentURL               :@"http://review.com.trunk.s1cg.egomsl.com/api-zaful/index?site=zaful",\
    \
    kCfgCardIntroURL                :@"http://m.zaful.com/index.php?m=app_h5&a=introduce_idcard&lang=%@",\
    kCfgDevCardIntroURL             :@"http://wap-zaful.com.c.s1.egomsl.com/index.php?m=app_h5&a=introduce_idcard&lang=%@",\
    kCfgCommunityURL                :@"https://admin.reuew.com/api-zaful-community/index?site=zafulcommunity",\
    kCfgDevCommunityURL             :@"http://review.com.trunk.s1cg.egomsl.com/api-zaful-community/index?site=zafulcommunity",\
    kCfgCommunityPostURL            :@"https://admin.reuew.com/api-zaful-community/post-pic?site=zafulcommunity",\
    kCfgDevCommunityPostURL         :@"http://review.com.trunk.s1cg.egomsl.com/api-zaful-community/post-pic?site=zafulcommunity",\
    kCfgReviewPostURL               :@"https://admin.reuew.com/api-zaful/post-pic?site=zaful",\
    kCfgDevReviewPostURL            :@"http://review.com.trunk.s1cg.egomsl.com/api-zaful/post-pic?site=zaful",\
    kCfgCommunityIntroURL           :@"https://m.zaful.com/m-app_h5-a-ios.htm",\
    kCfgDevCommunityIntroURL        :@"http://wap-zaful.com.b.s1.egomsl.com/m-app_h5-a-ios.htm",\
    kCfgCommunityShareURL           :@"https://m.zaful.com/m-app_h5-a-app_download.htm",\
    kCfgDevCommunityShareURL        :@"http://wap-zaful.com.b.s1.egomsl.com/m-app_h5-a-app_download.htm",\
    \
    kCfgAuthQuickPayURL             :@"https://app.zaful.com/pay/quick?",\
    kCfgDevAuthQuickPayURL          :@"http://app-zaful.com.a.s1.egomsl.com/pay/quick?",\
    \
    kCfgBuglyAppId                  :@"4c08b49354",\
    kCfgDevBuglyAppId               :@"d1e7201457",\
    kCfgAppsFlyerKey                :@"PQmjs6dfikqatrWRQ4EEG",\
    kCfgDevAppsFlyerKey             :@"PQmjs6dfikqatrWRQ4EEG",\
    kCfgDesEncrypt_key              :@"su@~5^j.j5%nc1)j2&f.sa5_",\
    kCfgDesEncrypt_iv               :@"!3F*;)d1",\
    kPrivateKey                     :@"#DQud9%*6o0mNW2FLFuL!7hepn4t30YG",\
    kDevPrivateKey                  :@"sICDiuViEM7QIf1y83!tAiJUV^XKO*N$",\
    \
    kCfgLeanCloudApplicationID      :@"ldXsItSBa4rrMwf9JLLiz74K-MdYXbMMI",\
    kCfgLeanCloudClientKey          :@"VPS0kjiDycHULHOQcPVzT6u1",\
    kCfgDevLeanCloudApplicationID   :@"jj3cOE5IfCEElRmY5FbNxw7c-MdYXbMMI",\
    kCfgDevLeanCloudClientKey       :@"CE0HuCA5ofkJVM5UdVfvqPXV",\
}\

//kCfgLeanCloudApplicationID      :@"ldXsItSBa4rrMwf9JLLiz74K-MdYXbMMI",\ //推送正式key
//kCfgLeanCloudClientKey          :@"VPS0kjiDycHULHOQcPVzT6u1",\
//kCfgDevLeanCloudApplicationID   :@"jj3cOE5IfCEElRmY5FbNxw7c-MdYXbMMI",\//推送测试key
//kCfgDevLeanCloudClientKey       :@"CE0HuCA5ofkJVM5UdVfvqPXV",\
//kCfgGATrackingId                :@"UA-55634609-3",\
//kCfgDevGATrackingId             :@"UA-87302294-3",\


//UA-55634609-3
#define SITE_CONFIG(key)    ZF_CONFIGRATION[key]

#define kCfgAppId           SITE_CONFIG(kCfgItunesAppId)
#define AppBaseURL          SITE_CONFIG(isFormalhost ? kCfgAppBaseURL     : kCfgDevAppBaseURL)
#define H5BaseURL           SITE_CONFIG(isFormalhost ? kCfgH5BaseURL     : kCfgDevH5BaseURL)
#define CommentURL          SITE_CONFIG(isFormalhost ? kCfgCommentURL     : kCfgDevCommentURL)
#define CardIntroURL        SITE_CONFIG(isFormalhost ? kCfgCardIntroURL    : kCfgDevCardIntroURL)
#define CommunityURL        SITE_CONFIG(isFormalhost ? kCfgCommunityURL   : kCfgDevCommunityURL)
#define CommunityPostURL    SITE_CONFIG(isFormalhost ? kCfgCommunityPostURL   : kCfgDevCommunityPostURL)
#define CommunityIntroURL   SITE_CONFIG(isFormalhost ? kCfgCommunityIntroURL    : kCfgDevCommunityIntroURL)
#define CommunityShareURL   SITE_CONFIG(isFormalhost ? kCfgCommunityShareURL    : kCfgDevCommunityShareURL)
#define ReviewPostURL       SITE_CONFIG(isFormalhost ? kCfgReviewPostURL   : kCfgDevReviewPostURL)
#define AuthQuickPayURL     SITE_CONFIG(isFormalhost ? kCfgAuthQuickPayURL    : kCfgDevAuthQuickPayURL)
#define PrivateKey          SITE_CONFIG(isFormalhost ? kPrivateKey    : kDevPrivateKey)


//appsFlyer analytics
#define kAppsFlyerKey       SITE_CONFIG(isFormalhost ? kCfgAppsFlyerKey : kCfgDevAppsFlyerKey)
//听云
#define kNBSAgentKey        SITE_CONFIG(isFormalhost ? kCfgNBSAgentKey : kCfgDevNBSAgentKey)
//Bugly
#define kBuglyAppId         SITE_CONFIG(isFormalhost ? kCfgBuglyAppId : kCfgDevBuglyAppId)
//LeanCloud
#define kLeanCloudApplicationID  SITE_CONFIG(isFormalhost ? kCfgLeanCloudApplicationID : kCfgDevLeanCloudApplicationID)
#define kLeanCloudClientKey      SITE_CONFIG(isFormalhost ? kCfgLeanCloudClientKey : kCfgDevLeanCloudClientKey)

// DES加密（key与偏移）
#define kDesEncrypt_key         SITE_CONFIG(kCfgDesEncrypt_key)
#define kDesEncrypt_iv          SITE_CONFIG(kCfgDesEncrypt_iv)

//-----------------------------------支付拦截配置------------------------------------------
//支付开发环境
#define PAY_DEV_SUCCESS                 @"/m-flow-a-dopaypal.htm"
#define MY_ACCOUNT_BACK_DEV_URL         @"/m-users-a-index.htm"
#define RETURN_TO_HOME_BACK_DEV_URL     @"/m-flow-a-payok.htm"
//EBANX支付成功
#define PAY_EBANX_DEV_SUCCESS           @"/m-ebanx-a-response.html"

#define PAY_DEV_FAIL1                   @"/?from=ios"
#define PAY_DEV_FAIL2                   @"/m-flow-a-fails.htm"
#define PAY_DEV_FAIL3                   @"/pay/error"
#define PAY_DEV_FAIL4                   @"/m-flow-a-refuse.htm"
#define PAYPAL_CANCEL_DEV               @"/shopping-cart.html"

//EBANX支付取消
#define PAY_EBANX_DEV_CANCEL            @"/m-flow-a-cart.htm"

//支付正式环境
#define PAY_SUCCESS                     @"/m-flow-a-dopaypal.htm"
#define MY_ACCOUNT_BACK_URL             @"/m-flow-a-payok.htm"
#define RETURN_TO_HOME_BACK_URL         @"/m-flow-a-payok.htm"

//EBANX支付成功
#define PAY_EBANX_SUCCESS               @"/m-ebanx-a-response.html"

#define PAY_FAIL1                       @"/?from=ios"
#define PAY_FAIL2                       @"/m-flow-a-fails.htm"
#define PAY_FAIL3                       @"/m-flow-a-fails.htm"
#define PAY_FAIL4                       @"/m-flow-a-refuse.htm"
#define PAY_FAIL5                       @"/m-flow-a-refuse.htm"
#define PAYPAL_CANCEL                   @"/shopping-cart.html"

//EBANX支付取消
#define PAY_EBANX_CANCEL                @"/m-flow-a-cart.htm"

//快捷支付
#define QUICK_FILTER_CATCH_URL          @"/pay/success/?token="

#define QUICK_FILTER_CANCEL_URL         @"/pay/fail/?token="
//-----------------------------------GA帐号配置------------------------------------------

//google analytics
#define kCfgGATrackingId           @"GoogleTrackingId"
#define kCfgDevGATrackingId        @"devGoogleTrackingId"


//google analytics

#define ZF_GA_DEFAULT ZF_GA_CONFIG[@"en"][isFormalhost ? kCfgGATrackingId : kCfgDevGATrackingId]

#define ZF_GA_CURRENT ZF_GA_CONFIG[[ZFLocalizationString shareLocalizable].nomarLocalizable][isFormalhost ? kCfgGATrackingId : kCfgDevGATrackingId]

#define kTrackingId ZF_GA_CURRENT == nil ? ZF_GA_DEFAULT : ZF_GA_CURRENT

#define ZF_GA_CONFIG @{\
    @"en" : @{\
                kCfgGATrackingId                :@"UA-55634609-3",\
                kCfgDevGATrackingId             :@"UA-87302294-3",\
            },\
    @"ar" : @{\
                kCfgGATrackingId                :@"UA-55634609-9",\
                kCfgDevGATrackingId             :@"UA-87302294-5",\
            },\
    @"es" : @{\
                kCfgGATrackingId                :@"UA-55634609-14",\
                kCfgDevGATrackingId             :@"UA-87302294-3",\
            }   ,\
    @"fr" : @{\
                kCfgGATrackingId                :@"UA-55634609-12",\
                kCfgDevGATrackingId             :@"UA-87302294-3",\
            },\
}\

// Appflyer数据
#define MEDIA_SOURCE    @"media_source"
#define CAMPAIGN        @"campaign"
#define LKID            @"lkid"
#define FIRST_LOAD      @"firstLoad"
#define ADID            @"ad_id"
#define APPFLYER_ALL_PARAMS @"APPFLYER_ALL_PARAMS"

#define NOTIFICATIONS_PAYMENT_PARMATERS   @"notificationPaymentParmaters"
#define SAVE_NOTIFICATIONS_PARMATERS_TIME @"saveNotificationsParmatersTime"


#endif /* Configuration_h */
