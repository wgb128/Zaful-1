


//
//  NoNetworkReachabilityManager.m
//  Zaful
//
//  Created by liuxi on 2017/9/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "NoNetworkReachabilityManager.h"
#import "AFNetworkReachabilityManager.h"

@interface NoNetworkReachabilityManager() {
    AFNetworkReachabilityManager *_reachabilityManager;
}
@property (nonatomic, assign) AFNetworkReachabilityStatus   networkStatus;
@end

@implementation NoNetworkReachabilityManager
#pragma mark - init methods
+ (instancetype)shareManager {
    static NoNetworkReachabilityManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NoNetworkReachabilityManager alloc] init];
    });
    return manager;
}

#pragma mark - private methods
- (void)networkReachability {
    _reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    @weakify(self);
    [_reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        self.networkStatus = status;

        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: { // 未知网络
                ZFLog(@"未知网络");
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: { // 没有网络(断网)
                ZFLog(@"没有网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: { // 手机自带网络
                ZFLog(@"手机自带网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: { // WIFI
                ZFLog(@"WIFI网络");
                break;
            }
        }
    }];
    [_reachabilityManager startMonitoring];
}

#pragma mark - setter
- (void)setOpenReachability:(BOOL)openReachability {
    _openReachability = openReachability;
    if (_openReachability) {
        [self networkReachability];
    } else {
        [_reachabilityManager stopMonitoring];
    }
}

@end
