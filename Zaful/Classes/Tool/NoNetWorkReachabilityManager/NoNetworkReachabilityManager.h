//
//  NoNetworkReachabilityManager.h
//  Zaful
//
//  Created by liuxi on 2017/9/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoNetworkReachabilityManager : NSObject

@property (nonatomic, assign, readonly) AFNetworkReachabilityStatus   networkStatus;

@property (nonatomic, assign) BOOL      openReachability;

+ (instancetype)shareManager;
@end
