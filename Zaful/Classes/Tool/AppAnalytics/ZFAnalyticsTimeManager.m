
//
//  ZFAnalyticsTimeManager.m
//  Zaful
//
//  Created by zhaowei on 2016/12/19.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "ZFAnalyticsTimeManager.h"

@implementation ZFAnalyticsTimeManager
+(ZFAnalyticsTimeManager *)sharedManager {
    static ZFAnalyticsTimeManager *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZFAnalyticsTimeManager alloc] init];
    });
    return sharedInstance;
}

- (void)logTimeWithEventName:(NSString*)name
{
#ifdef googleAnalyticsV3Enabled
    if (!_recodeTimeDict) {
        _recodeTimeDict = [[NSMutableDictionary alloc] init];
    }
    [_recodeTimeDict setObject:[NSDate date] forKey:name];
    
    NSString *comparedKey = nil;
    NSString *cateName = nil;
    NSString *key = nil;
    NSString *label = nil;
    
    if ([name isEqualToString:kFinishLaunching]) {
        comparedKey = kStartLaunching;
        cateName = @"Initialization";
        key = @"Initialization";
        label = @"Initialization";
    }else if ([name isEqualToString:kFinishLoadingHomeContent]) {
        comparedKey = kStartLoadingHomeContent;
        cateName = @"Home - Loadtime";
        key = @"Home - Loadtime";
        label = @"Home - Loadtime";
    }else if ([name isEqualToString:kFinishLoadingCategories]) {
        comparedKey = kStartLoadingCategories;
        cateName = @"Categories - Loadtime";
        key = @"Categories - Loadtime";
        label = @"Categories - Loadtime";
    }else if ([name isEqualToString:kFinishLoadingCategory]) {
        comparedKey = kStartLoadingCategory;
        cateName = @"Cate - Loadtime";
        key = @"Cate - Loadtime";
        label = @"Cate - Loadtime";
    }else if ([name isEqualToString:kFinishLoadingSearchList]) {
        comparedKey = kStartLoadingSearchList;
        cateName = @"Search - Loadtime";
        key = @"Search - Loadtime";
        label = @"Search - Loadtime";
    }else if ([name isEqualToString:kFinishLoadingProductDetail]) {
        comparedKey = kStartLoadingProductDetail;
        cateName = @"Product Detail - Loadtime";
        key = @"Product Detail - Loadtime";
        label = @"Product Detail Load Time";
    }else if ([name isEqualToString:kFinishLoadingCartList]) {
        comparedKey = kStartLoadingCartList;
        cateName = @"Bag - Loadtime";
        key = @"Bag - Loadtime";
        label = @"Bag - Loadtime";
    }else if ([name isEqualToString:kFinishLoadingOrderDetail]) {
        comparedKey = kStartLoadingOrderDetail;
        cateName = @"Order - Loadtime";
        key = @"Order - Loadtime";
        label = @"Order - Loadtime";
    }else if ([name isEqualToString:kFinishLoadingCreateOrder]) {
        comparedKey = kStartLoadingCreateOrder;
        cateName = @"Generate Order - Loadtime";
        key = @"Generate Order - Loadtime";
        label = @"Generate Order - Loadtime";
    }else if ([name isEqualToString:kFinishLoadingSignIn]) {
        comparedKey = kStartLoadingSignIn;
        cateName = @"Sign In - Loadtime";
        key = @"Sign In - Loadtime";
        label = @"Sign In - Loadtime";
    }else if ([name isEqualToString:kFinishLoadingSignUp]) {
        comparedKey = kStartLoadingSignUp;
        cateName = @"Sign Up - Loadtime";
        key = @"Sign Up - Loadtime";
        label = @"Sign Up - Loadtime";
    }
    
    if (comparedKey) {
        [ZFAnalytics logSpeedWithCategory:cateName eventName:key interval:[[NSDate date] timeIntervalSinceDate:_recodeTimeDict[comparedKey]] label:label];
    }
#endif
}

@end
